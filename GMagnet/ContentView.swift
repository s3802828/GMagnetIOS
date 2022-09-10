//
//  ContentView.swift
//  GMagnet
//
//  Created by Giang Le on 01/09/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var currentUser = AuthenticateViewModel()
    var body: some View {
        if !currentUser.isLoggingIn {
            if (currentUser.currentUser.id != ""){
                TabViews().environmentObject(currentUser)
            } else {
                Home().environmentObject(currentUser)
            }
        } else {
            ProgressView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
