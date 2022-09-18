/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 01/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
 - Google Sign-In & Firebase Authentication Using SwiftUI: https://blog.codemagic.io/google-sign-in-firebase-authentication-using-swift/
 - User Authentication With SwiftUI And Firebase: https://blckbirds.com/post/user-authentication-with-swiftui-and-firebase/
 - Uploading Files from iOS to Amazon S3: https://www.kiloloco.com/articles/011-uploading-files-from-ios-to-amazon-s3/
*/

import SwiftUI
import Firebase
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin
import GoogleSignIn

@main
struct GMagnetApp: App {
    //MARK: - App Constructor
    init() {
        FirebaseApp.configure()
        configureAmplify()
    }
    //MARK: - Configure Amplify
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            
            try Amplify.configure()
            print("Successfully configured Amplify")
            
        } catch {
            print("Could not configure Amplify", error)
        }
    }
    
    var body: some Scene {
        
        WindowGroup {
            SplashScreenView()
                .onOpenURL { url in //Configure google sign in
                GIDSignIn.sharedInstance.handle(url)
              }
        }
    }
}
