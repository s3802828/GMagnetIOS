//
//  ForumCardView.swift
//  GMagnet
//
//  Created by Huu Tri on 01/09/2022.
//

import SwiftUI

struct JoinedForumCardView: View {
    @EnvironmentObject var gameForum: GameForumViewModel
    @EnvironmentObject var profile: ProfileViewModel
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
                    Spacer()
                    
                    Button(action: {
                        showForumDetail = true
                    }, label: {
                        Text("Visit")
                            .font(.system(size: 18, weight: .heavy , design: .monospaced))
                            .frame(width: 75, height: 30)
                            .background(.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                            .padding(.bottom, 15)
                    }).fullScreenCover(isPresented: $showForumDetail, onDismiss: {profile.refreshPage()}){
                        GameForumTabProfile()
                    }
                    
                    Button(action: {
                        gameForum.toggle_join_forum(forum: gameForum.gameforum, authViewModel: currentUser)
                    }, label: {
                        Text(gameForum.members.contains(where: {$0.id == currentUser.currentUser.id}) ? "Joined" : "Join")
                            .font(.system(size: 18, weight: .heavy , design: .monospaced))
                            .frame(width: 75, height: 30)
                            .background(gameForum.members.contains(where: {$0.id == currentUser.currentUser.id}) ? .gray : .blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                            .padding(.horizontal, 10)
                            .padding(.bottom, 15)
                    })
                    
                }

            }.frame(width: 300, height: 160)
                
            AsyncImage(url: URL(string: gameForum.gameforum.logo)) {phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.gray))
                        .offset(x: -90, y: 30)
                } else if phase.error != nil {
                    Image(systemName: "x.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.gray))
                        .offset(x: -90, y: 30)
                } else {
                    ProgressView()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.gray))
                        .offset(x: -90, y: 30)
                    
                }
            }
            
        }.background{
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .shadow(radius: 5)
        }
        
    }
}

