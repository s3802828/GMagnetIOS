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
                        emailErrorMessage = "This email is existed."
                    } else { //otherwise, show error message
                        emailErrorMessage = ""
                        validatePassword()
                    }
                }
            } else { //otherwise, show error message
                emailErrorMessage = "Invalid email"
            }
        } catch let error { // return error if any
            print(error.localizedDescription)
        }
    }
    //MARK: - Username input validation
    func validateUsername() {
        do  {
            let pattern = #"^[A-Za-z][A-Za-z0-9_]{4,15}$"#
            let nameRegex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: username.count)
            if (username == "") { // check if input is empty
                usernameErrorMessage = "Username must not be empty"
            } else if nameRegex.firstMatch(in: username, range: range) != nil {
                //if input match the regex
                currentUser.validateUsername(username: username){ //check with database
                    result in
                    //if username is existed, show error message
                    if result == true {
                        usernameErrorMessage = "This username is existed"
                    } else { // otherwise, validate email
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
    //MARK: - Fullname input validation
    func validateFullname() {
        do {
            let pattern = #"^[A-Za-z][A-Za-z0-9 '-]{0,30}$"#
            let nameRegex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: fullname.count)
            if (fullname == "") { // check if input is empty
                fullnameErrorMessage = "Name must not be empty"
            } else if nameRegex.firstMatch(in: fullname, range: range) != nil {
                //if input match the regex, validate username
                fullnameErrorMessage = ""
                validateUsername()
            } else { //otherwise, show error message
                fullnameErrorMessage = "Characters (', -) are allowed. Maximun length up to 30"
            }
            
        } catch let error {// return error if any
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
            } else if passRegex.firstMatch(in: password, range: range) != nil { //if input match the regex
                //validate confirm password
                passwordErrorMessage = ""
                validateConfirmPassword()
            } else { //otherwise, show error message
                passwordErrorMessage = "Special characters (!, @, #, $, %, &, *) are allowed. Range length between 8 to 15. Cannot contain space"
            }
        } catch let error { // return error if any
            print(error.localizedDescription)
        }
    }
    //MARK: - Password input validation
    func validateConfirmPassword() { // check if confirm password is the same as password
            if (confirmPassword != password) { //if not, show error message
                confirmPasswordErrorMessage = "Confirm password not matched"
            } else { //otherwise, sign up user if all input passed validation
                confirmPassword = ""
                if emailErrorMessage == "" && fullnameErrorMessage == "" && usernameErrorMessage == "" && passwordErrorMessage == "" && confirmPassword == "" {
                currentUser.signUpUser(userEmail: email, userPassword: password, username: username, fullname: fullname)
                }
            }
    }
    var body: some View {
        
        VStack{
            //MARK: - Sign up title
            Text("Sign up")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .kerning(1.9)
                .frame(maxWidth: .infinity,  alignment: .leading)
            VStack(alignment: .leading, spacing: 8, content: {
                //MARK: - Fullname input area
                HStack {
                    //label
                    Text("Fullname")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    //error message
                    Text(fullnameErrorMessage)
                        .foregroundColor(.red)
                        .fixedSize(horizontal: false, vertical: true)
                }
                //input field
                TextField("Pham Van A", text: $fullname)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
                //MARK: - Username input area
                HStack {
                    //label
                    Text("Username")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    //error message
                    Text(usernameErrorMessage)
                        .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)                }
                //input field
                TextField("henry234", text: $username)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
                //label
                HStack {
                    Text("Email")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    //error message
                    Text(emailErrorMessage)
                        .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)                }
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
                    Text(passwordErrorMessage)
                        .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)                }
                //input field
                SecureField("12345", text: $password)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,20)
            //MARK: - Confirm password input area
            VStack(alignment: .leading, spacing: 8, content: {
                HStack{
                    //label
                    Text("Confirm Password")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    //error message
                    Text(confirmPasswordErrorMessage)
                        .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)                }
                //input field
                SecureField("abcghi1234!", text: $confirmPassword)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.black)
                Divider()
                    .padding(.top, 5)
            })
            .padding(.top,20)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            //MARK: - Buttons area
            HStack (spacing: 5){
                //Submit form button
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
