/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 11/09/2022
  Last modified: 18/09/2022
 Acknowledgement:
 T.Huynh."SSETContactList/ContactList/Views/ContactRow.swift".GitHub.https://github.com/TomHuynhSG/SSETContactList/blob/main/ContactList/Views/ContactRow.swift.
*/

import SwiftUI

struct CommentRow: View {
    var comment: Comment

    @EnvironmentObject var currentUser: AuthenticateViewModel
    @EnvironmentObject var postViewModel: PostViewModel
    
    @State var isCommentEditing = false
    @State var commentEditInput = ""
    @State var showProfileDetail = false
    //MARK: - Update comment function
    func update_comment(){
        //copy old comment values
        var new_comment = self.comment
        
        //update content
        new_comment.content = self.commentEditInput
        
        //save changes
        postViewModel.update_comment(updated_comment: new_comment)
        isCommentEditing.toggle()
    }
    //MARK: - Delete comment function
    func delete_comment(){
        postViewModel.delete_comment(deleted_comment: comment)
    }
    
    var body: some View {
        HStack {
            VStack {
                //MARK: - User's avatar
                Button(action: { //Lead to user's profile view
                    showProfileDetail = true
                }, label: {
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
                }).foregroundColor(.black)
                .fullScreenCover(isPresented: $showProfileDetail, content: {ProfileView().environmentObject(ProfileViewModel(user_id: comment.user.id))})
                
                Spacer()
            }
            //MARK: - User's name
            VStack(alignment: .leading) {
                HStack {
                    Button(action: { //Lead to user's profile view
                        showProfileDetail = true
                    }, label: {
                        Text(comment.user.name)
                            .fontWeight(.bold)
                    })
                    .foregroundColor(.black)
                    .fullScreenCover(isPresented: $showProfileDetail, content: {ProfileView().environmentObject(ProfileViewModel(user_id: comment.user.id))})
                    
                    Spacer()
                    //Date difference
                    Text(comment.createdAt.getDateDifference())
                        .fontWeight(.bold)
                }
                
                HStack {
                    //MARK: - Editing mode
                    if (isCommentEditing) {
                        HStack {
                            
                            TextField("", text: $commentEditInput)
                            
                            Spacer()
                            Button(action: {
                                self.update_comment()
                            }, label: {
                                Image(systemName: "paperplane")
                                    .foregroundColor(Color("ButtonColor"))
                                
                            })
                        }.padding(.all, 5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke().opacity(0.5))
                    } else { //MARK: - Normal mode
                        //comment content
                    Text(comment.content)
                        .padding(.all, 5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke().opacity(0.5))
                    }
                    Spacer()
                    //MARK: - Edit & delete button menu
                    if (currentUser.currentUser.id == comment.user.id) {
                        //only show if current user own this comment
                        if (isCommentEditing) {
                            //editing mode
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
                                //Edit button
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
                                //Delete button
                                Button(action: {
                                    self.delete_comment()
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
