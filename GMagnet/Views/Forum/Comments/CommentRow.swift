//
//  CommentRow.swift
//  GMagnet
//
//  Created by Giang Le on 11/09/2022.
//

import SwiftUI

struct CommentRow: View {
    var comment: Comment

    @EnvironmentObject var currentUser: AuthenticateViewModel
    
    @State var isCommentEditing = false
    
    @State var commentEditInput = ""
    
    var body: some View {
        HStack {
            VStack {
                AsyncImage(url: URL(string: comment.user.avatar)) {phase in
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
                Spacer()
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.user.name)
                        .fontWeight(.bold)
                    Spacer()
                    Text(comment.createdAt.getDateDifference())
                        .fontWeight(.bold)
                }
                
                HStack {
                    if (isCommentEditing) {
                        HStack {
                            
                            TextField("", text: $commentEditInput)
                            
                            Spacer()
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "paperplane")
                                    .foregroundColor(Color("ButtonColor"))
                                
                            })
                        }.padding(.all, 5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke().opacity(0.5))
                    } else {
                    Text(comment.content)
                        .padding(.all, 5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke().opacity(0.5))
                    }
                    Spacer()
                    if (currentUser.currentUser.id == comment.user.id) {
                        if (isCommentEditing) {
                            Button(action: {
                                isCommentEditing.toggle()
                            }, label: {
                                Image(systemName: "x.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                    .foregroundColor(.black)
                            })
                        } else {
                            Menu(content: {

                                Button(action: {
                                    isCommentEditing.toggle()
                                    print("Edit clicked")
                                }, label: {
                                    HStack {
                                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                            .foregroundColor(Color("ButtonColor"))
                                        Text("Edit")
                                    }
                                })
                                
                                Button(action: {

                                }, label: {
                                    HStack {
                                        Image(systemName: "trash")
                                            .foregroundColor(Color("ButtonColor"))
                                        Text("Delete")
                                    }
                                })
                            }, label: {
                                Image(systemName: "ellipsis.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                    .foregroundColor(Color("ButtonColor"))
                                    
                            })
                        }
                    }
                    
                }
                
            }
        }
        .padding(.all, 3)
        .frame(width: 370, alignment: .leading)
        .onAppear{
            commentEditInput = comment.content
        }
    }
}
