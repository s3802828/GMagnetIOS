//
//  MemberRow.swift
//  GMagnet
//
//  Created by Dat Pham Thanh on 06/09/2022.
//

import SwiftUI
import CoreLocation

struct MemberRow: View {
    @EnvironmentObject var currentUser: AuthenticateViewModel
    var member: User
    let gameColor = GameColor()
    @State var showProfileDetail = false
    var isNearBy : Bool {
        if currentUser.currentUser.longitude != "" && currentUser.currentUser.latitude != "" && member.longitude != "" && member.latitude != "" {
            let curLong = Double(currentUser.currentUser.longitude) ?? 0
            let curLat = Double(currentUser.currentUser.latitude) ?? 0
            let long = Double(member.longitude) ?? 0
            let lat = Double(member.latitude) ?? 0
            print(curLong)
            print(curLat)
            print(long)
            print(lat)
            let distance = CLLocation.distance(from: CLLocationCoordinate2D(latitude: lat, longitude: long), to: CLLocationCoordinate2D(latitude: curLat, longitude: curLong))
            print("Dis from Z \(distance)")
            if distance <= 5000{
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    var body: some View {
        Button(action: {
            showProfileDetail = true
        }){
            HStack {
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
                Text(member.name)
                    .padding()
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.black)
                if isNearBy {
                    HStack (spacing: 2){
                        Image(systemName: "location.viewfinder")
                        Text("Nearby")
                            .font(.system(size: 15, weight: .semibold))
                    }.foregroundColor(Color.green)
                }
            }
        }.fullScreenCover(isPresented: $showProfileDetail){
            ProfileView().environmentObject(ProfileViewModel(user_id: member.id)).foregroundColor(.black)
        }
    }
}


