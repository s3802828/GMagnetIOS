/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 09/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
 SwiftUI 2.0 Twitter Profile Page Parallax Animation + Sticky Headers - SwiftUI Tutorials - https://www.youtube.com/watch?v=U5UbLFmLUpU
*/

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profile : ProfileViewModel
    @State private var selectedFiler: TweetFilterViewModel = .posts
    @Environment(\.dismiss) var dismiss
    @Namespace var animation
    //MARK: - Main display view
    var body: some View {
        VStack(alignment: .leading){
            headerView // header
            
            userInfoDetails // personal information
            
            tweetsFilterBar // tabbar
            ScrollView {
                //pull to refresh
                PullToRefresh(coordinateSpaceName: "pullToRefreshProfileView") {
                    profile.refreshPage()
                }
                //show view based on tab content
                if selectedFiler == .posts {
                    OwnedPostList()
                } else if selectedFiler == .joinedForum {
                    JoinedForumList()
                }
            }.coordinateSpace(name: "pullToRefreshProfileView")
            
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
extension ProfileView{
    //MARK: - Header view define
    var headerView: some View {
        ZStack(alignment: .bottomLeading){
            Color.blue
                .ignoresSafeArea()
            VStack {
                //MARK: - Back button
                Button{
                    dismiss()
                } label:{
                    Image(systemName:"arrow.left")
                        .resizable()
                        .frame(width: 20, height: 16)
                        .foregroundColor(.white)
                        .offset(x: 16, y:12)
                }
                //MARK: - User's avatar
                AsyncImage(url: URL(string: profile.user.avatar)) {phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.white),lineWidth: 2))
                            .frame(width: 72, height: 72)
                            .offset(x: 16, y: 24)

                    } else if phase.error != nil {
                        Image(systemName: "x.circle")
                            .resizable()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.white),lineWidth: 2))
                            .frame(width: 72, height: 72)
                            .offset(x: 16, y: 24)

                    } else {
                        ProgressView()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.white),lineWidth: 2))
                            .frame(width: 72, height: 72)
                            .offset(x: 16, y: 24)
                    }
                }
            }
            
        }
        .frame(height: 96)
    }
    //MARK: - User personal information define
    var userInfoDetails: some View{
        VStack(alignment: .leading, spacing: 4){
            HStack (spacing: 5) {
                //User's name
                Text(profile.user.name)
                    .font(.title2).bold()
                //User's username
                Text("@\(profile.user.username)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            //User's bio
            Text(profile.user.description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
    //MARK: - Profile tab bar section
    var tweetsFilterBar: some View{
        HStack {
            //Handle tab bar tab content and transition
            ForEach(TweetFilterViewModel.allCases, id: \.rawValue) { item in
                VStack {
                    //Tab name
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(selectedFiler == item ? .semibold : .regular)
                        .foregroundColor(selectedFiler == item ? .black : .gray)
                    //Tab layout
                    if selectedFiler == item {
                        Capsule()
                            .foregroundColor(Color.blue)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)
                    } else {
                        Capsule()
                            .foregroundColor(Color(.clear))
                            .frame(height: 3)
                    }
                }
                .onTapGesture { //Tap transition
                    withAnimation(.easeInOut) {
                        self.selectedFiler = item
                    }
                }
            }
        }
        .overlay(Divider().offset(x: 0, y: 16))
    }
}
