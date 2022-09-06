//
//  MemberRow.swift
//  GMagnet
//
//  Created by Dat Pham Thanh on 06/09/2022.
//

import SwiftUI

struct MemberRow: View {
    var member: listMember
    let gameColor = GameColor()
    var body: some View {
        HStack {
            member.imageAvatar
                .resizable()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(.white),lineWidth: 2))
                .shadow(color:gameColor.cyan.opacity(1), radius: 3, x: 1, y: 1)
            Text(member.name)
                .padding()
                .font(.system(size: 25, weight: .semibold))
                .foregroundColor(Color.black)
            
        }
}
}

struct MemberRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MemberRow(member: members[0])
                .previewLayout(.fixed(width: 300, height: 90))
            MemberRow(member: members[1])
                .previewLayout(.fixed(width: 300, height: 90))
        }
    }
}
