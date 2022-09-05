//
//  SignInView.swift
//  GMagnet
//
//  Created by Giang Le on 01/09/2022.
// Acknowledgement: https://blckbirds.com/post/user-authentication-with-swiftui-and-firebase/

import SwiftUI
import Firebase
import GoogleSignInSwift
import GoogleSignIn

struct SignInView: View {
    @State var email = ""
    @State var password = ""
    let gameColor = GameColor()
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @State var emailErrorMessage = ""
    @State var passwordErrorMessage = ""
    
    func validateEmail() {
        do  {
            let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$"#
            let emailRegex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: email.count)
            if (email == "") {
                emailErrorMessage = "Email must not be empty"
            } else if emailRegex.firstMatch(in: email, range: range) != nil {
                currentUser.validateEmail(email: email) { result in
                    if result {
                        emailErrorMessage = ""
                        validatePassword()
                        
                    } else {
                        emailErrorMessage = "Incorrect email address"
                    }
                }
            } else {
                emailErrorMessage = "Invalid email"
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func validatePassword() {
        do  {
            let pattern = #"^[A-Za-z][A-Za-z0-9!@#$%&]{7,15}$"#
            let passRegex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: password.count)
            if (password == "") {
                passwordErrorMessage = "Password must not be empty"
            } else if passRegex.firstMatch(in: password, range: range) != nil {
                passwordErrorMessage = ""
                if emailErrorMessage == "" && passwordErrorMessage == "" {
                    currentUser.signInUser(userEmail: email, userPassword: password){
                        result in
                        if !result {
                            passwordErrorMessage = "Incorrect password"
                        }
                    }
                }
            } else {
                passwordErrorMessage = "Special characters (!, @, #, $, %, &, *) are allowed. Range length between 8 to 15. Cannot contain space"
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack{
            
            Text("Sign in")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .kerning(1.9)
                .frame(maxWidth: .infinity,  alignment: .leading)
            VStack(alignment: .leading, spacing: 8, content: {
                HStack {
                    Text("Email")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    Text(emailErrorMessage)
                        .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
                }
                TextField("ijustine@gmail.com", text: $email)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,25)
            VStack(alignment: .leading, spacing: 8, content: {
                HStack {
                    Text("Password")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    Text(passwordErrorMessage != "a" ? passwordErrorMessage : "")
                        .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
                }
                SecureField("12345", text: $password)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,20)
            
            Button(action: {},label: {
                Text("Forgot password?")
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            HStack (spacing: 5){
                Button(action: {
                    validateEmail()
                }, label:{
                    Image(systemName: "arrow.right")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: gameColor.cyan.opacity(0.6), radius: 5, x: 0, y: 0)
                })
                
                Button(action: {
                    currentUser.signInWithGoogle()
                }, label:{
                    Image("google")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(color: gameColor.cyan.opacity(0.6), radius: 5, x: 0, y: 0)
                })
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10)
            Spacer()
        }
        .padding()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
