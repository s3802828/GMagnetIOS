//
//  ForumCardView.swift
//  GMagnet
//
//  Created by Huu Tri on 01/09/2022.
//

import SwiftUI

struct ForumCardView: View {
    @EnvironmentObject var gameForum: GameForumViewModel
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @State var showForumDetail = false
    var body: some View {
        ZStack{
            VStack {
                
                AsyncImage(url: URL(string: gameForum.gameforum.banner)) {phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 280, height: 100)
                            .background(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                            .overlay(RoundedRectangle(cornerRadius: 9).stroke(.gray))
                            .padding(.horizontal, 10)
                            .padding(.top, 10)

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
                
                HStack {
                    Text(gameForum.gameforum.name)
                        .font(.system(size: 17, weight: .heavy , design: .monospaced))
                        
                        
                    Spacer()
                }.padding(.leading, 15)
                    .padding(.bottom, 10)
                
                
                
            }.frame(width: 300, height: 160)
            
            
            
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        gameForum.toggle_join_forum(forum: gameForum.gameforum, authViewModel: currentUser)
                    }, label: {
                        Text(gameForum.members.contains(where: {$0.id == currentUser.currentUser.id}) ? "Joined" : "Join")
                            .font(.system(size: 18, weight: .heavy , design: .monospaced))
                            .frame(width: 75, height: 30)
                            .background(gameForum.members.contains(where: {$0.id == currentUser.currentUser.id}) ? .gray : .blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                            .overlay(RoundedRectangle(cornerRadius: 9).stroke(.white, lineWidth: 3))
                            .padding(.horizontal, 10)
                            .padding(.bottom, 15)
                    })
                }.padding(.horizontal, 5)
                    .padding(.top, 15)
                
                
                Spacer()
                
                
            }.frame(width: 300, height: 160)
               

                
                
            
                
            AsyncImage(url: URL(string: gameForum.gameforum.logo)) {phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.gray))
                        .offset(x: -100, y: 10)
                } else if phase.error != nil {
                    Image(systemName: "x.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.gray))
                        .offset(x: -100, y: 10)
                } else {
                    ProgressView()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.gray))
                        .offset(x: -100, y: 10)
                    
                }
            }
            
        }.background{
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .shadow(radius: 5)
        }
        .onTapGesture {
            showForumDetail = true
        }.fullScreenCover(isPresented: $showForumDetail, onDismiss: {gameForum.refreshGameForum(){}}){
            GameForumTabView()
        }
        
    }
}

