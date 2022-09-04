//
//  SignUpView.swift
//  GMagnet
//
//  Created by Giang Le on 01/09/2022.
// Acknowledgement: https://blckbirds.com/post/user-authentication-with-swiftui-and-firebase/

import SwiftUI
import Firebase
import FirebaseFirestore

struct SignUpView: View {
    @State var signUpProcessing = false
    @State var fullname = ""
    @State var username = ""
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    let db = Firestore.firestore()
    let gameColor = GameColor()
    func signUpUser() {
        signUpProcessing = true
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
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
                // Add a new document in collection "users"
                let userId = Auth.auth().currentUser?.uid
                let newUser = User(id: userId ?? "", username: username, email: email, name: fullname, avatar: "", description: "", joined_forums: [], posts: [])
                db.collection("users").document(userId ?? "").setData(newUser.to_dictionary()) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("User successfully added!")
                    }
                }
                signUpProcessing = false
            }
        }
    }
    var body: some View {
        
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
                Text("Username")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                TextField("henry234", text: $username)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
                Text("Email")
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
            
            Button(action: {
                signUpUser()
            }, label:{
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
