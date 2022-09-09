//
//  GameForumTabView.swift
//  GMagnet
//
//  Created by Giang Le on 09/09/2022.
//

import SwiftUI


struct GameForumTabView: View {
    let gradient = LinearGradient(colors: [.blue.opacity(0.3), .green.opacity(0.5)],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    @StateObject var tabbarRouter = TabBarRouter()
    @EnvironmentObject var gameForum : GameForumViewModel
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @State var showSearchBar = false
    @State var searchInput = ""
    @State var offset: CGFloat = 0
    @Environment(\.dismiss) var dismiss
    let gameColor = GameColor()
    
    @ViewBuilder var contentView: some View {
        switch tabbarRouter.currentPage {
        case .home:
            GameDetailView(gameName: gameForum.gameforum.name, gameDescription: gameForum.gameforum.description)
        case .post:
            PostList(listPost: gameForum.posts)
        case .member:
            Text("Member")
        case .profile:
            VStack {
                Text("Profile")
                Button(action: {
                    currentUser.signOutUser()
                }, label: {
                    Text("Logout")
                        .font(.system(size: 18, weight: .heavy , design: .monospaced))
                        .frame(width: 75, height: 30)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                        .padding(.bottom, 15)
                })
            }
        case .plus:
            EmptyView()
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
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
                                    AsyncImage(url: URL(string: gameForum.gameforum.banner)) {phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: getRect().width, height:  minY > 0 ? 220 + minY : 220, alignment: .center)
                                                .cornerRadius(0)
                                            
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
                                    
                                }
                                    .frame(height: minY > 0 ? 220 + minY : nil)
                                    .offset(y: minY > 0 ? -minY: 0)
                            )
                        }.frame(height: 220)
                        VStack{
                            HStack{
                                AsyncImage(url: URL(string: gameForum.gameforum.logo)) {phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 110, height: 110)
                                            .clipShape(Circle())
                                            .padding(10)
                                            .background(Color.white)
                                            .clipShape(Circle())
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
                                
                            }.padding(.top, -55)
                            //Tab Content
                            contentView
                        }.padding(.horizontal)
                    }
                }).ignoresSafeArea(.all,edges: .top)
                
                Spacer()
                // Tabbar
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "arrow.backward.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width/5, height:  geometry.size.height/28)
                            .padding(.top, 10)
                        Text("Back")
                            .font(.footnote)
                        Spacer()
                    }
                    .padding(.horizontal, -4)
                    .onTapGesture {
                        dismiss()
                    }
                    Spacer()
                    TabItem(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "info.circle", tabName: "Description", tabbarRouter: tabbarRouter, assignedPage: .home)
                    
                    Spacer()
                    TabPlusButton(width: geometry.size.width/7, height: geometry.size.width/7, systemIconName: "plus.circle.fill", tabName: "plus")
                        .offset(y: -geometry.size.height/8/2)
                    Spacer()
                    TabItem(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "message.circle", tabName: "Discussion", tabbarRouter: tabbarRouter, assignedPage: .post)
                    Spacer()
                    TabItem(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "person.3", tabName: "Members", tabbarRouter: tabbarRouter, assignedPage: .member)
                }
                .frame(width: geometry.size.width, height: geometry.size.height/10)
                .background(Color(.black).shadow(radius: 2).opacity(0.03))
            }
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear(){
                print(gameForum.posts)
            }
        }
    }
}


//struct GameForumTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameForumTabView()
//    }
//}

//extension View{
//    func getRect()->CGRect{
//        return UIScreen.main.bounds
//    }
//
//}
