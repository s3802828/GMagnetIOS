//
//  GMagnetApp.swift
//  GMagnet
//
//  Created by Giang Le on 01/09/2022.
//

import SwiftUI
import Firebase

@main
struct GMagnetApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
    }
}
