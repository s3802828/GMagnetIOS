//
//  SignUpView.swift
//  GMagnet
//
//  Created by Giang Le on 01/09/2022.
// Acknowledgement: https://blckbirds.com/post/user-authentication-with-swiftui-and-firebase/

import SwiftUI
import Firebase

struct SignUpView: View {
    @State var signUpProcessing = false
    func signUpUser(userEmail: String, userPassword: String) {
        signUpProcessing = true
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            guard error == nil else {
                signUpProcessing = false
                return
            }
            
            switch authResult {
                    case .none:
                        print("Could not create account.")
                        signUpProcessing = false
                    case .some(_):
                        print("User created")
                        signUpProcessing = false
                    }
        }
    }
    var body: some View {
        Button(action: {
            signUpUser(userEmail: "quynhgiangle206@gmail.com", userPassword: "abc1234!")
        }) {
            Capsule()
                .overlay(Text("Sign Up"))
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
