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
    @State var emailErrorMessage = ""
    @State var fullnameErrorMessage = ""
    @State var usernameErrorMessage = ""
    @State var passwordErrorMessage = ""
    @State var confirmPasswordErrorMessage = ""
    @EnvironmentObject var currentUser : AuthenticateViewModel
    let gameColor = GameColor()
    
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
                        emailErrorMessage = "This email is existed."
                    } else {
                        emailErrorMessage = ""
                        validatePassword()
                    }
                }
            } else {
                emailErrorMessage = "Invalid email"
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func validateUsername() {
        do  {
            let pattern = #"^[A-Za-z][A-Za-z0-9_]{4,15}$"#
            let nameRegex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: username.count)
            if (username == "") {
                usernameErrorMessage = "Username must not be empty"
            } else if nameRegex.firstMatch(in: username, range: range) != nil {
                currentUser.validateUsername(username: username){
                    result in
                    if result == true {
                        usernameErrorMessage = "This username is existed"
                    } else {
                        usernameErrorMessage = ""
                        validateEmail()
                    }
                }
            } else {
                usernameErrorMessage = "Only _ is allowed. Range length between 5 to 15. Cannot contain space"
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func validateFullname() {
        do {
            let pattern = #"^[A-Za-z][A-Za-z0-9 '-]{0,30}$"#
            let nameRegex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: fullname.count)
            if (fullname == "") {
                fullnameErrorMessage = "Name must not be empty"
            } else if nameRegex.firstMatch(in: fullname, range: range) != nil {
                fullnameErrorMessage = ""
                validateUsername()
            } else {
                fullnameErrorMessage = "Characters (', -) are allowed. Maximun length up to 30"
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
                validateConfirmPassword()
            } else {
                passwordErrorMessage = "Special characters (!, @, #, $, %, &, *) are allowed. Range length between 8 to 15. Cannot contain space"
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func validateConfirmPassword() {
            if (confirmPassword != password) {
                confirmPasswordErrorMessage = "Confirm password not matched"
            } else {
                confirmPassword = ""
                if emailErrorMessage == "" && fullnameErrorMessage == "" && usernameErrorMessage == "" && passwordErrorMessage == "" && confirmPassword == "" {
                currentUser.signUpUser(userEmail: email, userPassword: password, username: username, fullname: fullname)
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
                HStack {
                    Text("Fullname")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    Text(fullnameErrorMessage)
                        .foregroundColor(.red)
                        .fixedSize(horizontal: false, vertical: true)
                }
                TextField("Pham Van A", text: $fullname)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
                HStack {
                    Text("Username")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    Text(usernameErrorMessage)
                        .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)                }
                TextField("henry234", text: $username)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
                HStack {
                    Text("Email")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    Text(emailErrorMessage)
                        .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)                }
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
                    Text(passwordErrorMessage)
                        .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)                }
                
                SecureField("12345", text: $password)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,20)
            VStack(alignment: .leading, spacing: 8, content: {
                HStack{
                    Text("Confirm Password")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    Text(confirmPasswordErrorMessage)
                        .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)                }
                SecureField("abcghi1234!", text: $confirmPassword)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,20)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            
            HStack (spacing: 5){
                Button(action: {
                    validateFullname()
                    
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
