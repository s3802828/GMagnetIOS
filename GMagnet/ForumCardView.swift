//
//  ForumCardView.swift
//  GMagnet
//
//  Created by Huu Tri on 01/09/2022.
//

import SwiftUI

struct ForumCardView: View {
    var body: some View {
        ZStack{
            VStack {
                
                AsyncImage(url: URL(string: "https://cdn.oneesports.gg/cdn-data/2022/08/GenshinImpact_SumeruCharacters_Wallpaper2.jpg")) {phase in
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
                        
                    }, label: {
                        Text("Visit")
                            .font(.system(size: 18, weight: .heavy , design: .monospaced))
                            .frame(width: 75, height: 30)
                            .background(.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                            .padding(.bottom, 15)
                    })
                    
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
                
            AsyncImage(url: URL(string: "https://img.captain-droid.com/wp-content/uploads/com-mihoyo-genshinimpact-icon.png")) {phase in
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

struct ForumCardView_Previews: PreviewProvider {
    static var previews: some View {
        ForumCardView()
    }
}
