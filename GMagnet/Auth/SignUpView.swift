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
    @State var fullname = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    let gameColor = GameColor()
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
//        Button(action: {
//            signUpUser(userEmail: "quynhgiangle206@gmail.com", userPassword: "abc1234!")
//        }) {
//            Capsule()
//                .overlay(Text("Sign Up"))
//        }
        
        VStack{
            
            Text("Sign up")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .kerning(1.9)
                .frame(maxWidth: .infinity,  alignment: .leading)
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Fullname")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                TextField("Pham van A", text: $fullname)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
                Text("User Name")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                TextField("ijustine@gmail.com", text: $email)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,25)
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Password")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                SecureField("12345", text: $password)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,20)
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Retype password")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                SecureField("12345", text: $confirmPassword)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,20)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            
            Button(action: {}, label:{
                Image(systemName: "arrow.right")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .clipShape(Circle())
                    .shadow(color: gameColor.cyan.opacity(0.6), radius: 5, x: 0, y: 0)
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top,10)
                Spacer()
            }
        .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
