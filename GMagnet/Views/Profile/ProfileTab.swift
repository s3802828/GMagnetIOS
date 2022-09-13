//
//  ProfileTab.swift
//  GMagnet
//
//  Created by Giang Le on 13/09/2022.
//

import SwiftUI

struct ProfileTab: View {
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @EnvironmentObject var profile : ProfileViewModel
    @State var showProfile = false
    @State var showEditProfile = false
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: profile.user.avatar)) {phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(.white),lineWidth: 2))

                } else if phase.error != nil {
                    Image(systemName: "x.circle")
                        .resizable()
                        .frame(width: 280, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.gray))
                        .padding(.horizontal, 10)
                        .padding(.top, 10)

                } else {
                    ProgressView()
                        .frame(width: 280, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle())
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                }
            }
            Button{
                showProfile = true
            }label: {
                Text("Profile")
                    .font(.subheadline).bold()
                    .frame(width: 120, height: 32)
                    .foregroundColor(.black)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.gray, lineWidth: 0.75))
            }.fullScreenCover(isPresented: $showProfile){
                ProfileView()
            }
            Button{
                showEditProfile = true
            }label: {
                Text("Edit Profile")
                    .font(.subheadline).bold()
                    .frame(width: 120, height: 32)
                    .foregroundColor(.black)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.gray, lineWidth: 0.75))
            }.fullScreenCover(isPresented: $showEditProfile, onDismiss: {currentUser.refreshCurrentUser()}){
                EditProfileView()
            }
            Button{
                currentUser.signOutUser()
            }label: {
                Text("Log Out")
                    .font(.subheadline).bold()
                    .frame(width: 120, height: 32)
                    .foregroundColor(.black)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(.gray, lineWidth: 0.75))
            }
        }
    }
}

struct ProfileTab_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTab()
    }
}
