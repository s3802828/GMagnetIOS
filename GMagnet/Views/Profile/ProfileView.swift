//
//  ProfileView.swift
//  PostList_IOS
//
//  Created by Dat Pham Thanh on 08/09/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profile : ProfileViewModel
    @State private var selectedFiler: TweetFilterViewModel = .posts
    @Environment(\.dismiss) var dismiss
    @Namespace var animation

    var body: some View {
        VStack(alignment: .leading){
            headerView
            
            userInfoDetails
            
            tweetsFilterBar
            ScrollView {
                PullToRefresh(coordinateSpaceName: "pullToRefreshProfileView") {
                    profile.refreshPage()
                }
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
    var headerView: some View {
        ZStack(alignment: .bottomLeading){
            Color.blue
                .ignoresSafeArea()
            VStack {
                Button{
                    dismiss()
                } label:{
                    Image(systemName:"arrow.left")
                        .resizable()
                        .frame(width: 20, height: 16)
                        .foregroundColor(.white)
                        .offset(x: 16, y:12)
                }
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
            }
            
        }
        .frame(height: 96)
    }
    var userInfoDetails: some View{
        VStack(alignment: .leading, spacing: 4){
            HStack (spacing: 5) {
                Text(profile.user.name)
                    .font(.title2).bold()
                Text("@\(profile.user.username)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Text("Bio")
                .font(.headline).bold()
            Text(profile.user.description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
    var tweetsFilterBar: some View{
        HStack {
            ForEach(TweetFilterViewModel.allCases, id: \.rawValue) { item in
                VStack {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(selectedFiler == item ? .semibold : .regular)
                        .foregroundColor(selectedFiler == item ? .black : .gray)
                    
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
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedFiler = item
                    }
                }
            }
        }
        .overlay(Divider().offset(x: 0, y: 16))
    }
}
