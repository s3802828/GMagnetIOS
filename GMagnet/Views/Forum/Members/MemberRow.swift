//
//  MemberRow.swift
//  GMagnet
//
//  Created by Dat Pham Thanh on 06/09/2022.
//

import SwiftUI

struct MemberRow: View {
    var member: User
    let gameColor = GameColor()
    @State var showProfileDetail = false
    var body: some View {
        Button(action: {
            showProfileDetail = true
        }){
            HStack {
                AsyncImage(url: URL(string: member.avatar)) {phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.white),lineWidth: 2))
                            .shadow(color:gameColor.cyan.opacity(1), radius: 3, x: 1, y: 1)

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
                Text(member.name)
                    .padding()
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color.black)
            }
        }.fullScreenCover(isPresented: $showProfileDetail){
            ProfileView().environmentObject(ProfileViewModel(user_id: member.id)).foregroundColor(.black)
        }
    }
}
