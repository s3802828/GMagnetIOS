//
//  GameDetailView.swift
//  GMagnet
//
//  Created by Dat Pham Thanh on 06/09/2022.
//

import SwiftUI

struct GameDetailView: View {
    @State var offset: CGFloat = 0
    @EnvironmentObject var gameForum : GameForumViewModel
    let gameColor = GameColor()
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content:{
            Text(gameForum.gameforum.name)
                .fontWeight(.bold)
                .foregroundColor(gameColor.black)
                .font(.system(size: 30))
            HStack {
                ForEach(gameForum.gameforum.category_list, id: \.id){category in
                    Text("#\(category.category_name) ")
                }
            }
            HStack(spacing: 10){
                Text(String(gameForum.members.count))
                    .foregroundColor(gameColor.black)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                Text("Members")
                    .foregroundColor(gameColor.gray)
                    .font(.system(size: 20))
                Text(String(gameForum.posts.count))
                    .foregroundColor(gameColor.black)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                Text("Posts")
                    .foregroundColor(gameColor.gray)
                    .font(.system(size: 20))
                
            }
            Text("Admin")
                .fontWeight(.bold)
                .foregroundColor(gameColor.black)
                .font(.system(size: 20))
            MemberRow(member: gameForum.gameforum.admin)
            Divider()
            Text(gameForum.gameforum.description.replacingOccurrences(of: "\\n", with: "\n"))
                .font(.system(size: 20))
            
        }
        )
    }
}
