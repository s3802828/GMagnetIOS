//
//  AuthenticateViewModel.swift
//  GMagnet
//
//  Created by Giang Le on 05/09/2022.
//

import Foundation
import Firebase
import GoogleSignIn

class AuthenticateViewModel : ObservableObject {
    @Published var currentUser : User
    let db = Firestore.firestore()
    let signInConfig = GIDConfiguration(clientID: "722163187237-vq7308i0o17skikm6t8eag54ed1bj3te.apps.googleusercontent.com")
    init(){
        currentUser = User()
    }
    
    func signInUser(userEmail: String, userPassword: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                if error?.localizedDescription == "The password is invalid or the user does not have a password."{
                    completion(false)
                }
                return
            }
            switch authResult {
            case .none:
                print("Could not sign in user.")
            case .some(_):
                print("User signed in")
                self.refreshCurrentUser()
            }
            
        }
    }
    
    func signInWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig, presenting: rootViewController) { user, error in
                
                guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
                let emailAddress = user?.profile?.email
                let fullName = user?.profile?.name
                let profilePicUrl = user?.profile?.imageURL(withDimension: 320)?.absoluteString
                let username = emailAddress?.components(separatedBy: "@")[0]
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                Auth.auth().signIn(with: credential) { (_, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        User.get_user(user_id: Auth.auth().currentUser?.uid ?? "") { user in
                            if user.id == "" {
                                let userId = Auth.auth().currentUser?.uid
                                
                                let newUser = User(id: userId ?? "", username: username ?? "", name: fullName ?? "", email: emailAddress ?? "", avatar: profilePicUrl ?? "", description: "", joined_forums: [], posts: [])
                                self.db.collection("users").document(userId ?? "").setData(newUser.to_dictionary()) { [self] err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                    } else {
                                        print("User successfully added!")
                                        self.currentUser = newUser
                                    }
                                }
                            } else {
                                self.refreshCurrentUser()
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
        self.currentUser = User()
        GIDSignIn.sharedInstance.signOut()
    }
    
    func signUpUser(userEmail: String, userPassword: String, username: String, fullname: String) {
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            switch authResult {
            case .none:
                print("Could not create account.")
            case .some(_):
                print("User created")
                // Add a new document in collection "users"
                let userId = Auth.auth().currentUser?.uid
                let newUser = User(id: userId ?? "", username: username, name: fullname, email: userEmail, avatar: "", description: "", joined_forums: [], posts: [])
                self.db.collection("users").document(userId ?? "").setData(newUser.to_dictionary()) { [self] err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("User successfully added!")
                        self.currentUser = newUser
                    }
                }
            }
        }
    }
    
}
