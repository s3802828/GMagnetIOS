//
//  GameForumTabView.swift
//  GMagnet
//
//  Created by Giang Le on 09/09/2022.
//

import SwiftUI


struct GameForumTabProfile: View {
    let gradient = LinearGradient(colors: [.blue.opacity(0.3), .green.opacity(0.5)],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    @StateObject var tabbarRouter = TabBarRouter()
    @EnvironmentObject var profile : ProfileViewModel
    @EnvironmentObject var gameForum : GameForumViewModel
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @State var showSearchBar = false
    @State var searchInput = ""
    @State var offset: CGFloat = 0
    @Environment(\.dismiss) var dismiss
    let gameColor = GameColor()
    
    @State var isEditShowing = false
    
    @State var isShowingOption = false
    
    @ViewBuilder var contentView: some View {
        switch tabbarRouter.currentPage {
        case .home:
            GameDetailView()
        case .post:
            PostList()
        case .member:
            MemberList()
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
    
    func delete_forum(){
        self.profile.delete_forum(deleted_forum: gameForum.gameforum)
        dismiss()
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.vertical,showsIndicators: false,
                           content: {
                    PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                        gameForum.refreshGameForum(){
                            if gameForum.gameforum.id == "" {
                                dismiss()
                            }
                        }
                    }
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
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: getRect().width, height:  minY > 0 ? 220 + minY : 220, alignment: .center)
                                                .cornerRadius(0)

                                            
                                        } else {
                                            ProgressView()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: getRect().width, height:  minY > 0 ? 220 + minY : 220, alignment: .center)
                                                .cornerRadius(0)

                                            
                                            
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
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 110, height: 110)
                                            .clipShape(Circle())
                                            .padding(10)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    } else {
                                        ProgressView()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 110, height: 110)
                                            .clipShape(Circle())
                                            .padding(10)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                        
                                    }
                                }
                                
                                Spacer()
                                Button(action: {
                                    gameForum.toggle_join_forum(forum: gameForum.gameforum, authViewModel: currentUser)
                                }, label: {
                                    Text(gameForum.members.contains(where: {$0.id == currentUser.currentUser.id}) ? "Joined" : "Join")
                                        .font(.system(size: 18, weight: .heavy , design: .monospaced))
                                        .frame(width: 75, height: 30)
                                        .background(gameForum.members.contains(where: {$0.id == currentUser.currentUser.id}) ? .gray : .blue)
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 9))
                                        .padding(.horizontal, 10)
                                        .padding(.bottom, 15)
                                })
                                .padding(.top,20)
                                .padding(20)
                                
                                if (currentUser.currentUser.id == gameForum.gameforum.admin.id){
                                    
                                    EditButtonSelection(deleteFunction: {
                                        self.delete_forum()
                                    }, content: {
                                        UpdateForumView(updated_forum: gameForum.gameforum)
                                    })

                                }
                                
                                
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
                    if gameForum.members.contains(where: {$0.id == currentUser.currentUser.id}){
                        TabPlusButton(width: geometry.size.width/7, height: geometry.size.width/7, systemIconName: "plus.circle.fill", tabName: "plus"){
                            CreatePostView(tabRouter: tabbarRouter)
                        }.offset(y: -geometry.size.height/8/2)
                    }
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
            .coordinateSpace(name: "pullToRefresh")
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