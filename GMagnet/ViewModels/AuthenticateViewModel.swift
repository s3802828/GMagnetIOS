//
//  AuthenticateViewModel.swift
//  GMagnet
//
//  Created by Giang Le on 05/09/2022.
//

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
    override init(){
        super.init()
        locationManager.delegate = self
    }
    func requestAllowOnceLocationPermission(){
        locationManager.requestAlwaysAuthorization()
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

            switch manager.authorizationStatus {

            case .denied :
                // Alert
                print("Denied")
                manager.requestLocation()

            case .restricted:
                print("restricted")
                manager.requestLocation()

            case .notDetermined:
                // Request
                print("not Determined")
                manager.requestWhenInUseAuthorization()

            case .authorizedWhenInUse :
                print("Authorized when in use")
                manager.allowsBackgroundLocationUpdates = true
                manager.startUpdatingLocation()
                manager.requestLocation()
            case .authorizedAlways:
                manager.requestLocation()
                print("Alwayssssss")
            default:
                manager.requestLocation()
                print("Default")
            }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let latestLocation = locations.first else {
            print("ERror allow")
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
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("ERRORORORORO")
        print(error.localizedDescription)
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
    func signInUser(userEmail: String, userPassword: String, completion: @escaping (Bool) -> Void) {
        self.isLoggingIn = true
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                if error?.localizedDescription == "The password is invalid or the user does not have a password."{
                    completion(false)
                    self.isLoggingIn = false
                }
                return
            }
            switch authResult {
            case .none:
                print("Could not sign in user.")
                self.isLoggingIn = false
            case .some(_):
                print("User signed in")
                self.refreshCurrentUser()
                self.isLoggingIn = false
            }
            
        }
    }
    
    func signInWithGoogle() {
        self.isLoggingIn = true
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
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
                Auth.auth().signIn(with: credential) { (_, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        self.isLoggingIn = false
                    } else {
                        User.get_user(user_id: Auth.auth().currentUser?.uid ?? "") { user in
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
                            } else {
                                self.refreshCurrentUser()
                                self.isLoggingIn = false
                            }
                        }
                    }
                }
            }
    }
    
    func validateUsername(username: String, completion: @escaping (Bool) -> Void){
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
    func validateEmail(email: String, completion: @escaping (Bool) -> Void){
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
    
    func refreshCurrentUser() {
        User.get_user(user_id: Auth.auth().currentUser?.uid ?? ""){ user in
            self.currentUser = user
        }
    }
    
    func signOutUser(){
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            isLoggingIn = false
        } catch {
            print("Already logged out")
        }
    }
    
    func signUpUser(userEmail: String, userPassword: String, username: String, fullname: String) {
        self.isLoggingIn = true
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                self.isLoggingIn = false
                return
            }
            switch authResult {
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
