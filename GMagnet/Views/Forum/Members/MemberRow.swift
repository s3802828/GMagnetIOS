/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 06/09/2022
  Last modified: 18/09/2022
 Acknowledgement:
 T.Huynh."SSETContactList/ContactList/Views/ContactRow.swift".GitHub.https://github.com/TomHuynhSG/SSETContactList/blob/main/ContactList/Views/ContactRow.swift.
*/


import SwiftUI
import CoreLocation

struct MemberRow: View {
    @EnvironmentObject var currentUser: AuthenticateViewModel
    var member: User
    let gameColor = GameColor()
    @State var showProfileDetail = false
    //MARK: - Check if user is nearby current user
    var isNearBy : Bool {
        //Only check if both user and current user's locations are detected
        if currentUser.currentUser.longitude != "" && currentUser.currentUser.latitude != "" && member.longitude != "" && member.latitude != "" {
            //Get both user's lat, long
            let curLong = Double(currentUser.currentUser.longitude) ?? 0
            let curLat = Double(currentUser.currentUser.latitude) ?? 0
            let long = Double(member.longitude) ?? 0
            let lat = Double(member.latitude) ?? 0
            print(curLong)
            print(curLat)
            print(long)
            print(lat)
            //Calculate distance
            let distance = CLLocation.distance(from: CLLocationCoordinate2D(latitude: lat, longitude: long), to: CLLocationCoordinate2D(latitude: curLat, longitude: curLong))
            print("Dis from Z \(distance)")
            //If user within 5km from current user
            if distance <= 5000{
                return true
            } else { // else, return false
                return false
            }
        } else { // else, return false
            return false
        }
    }
    var body: some View {
        //Set member row as button to the user's profile page
        Button(action: {
            showProfileDetail = true
        }){
            HStack {
                //MARK: - User's avatar
                AsyncImage(url: URL(string: member.avatar)) {phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.white),lineWidth: 2))
                            .shadow(color:gameColor.cyan.opacity(1), radius: 3, x: 1, y: 1)

                    } else if phase.error != nil {
                        Image(systemName: "x.circle")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.white),lineWidth: 2))
                            .shadow(color:gameColor.cyan.opacity(1), radius: 3, x: 1, y: 1)

                    } else {
                        ProgressView()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.white),lineWidth: 2))
                            .shadow(color:gameColor.cyan.opacity(1), radius: 3, x: 1, y: 1)

                        
                    }
                }
                //MARK: - User's name
                Text(member.name)
                    .padding()
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.black)
                //MARK: - Nearby text sign
                if isNearBy {
                    HStack (spacing: 2){
                        Image(systemName: "location.viewfinder")
                        Text("Nearby")
                            .font(.system(size: 15, weight: .semibold))
                    }.foregroundColor(Color.green)
                }
            }
        }.fullScreenCover(isPresented: $showProfileDetail){
            //show profile view
            ProfileView().environmentObject(ProfileViewModel(user_id: member.id)).foregroundColor(.black)
        }
    }
}


