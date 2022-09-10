//
//  AddComment.swift
//  GMagnet
//
//  Created by Giang Le on 11/09/2022.
//

import SwiftUI

struct AddComment: View {
    @State var commentInput = ""
    @EnvironmentObject var currentUser: AuthenticateViewModel
    var body: some View {
        ZStack {
            
            HStack{
                AsyncImage(url: URL(string: currentUser.currentUser.avatar)) {phase in
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
                HStack {
                    
                    TextField("Add a comment...", text: $commentInput)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "paperplane")
                        
                    })
                    
                }
                .padding(.horizontal, 10)
                .frame(height: 40)
                .overlay(Capsule().stroke().opacity(0.3))
                .padding(.horizontal, 10)
            }
        }
    }
}
