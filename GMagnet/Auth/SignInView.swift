//
//  SignInView.swift
//  GMagnet
//
//  Created by Giang Le on 01/09/2022.
// Acknowledgement: https://blckbirds.com/post/user-authentication-with-swiftui-and-firebase/

import SwiftUI
import Firebase

struct SignInView: View {
    @State var signInProcessing = false
    func signInUser(userEmail: String, userPassword: String) {
        
        signInProcessing = true
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            
            guard error == nil else {
                signInProcessing = false
                print(error?.localizedDescription ?? "")
                return
            }
            switch authResult {
            case .none:
                print("Could not sign in user.")
                signInProcessing = false
            case .some(_):
                print("User signed in")
                signInProcessing = false
            }
            
        }
    }
    var body: some View {
        Button(action: {
            signInUser(userEmail: "quynhgiangle206@gmail.com", userPassword: "abc1234")
        }) {
            Capsule()
                .overlay(Text("Sign Up"))
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
