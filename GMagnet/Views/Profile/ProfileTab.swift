/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 13/09/2022
  Last modified: 18/09/2022
*/
import SwiftUI

struct ProfileTab: View {
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @EnvironmentObject var profile : ProfileViewModel
    @State var showProfile = false
    @State var showEditProfile = false
    var body: some View {
        VStack {
            //MARK: - Current user's avatar
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
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(.white),lineWidth: 2))

                } else {
                    ProgressView()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(.white),lineWidth: 2))
                }
            }
            //MARK: - Profile button
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
            //MARK: - Edit profile button
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
            //MARK: - Sign out button
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
