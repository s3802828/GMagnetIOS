//
//  GameDetailView.swift
//  GMagnet
//
//  Created by Dat Pham Thanh on 06/09/2022.
//

import SwiftUI

struct GameDetailView: View {
    @State var offset: CGFloat = 0
    let gameName: String
    let gameDescription: String
    let gameColor = GameColor()
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content:{
            Text(gameName)
                .fontWeight(.bold)
                .foregroundColor(gameColor.black)
                .font(.system(size: 30))
            Text(gameDescription)
                .font(.system(size: 20))
            HStack(spacing: 10){
                Text("13")
                    .foregroundColor(gameColor.black)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                Text("Followers")
                    .foregroundColor(gameColor.gray)
                    .font(.system(size: 20))
                Text("35")
                    .foregroundColor(gameColor.black)
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
                Text("Posts")
                    .foregroundColor(gameColor.gray)
                    .font(.system(size: 20))
                
            }
        }
        )
    }
}
