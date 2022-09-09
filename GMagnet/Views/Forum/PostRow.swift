//
//  PostRow.swift
//  PostList_IOS
//
//  Created by Dat Pham Thanh on 07/09/2022.
//

import SwiftUI

struct PostRow: View {
    var post: Post
    var body: some View {
        
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
                        HStack {
                           Text(post.title)
                                .font(.system(size: 25))
                                .bold()
                        }
                        
                        Text(post.content)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        
                        HStack{
                            Text("Likes: ")
                            Text(String(post.liked_users.count))
                            Text("Comments: ")
                            Text(String(post.comment_list.count))
                        }
                        
                    }
                }
            
            
            //Bottom button action
            HStack {
                Button {
                    //Action here
                } label: {
                     Image(systemName: "bubble.left")
                        .font(.subheadline)
                }
                
                Spacer()
                
                Button {
                        //Action here
                } label: {
                    Image(systemName: "arrow.2.squarepath")
                        .font(.subheadline)
                }
                
                Spacer()
                
                Button {
                   
                } label: {
                    Image(systemName: "heart")
                        .font(.subheadline)
                        
                }
                
                Spacer()
                
                Button {
                        //Action here
                } label: {
                    Image(systemName: "bookmark")
                        .font(.subheadline)
                }
            }
            .padding()
            .foregroundColor(.gray)
            
            Divider()
        }
    }
}

//struct PostRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PostRow(post: posts[0])
//            .previewLayout(.fixed(width: 300, height: 90))
//    }
//}
