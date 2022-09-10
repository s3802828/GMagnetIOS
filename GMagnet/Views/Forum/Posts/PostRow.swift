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
                
                HStack(alignment: .top, spacing: 12) {
                    if post.image != "" {
                        AsyncImage(url: URL(string: post.image)) {phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 70, height: 70)
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
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(post.title)
                            .font(.system(size: 25))
                            .bold()
                        
                        Text(post.content)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        
                    }
                }
                
                Spacer()
                //Bottom button action
                HStack {
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
                    
                    Button {
                        
                    } label: {
                        VStack{
                            Image(systemName: "hand.thumbsup")
                                .font(.subheadline)
                            Text("\(String(post.liked_users.count)) Like")
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
