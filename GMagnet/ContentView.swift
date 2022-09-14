//
//  ContentView.swift
//  GMagnet
//
//  Created by Giang Le on 01/09/2022.
//

import SwiftUI
import Firebase
import CoreLocation

struct ContentView: View {
    @StateObject var currentUser = AuthenticateViewModel()
    
    var body: some View {
        if !currentUser.isLoggingIn {
            if (Auth.auth().currentUser != nil){
                
                TabViews().environmentObject(currentUser)
                    .onAppear(){
                        print("not allowingggggg")
                        currentUser.refreshCurrentUser()
                        currentUser.requestAllowOnceLocationPermission()
                    }
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

extension CLLocation {
    
    /// Get distance between two points
    ///
    /// - Parameters:
    ///   - from: first point
    ///   - to: second point
    /// - Returns: the distance in meters
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
