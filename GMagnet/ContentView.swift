/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 01/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
- How to show a relative date and time using RelativeDateTimeFormatter: https://www.hackingwithswift.com/example-code/system/how-to-show-a-relative-date-and-time-using-relativedatetimeformatter
 - Finding distance between CLLocationCoordinate2D points: https://stackoverflow.com/questions/11077425/finding-distance-between-cllocationcoordinate2d-points
*/


import SwiftUI
import Firebase
import CoreLocation

struct ContentView: View {
    @StateObject var currentUser = AuthenticateViewModel()
    
    var body: some View {
        //if current user is done signing in, show tab view / sign up + login view
        if !currentUser.isLoggingIn {
            if (Auth.auth().currentUser != nil){
                //if user is signed in, show tab view
                TabViews().environmentObject(currentUser)
                    .onAppear(){
                        currentUser.refreshCurrentUser()
                        currentUser.requestAllowOnceLocationPermission()
                    }
            } else { //otherwise, show sign up + login view
                Home().environmentObject(currentUser)
            }
        } else {// otherwise, show progress view
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
