//
//  GMagnetApp.swift
//  GMagnet
//
//  Created by Giang Le on 01/09/2022.
//

import SwiftUI
import Firebase
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin
import GoogleSignIn

@main
struct GMagnetApp: App {
    init() {
        FirebaseApp.configure()
        configureAmplify()
    }
    
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
            ContentView()
                .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
              }
        }
    }
}
