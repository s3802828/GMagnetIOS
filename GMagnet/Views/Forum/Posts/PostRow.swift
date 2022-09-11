//
//  PostRow.swift
//  PostList_IOS
//
//  Created by Dat Pham Thanh on 07/09/2022.
//

import SwiftUI

struct PostRow: View {
    var post: Post
    @State var showPostDetail = false
    var body: some View {
        Button(action: {
            showPostDetail = true
        }){
            VStack(alignment: .leading) {
                
                HStack(alignment: .top, spacing: 5) {
                   
                    AsyncImage(url: URL(string: post.user.avatar)) {phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.gray)
                            
                        } else if phase.error != nil {
                            Image(systemName: "x.circle")
                                .resizable()
                                .frame(width: 280, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 9))
                                .overlay(RoundedRectangle(cornerRadius: 9).stroke(.gray))
                                .padding(.horizontal, 10)
                                .padding(.top, 10)
                            
                        } else {
                            ProgressView()
                                .frame(width: 280, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 9))
                                .overlay(RoundedRectangle(cornerRadius: 9).stroke(.gray))
                                .padding(.horizontal, 10)
                                .padding(.top, 10)
                            
                            
                        }
                    }
                    Text(post.user.name)
                        .padding()
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.black)
                    Spacer()
                    Text(post.createdAt.getDateDifference())
                        .padding()
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.black)
                    
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.title)
                        .font(.system(size: 25))
                        .bold()
                        .frame(height: 30)
                        .foregroundColor(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(post.content)
                        .font(.subheadline)
                        .frame(height: 20)
                        .foregroundColor(Color.black)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                
                Spacer()
                //Bottom button action
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        VStack{
                            Image(systemName: "hand.thumbsup")
                                .font(.subheadline)
                            Text("\(String(post.liked_users.count)) Like")
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        //Action here
                    } label: {
                        VStack{
                            Image(systemName: "bubble.left")
                                .font(.subheadline)
                            Text("\(String(post.comment_list.count)) Comment")
                        }
                    }
                    Spacer()
                }
                .foregroundColor(.gray)
            }
            .padding(.all)
            .background{
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
                    .shadow(radius: 5)
                    .frame(width: UIScreen.main.bounds.width)
            }
        }.fullScreenCover(isPresented: $showPostDetail){
            PostDetailsView().environmentObject(PostViewModel(post: post))
        }
    }
}
