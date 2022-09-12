//
//  CommentRow.swift
//  GMagnet
//
//  Created by Giang Le on 11/09/2022.
//

import SwiftUI

struct CommentRow: View {
    var comment: Comment
    var body: some View {
        HStack {
            VStack {
                AsyncImage(url: URL(string: comment.user.avatar)) {phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(.gray))
                            .padding(.leading, 10)

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
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(comment.user.name)
                        .fontWeight(.bold)
                    Spacer()
                    Text(comment.createdAt.getDateDifference())
                        .fontWeight(.bold)
                }
                
                
                Text(comment.content)
                    .padding(.all, 5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke().opacity(0.5))
            }
        }
        .padding(.all, 3)
        .frame(width: 370, alignment: .leading)
    }
}
