//
//  ContentView.swift
//  GMagnet
//
//  Created by Giang Le on 01/09/2022.
//

import SwiftUI
import Firebase

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

extension Timestamp {
    func getDateDifference() -> String {
        // ask for the full relative date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        // get exampleDate relative to the current date
        let relativeDate = formatter.localizedString(for: self.dateValue(), relativeTo: Timestamp.init().dateValue())
        return relativeDate
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
