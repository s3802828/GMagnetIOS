//
//  PostDetailsView.swift
//  TestS3Upload
//
//  Created by Huu Tri on 09/09/2022.
//

import SwiftUI

extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)k"
        }
        else {
            return "\(self)"
        }
    }
}

struct PostDetailsView: View {
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @EnvironmentObject var gameViewModel: GameForumViewModel
    @EnvironmentObject var postDetail : PostViewModel
    @Environment(\.dismiss) var dismiss
    @State var expanded: Bool = false
    @State private var showViewButton: Bool = false
    @State var lineLimit = 5

    
    private var moreLessText: String {
        if showViewButton {
            return expanded ? "View Less" : "View More"
            
        } else {
            return ""
            
        }
    }
    
    func delete_post(){
        self.gameViewModel.delete_post(deleted_post: self.postDetail.post)
        dismiss()
    }
    
    var body: some View {
        ZStack {
            ScrollViewReader {value in
                ScrollView {
                    PullToRefresh(coordinateSpaceName: "pullToRefreshPostDetail") {
                        postDetail.refreshPostViewModel(){
                            if postDetail.post.id == "" {
                                dismiss()
                            }
                        }
                    }
                    VStack (alignment: .leading){
                        Button(action: {
                            dismiss()
                        }){
                            HStack (spacing: 2) {
                                Image(systemName: "arrow.backward")
                                Text("Back")
                            }.padding(.horizontal, 5)
                        }
                        HStack {
                            AsyncImage(url: URL(string: postDetail.post.user.avatar)) {phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(.gray))
                                        .padding(.horizontal,5)
                                        .id(-1)

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
                            VStack(alignment: .leading) {
                                Text(postDetail.post.title)
                                    .font(.system(size: 20))
                                    .bold()
                                Text("By: \(postDetail.post.user.name)")
                                    .font(.system(size: 15))
                                    .bold()
                            }
                            
                            Spacer()
                            
                        }.padding(5)
                        
                        Divider()
                        
                        ZStack {
                            
                            VStack {
                                Text(postDetail.post.content)
                                    .font(.body)
                                    .lineLimit(expanded ? nil : lineLimit)
                                    .padding(.horizontal)
                                
                                ScrollView(.vertical) {
                                    Text(postDetail.post.content)
                                        .font(.body)
                                        .background(
                                            GeometryReader { proxy in
                                                Color.clear
                                                    .onAppear {
                                                        showViewButton = proxy.size.height > CGFloat(22 * lineLimit)
                                                    }
                                                    .onChange(of: postDetail.post.content) { _ in
                                                        showViewButton = proxy.size.height > CGFloat(22 * lineLimit)
                                                    }
                                            }
                                        )
                                    
                                }
                                .opacity(0.0)
                                .disabled(true)
                                .frame(height: 0.0)
                                
                                Button(action: {
                                    
                                    if expanded {
                                        withAnimation{
                                            value.scrollTo(-1)
                                        }
                                        
                                    }
                                    
                                    withAnimation {
                                        expanded.toggle()
                                        
                                    }
                                }, label: {
                                    Text(moreLessText)
                                        .font(.body)
                                        .foregroundColor(.blue)
                                })
                                .opacity(showViewButton ? 1.0 : 0.0)
                                .disabled(!showViewButton)
                                
                                if postDetail.post.image != "" {
                                    AsyncImage(url: URL(string: postDetail.post.image)) {phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 350)
                                                .background(.gray)
                                                .padding(.bottom, 10)

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
                                
                                Divider()
                                
                                HStack {
                                    
                                    Button(action: {
                                        
                                        postDetail.toggle_like_post(user: currentUser.currentUser)
                                        
                                    }, label: {
                                        Image(systemName: "hand.thumbsup")
                                            .foregroundColor(postDetail.post.liked_users.contains(where: {$0.id == currentUser.currentUser.id}) ? .white : .blue)
                                        
                                    }).padding(.all,8)
                                        .background{
                                            Circle().fill( postDetail.post.liked_users.contains(where: {$0.id == currentUser.currentUser.id}) ? .blue : .white)
                                        }.shadow(radius: 3)
                                    Text("\(postDetail.post.liked_users.count.roundedWithAbbreviations)")
                                        
                                    
                                    
                                    Button(action: {

                                    }, label: {
                                        Image(systemName: "bubble.left")
                                    }).padding(.all,8)
                                        .background{
                                            Circle().fill(.white)
                                        }.shadow(radius: 3)
                                    
                                    Text("\(postDetail.post.comment_list.count.roundedWithAbbreviations)")
                                    
                                    Spacer()
                                    
                                    if (currentUser.currentUser.id == postDetail.post.user.id){
                                        
                                        EditButtonSelection(deleteFunction: {
                                            self.delete_post()
                                        }, content: {
                                            UpdatePostView(updated_post: postDetail.post)
                                        })

                                    }
                                    
                                }.padding(.vertical, 5)
                                    .padding(.horizontal, 20)
                                
                                Divider()
                                
                                ZStack {
                                    CommentList(commentList: postDetail.post.comment_list)
                                }
                            }
                        }
                    }
                }.coordinateSpace(name: "pullToRefreshPostDetail")
                Spacer()
                AddComment()
                    .environmentObject(postDetail)
                    .environmentObject(currentUser)
            }
        }.onAppear(){
            if self.postDetail.post.id == ""{
                dismiss()
            }
        }
    }
}

struct PostDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailsView()
    }
}
