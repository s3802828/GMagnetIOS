/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 09/09/2022
  Last modified: 18/09/2022
*/

import SwiftUI

struct JoinedForumCardView: View {
    @EnvironmentObject var gameForum: GameForumViewModel
    @EnvironmentObject var profile: ProfileViewModel
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @State var showForumDetail = false
    
    var body: some View {
        ZStack{
            VStack {
                //MARK: - Game forum banner
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
                //MARK: - Game forum name
                HStack {
                    Text(gameForum.gameforum.name)
                        .font(.system(size: 17, weight: .heavy , design: .monospaced))
                    Spacer()
                }.padding(.leading, 15)
                    .padding(.bottom, 10)
            }.frame(width: 300, height: 160)
        //MARK: - Join button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        profile.toggle_join_forum(forum: gameForum.gameforum, user: currentUser)
                        
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

            //MARK: Forum logo
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
        }.fullScreenCover(isPresented: $showForumDetail, onDismiss: {
            //refresh page to get latest update if any
            profile.refreshPage()
        }){
            GameForumTabProfile()
        }
        
    }
}

