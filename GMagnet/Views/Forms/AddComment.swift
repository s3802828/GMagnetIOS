//
//  AddComment.swift
//  GMagnet
//
//  Created by Giang Le on 11/09/2022.
//

import SwiftUI
import Firebase

struct AddComment: View {
    @State var commentInput = ""
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @EnvironmentObject var postDetail : PostViewModel
    
    func add_comment(){
        if self.commentInput.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
            let new_comment = Comment(
                id: "ayo",
                user: currentUser.currentUser,
                post: postDetail.post.id,
                content: commentInput,
                createdAt: Timestamp.init()
            )
            postDetail.add_comment(added_comment: new_comment)
            commentInput = ""
        }
    }
    var body: some View {
        ZStack {
            
            HStack{
                AsyncImage(url: URL(string: currentUser.currentUser.avatar)) {phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.gray))
                            .padding(.leading, 10)

                    } else if phase.error != nil {
                        Image(systemName: "x.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.gray))
                            .padding(.leading, 10)

                    } else {
                        ProgressView()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.gray))
                            .padding(.leading, 10)
                    }
                }
                HStack {
                    
                    TextField("Add a comment...", text: $commentInput)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                    
                    Button(action: {
                        self.add_comment()
                    }, label: {
                        Image(systemName: "paperplane")
                        
                    })
                    
                }
                .padding(.horizontal, 10)
                .frame(height: 40)
                .overlay(Capsule().stroke().opacity(0.3))
                .padding(.horizontal, 10)
            }
        }
    }
}
