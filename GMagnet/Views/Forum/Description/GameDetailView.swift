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

            
            
            ScrollView {
                GeometryReader { geometry in

                        WrappedLayout(geometry: geometry)

                    
                }
            }.frame(height: 75)


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

struct WrappedLayout: View {
    
    @EnvironmentObject var gameForum : GameForumViewModel
    
    let geometry: GeometryProxy

    var body: some View {
        self.generateContent(in: geometry)
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return HStack {
            ZStack(alignment: .topLeading) {
                
                ForEach(gameForum.gameforum.category_list) {
                    category in

                    self.item(for: category.category_name)
                        .padding([.horizontal, .vertical], 4)
                        .alignmentGuide(.leading, computeValue: { d in
                            if (abs(width - d.width) > g.size.width)
                            {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if category.category_name == gameForum.gameforum.category_list.first!.category_name {
                                width = 0 //last item
                            } else {
                                width -= d.width
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: {d in
                            let result = height
                            if category.category_name == gameForum.gameforum.category_list.first!.category_name {
                                height = 0 // last item
                            }
                            return result
                        })
                }
            }
        }
        
    }

    func item(for text: String) -> some View {
        Text("# \(text)")
        
    }
}
