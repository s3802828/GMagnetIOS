/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 13/09/2022
  Last modified: 18/09/2022
 Acknowledgement:
 T.Huynh."SSETContactList/ContactList/Views/ContactRow.swift".GitHub.https://github.com/TomHuynhSG/SSETContactList/blob/main/ContactList/Views/ContactRow.swift.
*/

import SwiftUI

struct OwnedPostRow: View {
    @EnvironmentObject var post : PostViewModel
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @EnvironmentObject var profile: ProfileViewModel
    @State var showPostDetail = false
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack(alignment: .top, spacing: 3) {
                //MARK: - Post user information
                //User avatar
                AsyncImage(url: URL(string: post.post.user.avatar)) {phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.gray)
                        
                    } else if phase.error != nil {
                        Image(systemName: "x.circle")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.gray)
                        
                        
                    } else {
                        ProgressView()
                            .frame(width: 280, height: 100)
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.gray)
                        
                        
                        
                    }
                }
                //User name
                Text(post.post.user.name)
                    .padding()
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.black)
                Spacer()
                //Post date difference
                Text(post.post.createdAt.getDateDifference())
                    .padding()
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.black)
                
            }
            //MARK: - Post detail
            Button(action: {
                showPostDetail = true
            }){
                VStack(alignment: .leading, spacing: 4) {
                    //Post title
                    Text(post.post.title)
                        .font(.system(size: 25))
                        .bold()
                        .frame(height: 30)
                        .foregroundColor(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                    //Post content
                    Text(post.post.content)
                        .font(.subheadline)
                        .frame(height: 20)
                        .foregroundColor(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                    
                } }.fullScreenCover(isPresented: $showPostDetail, onDismiss: {
                    profile.refreshPage()
                    
                }){
                    PostDetailProfile().environmentObject(post)
                }
            
            Spacer()
            //MARK: - Bottom button action
            HStack {
                Spacer()
                //Like button
                Button {
                    post.toggle_like_post(user: currentUser.currentUser)
                } label: {
                    VStack{
                        Image(systemName: "hand.thumbsup")
                            .font(.subheadline)
                            
                        Text("\(String(post.post.liked_users.count)) Like")
                    }
                }.foregroundColor(post.post.liked_users.contains(where: {$0.id == currentUser.currentUser.id}) ? Color.blue : .gray)
                
                Spacer()
                //Comment button
                Button {
                    showPostDetail = true
                } label: {
                    VStack{
                        Image(systemName: "bubble.left")
                            .font(.subheadline)
                        Text("\(String(post.post.comment_list.count)) Comment")
                    }
                }.foregroundColor(.gray)
                Spacer()
            }
        }
        .padding(.all)
        .background{
            //Post background
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .shadow(radius: 5)
                .frame(width: UIScreen.main.bounds.width)
        }
    }
}
