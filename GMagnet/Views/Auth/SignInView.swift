/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 01/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
- SwiftUI Login Page UI - Complex UI - SwiftUI Tutorials: https://www.youtube.com/watch?v=Ohr5oZW03Ok
 - Google Sign-In & Firebase Authentication Using SwiftUI: https://blog.codemagic.io/google-sign-in-firebase-authentication-using-swift/
 - User Authentication With SwiftUI And Firebase: https://blckbirds.com/post/user-authentication-with-swiftui-and-firebase/
*/

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
    //MARK: - Email input validation
    func validateEmail() {
        do  {
            let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$"#
            let emailRegex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: email.count)
            if (email == "") { // check if email input is empty
                emailErrorMessage = "Email must not be empty"
            } else if emailRegex.firstMatch(in: email, range: range) != nil { //if email input match the regex
                //validate email with database
                currentUser.validateEmail(email: email) { result in
                    //if input is passed, validate password
                    if result {
                        emailErrorMessage = ""
                        validatePassword()
                        
                    } else { //otherwise, show error message
                        emailErrorMessage = "Incorrect email address"
                    }
                }
            } else { //otherwise, show error message
                emailErrorMessage = "Invalid email"
            }
        } catch let error { // return error if any
            print(error.localizedDescription)
        }
    }
    //MARK: - Password input validation
    func validatePassword() {
        do  {
            let pattern = #"^[A-Za-z][A-Za-z0-9!@#$%&]{7,15}$"#
            let passRegex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: password.count)
            if (password == "") { // check if input is empty
                passwordErrorMessage = "Password must not be empty"
            } else if passRegex.firstMatch(in: password, range: range) != nil {//if input match the regex
                passwordErrorMessage = ""
                if emailErrorMessage == "" && passwordErrorMessage == "" {
                    currentUser.signInUser(userEmail: email, userPassword: password){ //validate password with database
                        result in
                        if !result { //if input isn't passed, show error message
                            passwordErrorMessage = "Incorrect password"
                        }
                    }
                }
            } else {//otherwise, show error message
                passwordErrorMessage = "Special characters (!, @, #, $, %, &, *) are allowed. Range length between 8 to 15. Cannot contain space"
            }
        } catch let error {// return error if any
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack{
            //MARK: - Sign in title
            Text("Sign in")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .kerning(1.9)
                .frame(maxWidth: .infinity,  alignment: .leading)
            //MARK: - Email input area
            VStack(alignment: .leading, spacing: 8, content: {
                HStack {
                    //label
                    Text("Email")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    //error message
                    Text(emailErrorMessage)
                        .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
                }
                //input field
                TextField("ijustine@gmail.com", text: $email)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,25)
            //MARK: - Password input area
            VStack(alignment: .leading, spacing: 8, content: {
                HStack {
                    //label
                    Text("Password")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    //error message
                    Text(passwordErrorMessage != "a" ? passwordErrorMessage : "")
                        .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
                }
                //input field
                SecureField("12345", text: $password)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,20)
            //MARK: - Buttons area
            HStack (spacing: 5){
                //Submit form button
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
                //Sign in with Google button
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
