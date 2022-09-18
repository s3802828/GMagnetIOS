/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 05/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
- Get data with Cloud Firestore: https://firebase.google.com/docs/firestore/query-data/get-data
- Add data to Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/add-data
- SwiftUI LocationButton - Get User Location | iOS 15: https://www.youtube.com/watch?v=P6ZUiH1IZlQ&t=935s
 - Google Sign-In & Firebase Authentication Using SwiftUI: https://blog.codemagic.io/google-sign-in-firebase-authentication-using-swift/
 - User Authentication With SwiftUI And Firebase: https://blckbirds.com/post/user-authentication-with-swiftui-and-firebase/

*/

import Foundation
import Firebase
import GoogleSignIn
import MapKit
import CoreLocation

class AuthenticateViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentUser : User = User()
    @Published var isLoggingIn : Bool = false
    let db = Firestore.firestore()
    let signInConfig = GIDConfiguration(clientID: "722163187237-vq7308i0o17skikm6t8eag54ed1bj3te.apps.googleusercontent.com")
    let locationManager = CLLocationManager()
    //MARK: - CLLocationManagerDelegate constructor
    override init(){
        super.init()
        locationManager.delegate = self
    }
    //MARK: - Request location
    func requestAllowOnceLocationPermission(){
        User.get_user(user_id: Auth.auth().currentUser?.uid ?? ""){ user in
            self.currentUser = user
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    //MARK: - User's location authentication status change event listener
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .denied :
                // when user denied
                print("Denied")
                //Only request location when user already signed in
                if Auth.auth().currentUser != nil{
                    manager.requestLocation()
                }
                case .restricted:
                    print("restricted")
                    if Auth.auth().currentUser != nil{
                        manager.requestLocation()
                    }
                //when hasn't asked
                case .notDetermined:
                    // Request
                    print("not Determined")
                    if Auth.auth().currentUser != nil{
                        manager.requestWhenInUseAuthorization()
                    }
                //when user allow once
                case .authorizedWhenInUse :
                    print("Authorized when in use")
                    if Auth.auth().currentUser != nil{
                        manager.requestLocation()
                    }
                //when user allow while in use/alway allow
                case .authorizedAlways:
                    if Auth.auth().currentUser != nil{
                        manager.requestLocation()
                    }
                    print("Alwayssssss")
                default:
                    if Auth.auth().currentUser != nil{
                        manager.requestLocation()
                    }
                    print("Default")
                }



        }
    //MARK: - Get location event listener
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let latestLocation = locations.first else {
            print("ERror allow")
            //Cannot get location, update user's current location to ""
            User.get_user(user_id: Auth.auth().currentUser?.uid ?? ""){ user in
                self.currentUser = user
                var currentUser = user
                currentUser.longitude = ""
                currentUser.latitude = ""
                User.update_user(updated_user: currentUser){user in
                    self.refreshCurrentUser()
                }
            }
            return
        }
        DispatchQueue.main.async {
            let currentLongitude = latestLocation.coordinate.longitude.magnitude
            let currentLatitude = latestLocation.coordinate.latitude.magnitude
            print(currentLongitude)
            print(currentLatitude)
            //update user's current location
            User.get_user(user_id: Auth.auth().currentUser?.uid ?? ""){ user in
                self.currentUser = user
                var currentUser = user
                currentUser.longitude = String(currentLongitude)
                currentUser.latitude = String(currentLatitude)
                User.update_user(updated_user: currentUser){user in
                    self.refreshCurrentUser()
                }
            }
        }
    }
    //MARK: - Get location failure event listener
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error: " + error.localizedDescription)
        //Cannot get location, update user's current location to ""
        User.get_user(user_id: Auth.auth().currentUser?.uid ?? ""){ user in
            self.currentUser = user
            var currentUser = user
            currentUser.longitude = ""
            currentUser.latitude = ""
            User.update_user(updated_user: currentUser){user in
                self.refreshCurrentUser()
            }
        }
    }
    //MARK: - Sign in user with email & password
    func signInUser(userEmail: String, userPassword: String, completion: @escaping (Bool) -> Void) {
        self.isLoggingIn = true //set to true to display progress view
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            //return error if any
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                if error?.localizedDescription == "The password is invalid or the user does not have a password."{
                    completion(false)
                    self.isLoggingIn = false
                }
                return
            }
            switch authResult {
            //cannot sign in user
            case .none:
                print("Could not sign in user.")
                self.isLoggingIn = false
            //successfully sign in user
            case .some(_):
                print("User signed in")
                self.refreshCurrentUser() //Refresh the current user
                self.isLoggingIn = false
            }
            
        }
    }
    //MARK: - Sign in with Google account
    func signInWithGoogle() {
        self.isLoggingIn = true //set to true to display progress view
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        //use google sign in package to get tokens
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig, presenting: rootViewController) { user, error in
                
                guard let authentication = user?.authentication, let idToken = authentication.idToken else {
                    self.isLoggingIn = false
                    return
                }
                let emailAddress = user?.profile?.email
                let fullName = user?.profile?.name
                let profilePicUrl = user?.profile?.imageURL(withDimension: 320)?.absoluteString
                let username = emailAddress?.components(separatedBy: "@")[0]
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                //Sign in with firebase and credential from google
                Auth.auth().signIn(with: credential) { (_, error) in
                    if let error = error {
                        //return error if any
                        print(error.localizedDescription)
                        self.isLoggingIn = false
                    } else {
                        //Check if the user has been in User table
                        User.get_user(user_id: Auth.auth().currentUser?.uid ?? "") { user in
                            //If not, create new user record for current user
                            if user.id == "" {
                                let userId = Auth.auth().currentUser?.uid
                                
                                let newUser = User(id: userId ?? "", username: username ?? "", name: fullName ?? "", email: emailAddress ?? "", avatar: profilePicUrl ?? "", description: "", joined_forums: [], posts: [], longitude: "", latitude: "")
                                self.db.collection("users").document(userId ?? "").setData(newUser.to_dictionary()) { [self] err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                        self.isLoggingIn = false
                                    } else {
                                        print("User successfully added!")
                                        self.currentUser = newUser
                                        self.isLoggingIn = false
                                    }
                                }
                            } else { //Otherwise, refresh current user
                                self.refreshCurrentUser()
                                self.isLoggingIn = false
                            }
                        }
                    }
                }
            }
    }
    //MARK: - Validate username
    func validateUsername(username: String, completion: @escaping (Bool) -> Void){
        //Check if current username is existed or not
        db.collection("users").whereField("username", isEqualTo: username).getDocuments(){ (snapshot, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                for doc in snapshot!.documents {
                    if doc.exists {
                        print(true)
                        completion(true)
                        return
                    }
                }
                completion(false)
            }
            
        }
    }
    //MARK: - Validate email
    func validateEmail(email: String, completion: @escaping (Bool) -> Void){
        //Check if current email is existed or not
        Auth.auth().fetchSignInMethods(forEmail: email) { signInMethods, error in
            if ((error) != nil) {
            completion(false)
          }
            if ((signInMethods?.contains(EmailPasswordAuthSignInMethod) == true)) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    //MARK: - Refresh current user
    func refreshCurrentUser() {
        //Get current user with firebase auth current uid to set to self.currentUser
        User.get_user(user_id: Auth.auth().currentUser?.uid ?? ""){ user in
            self.currentUser = user
        }
    }
    //MARK: - Sign out
    func signOutUser(){
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            isLoggingIn = false
        } catch {
            print("Already logged out")
        }
    }
    //MARK: - Sign up
    func signUpUser(userEmail: String, userPassword: String, username: String, fullname: String) {
        self.isLoggingIn = true
        //create new user in Firebase Auth
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            guard error == nil else {
                //return error if any
                print(error?.localizedDescription ?? "")
                self.isLoggingIn = false
                return
            }
            switch authResult {
                //Cannot create new account
            case .none:
                print("Could not create account.")
                self.isLoggingIn = false
            case .some(_):
                print("User created")
                // Add a new document in collection "users"
                let userId = Auth.auth().currentUser?.uid
                let newUser = User(id: userId ?? "", username: username, name: fullname, email: userEmail, avatar: "https://gmagnet-ios-storage03509-dev.s3.amazonaws.com/public/%C3%A2%C2%80%C2%94Pngtree%C3%A2%C2%80%C2%94man+default+avatar_5938280.png", description: "", joined_forums: [], posts: [], longitude: "", latitude: "")
                self.db.collection("users").document(userId ?? "").setData(newUser.to_dictionary()) { [self] err in
                    if let err = err {
                        print("Error writing document: \(err)")
                        self.isLoggingIn = false
                    } else {
                        print("User successfully added!")
                        self.currentUser = newUser
                        self.isLoggingIn = false
                    }
                }
            }
        }
    }
    
}
