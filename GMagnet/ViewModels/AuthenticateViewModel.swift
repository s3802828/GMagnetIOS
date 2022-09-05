//
//  AuthenticateViewModel.swift
//  GMagnet
//
//  Created by Giang Le on 05/09/2022.
//

import Foundation
import Firebase

class AuthenticateViewModel : ObservableObject {
    @Published var currentUser : User
    let db = Firestore.firestore()
    init(){
        currentUser = User()
    }
    
    func signInUser(userEmail: String, userPassword: String) {
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            switch authResult {
            case .none:
                print("Could not sign in user.")
            case .some(_):
                print("User signed in")
                print(authResult ?? "")
                print(Auth.auth().currentUser?.uid ?? "")
            }
            
        }
    }
    
    func refreshCurrentUser() {
        User.get_user(user_id: Auth.auth().currentUser?.uid ?? ""){ user in
            self.currentUser = user
        }
    }
    
    func signUpUser(userEmail: String, userPassword: String, username: String, fullname: String) {
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            guard error == nil else {
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
