//
//  ForumCardView.swift
//  GMagnet
//
//  Created by Huu Tri on 01/09/2022.
//

import SwiftUI

struct ForumCardView: View {
    @EnvironmentObject var gameForum: GameForumViewModel
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
                    }).fullScreenCover(isPresented: $showForumDetail){
                        GameForumTabView()
                    }
                    
                    Button(action: {
                        
                    }, label: {
                        Text("Join")
                            .font(.system(size: 18, weight: .heavy , design: .monospaced))
                            .frame(width: 75, height: 30)
                            .background(.blue)
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
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.gray))
                        .offset(x: -90, y: 30)
                } else if phase.error != nil {
                    Image(systemName: "x.circle")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.gray))
                        .offset(x: -90, y: 30)
                } else {
                    ProgressView()
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

