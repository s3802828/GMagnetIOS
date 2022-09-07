//
//  GameDetailView.swift
//  GMagnet
//
//  Created by Dat Pham Thanh on 06/09/2022.
//

import SwiftUI

struct GameDetailView: View {
    @State var offset: CGFloat = 0
    let gameColor = GameColor()
    var body: some View {
      
        ScrollView(.vertical,showsIndicators: false,
                   content: {
            VStack(spacing: 15){
                GeometryReader{proxy -> AnyView in
                    
                    let minY = proxy.frame(in: .global).minY
                    
                    DispatchQueue.main.async{
                        self.offset = minY
                    }
                    return AnyView(
                        ZStack{
                            Image("forzaBanner")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: getRect().width, height:  minY > 0 ? 220 + minY : 220, alignment: .center)
                                .cornerRadius(0)
                        }
                            .frame(height: minY > 0 ? 220 + minY : nil)
                            .offset(y: minY > 0 ? -minY: 0)
                    )
                }.frame(height: 220)
                VStack{
                    HStack{
                        Image("nobita")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                           
                        Spacer()
                        Button(action: {}, label:{
                            Text("Join")
                                
                                .padding(.vertical,10)
                                .padding(.horizontal)
                                .font(.system(size: 25))
                                .foregroundColor(gameColor.cyan)
                                .background(
                                
                                Capsule()
                                    .stroke(gameColor.cyan, lineWidth: 2.0)
                                    .frame(width: 110, height: 50)
                                )
                        })
                        .padding(.top,20)
                        .padding(20)
                        
                    }
                    .padding(.top, -55)
                    VStack(alignment: .leading, spacing: 10, content:{
                        Text("Game name")
                           
                        
                            .fontWeight(.bold)
                            .foregroundColor(gameColor.black)
                            .font(.system(size: 30))
                        Text("kasj;dl;jf;lsdjf;jsa;'jf;lsajdfl;'asjkd;lfkas;lkdfl;ksadl;'fk;laskf;'lskal;dfks;ladkfsl;ksdl;kfl;sak;flksl;dkf;lska;lfks;ldkf;slkd;fks;kf;sakd;flksa;klf;'sadkf;'skdf;l'ksad;kfds;l")
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
                .padding(.horizontal)
            }
        }).ignoresSafeArea(.all,edges: .top)
}
}

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailView()
    }
}
extension View{
    func getReact()-> CGRect{
        return UIScreen.main.bounds
    }
    
}
