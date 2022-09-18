/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 09/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
 How To Create A Custom Tab Bar In SwiftUI: https://blckbirds.com/post/custom-tab-bar-in-swiftui/
*/

import SwiftUI


struct GameForumTabView: View {
    let gradient = LinearGradient(colors: [.blue.opacity(0.3), .green.opacity(0.5)],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    @StateObject var tabbarRouter = TabBarRouter()
    @EnvironmentObject var mainViewModel : MainPageViewModel
    @EnvironmentObject var gameForum : GameForumViewModel
    @EnvironmentObject var currentUser: AuthenticateViewModel
    @State var showSearchBar = false
    @State var searchInput = ""
    @State var offset: CGFloat = 0
    @Environment(\.dismiss) var dismiss
    let gameColor = GameColor()
    
    @State var isEditShowing = false
    
    @State var isShowingOption = false
    //MARK: - Content of each tab declaration
    @ViewBuilder var contentView: some View {
        switch tabbarRouter.currentPage {
        case .home:
            //Default view is game detail view
            GameDetailView()
        case .post:
            // post tab view
            PostList()
        case .member:
            // member tab view
            MemberList()
        case .profile:
            //Unused tab name
            Text("Profile")
        case .plus:
            //not used to show view
            EmptyView()
        }
    }
    //MARK: - Delete forum function
    func delete_forum(){
        self.mainViewModel.delete_forum(deleted_forum: gameForum.gameforum)
        dismiss()
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.vertical,showsIndicators: false,
                           content: {
                    //MARK: - PullToRefresh view
                    PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                        gameForum.refreshGameForum(){
                            //if game forum is deleted, dismiss this tab view
                            if gameForum.gameforum.id == "" {
                                dismiss()
                            }
                        }
                    }
                    VStack(spacing: 15){
                        //MARK: - Common header
                        GeometryReader{proxy -> AnyView in
                            
                            let minY = proxy.frame(in: .global).minY
                            //track if image is stretched
                            DispatchQueue.main.async{
                                self.offset = minY
                            }
                            return AnyView(
                                ZStack{
                                    //Game banner
                                    AsyncImage(url: URL(string: gameForum.gameforum.banner)) {phase in
                                        if let image = phase.image {  //Succefully load image
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: getRect().width, height:  minY > 0 ? 220 + minY : 220, alignment: .center)
                                                .cornerRadius(0)
                                            
                                        } else if phase.error != nil { //fail to load image
                                            Image(systemName: "x.circle")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: getRect().width, height:  minY > 0 ? 220 + minY : 220, alignment: .center)
                                                .cornerRadius(0)
                                            
                                        } else { //image is loading
                                            ProgressView()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: getRect().width, height:  minY > 0 ? 220 + minY : 220, alignment: .center)
                                                .cornerRadius(0)
                                        }
                                    }
                                    
                                }
                                    .frame(height: minY > 0 ? 220 + minY : nil) //identify height of image when stretched or normal
                                    .offset(y: minY > 0 ? -minY: 0)
                            )
                        }.frame(height: 220)
                        VStack{
                            HStack{
                                //Game logo
                                AsyncImage(url: URL(string: gameForum.gameforum.logo)) {phase in
                                    if let image = phase.image { //Succefully load image
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 110, height: 110)
                                            .clipShape(Circle())
                                            .padding(10)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    } else if phase.error != nil { //fail to load image
                                        Image(systemName: "x.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 110, height: 110)
                                            .clipShape(Circle())
                                            .padding(10)
                                            .background(Color.white)
                                            .clipShape(Circle())

                                    } else {//image is loading
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
                                //MARK: - Join button
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
                                //MARK: - Edit & Delete Buttons
                                //Only show when forum is created by user
                                if (currentUser.currentUser.id == gameForum.gameforum.admin.id){
                                    EditButtonSelection(deleteFunction: {
                                        self.delete_forum()
                                    }, content: {
                                        UpdateForumView(updated_forum: gameForum.gameforum)
                                    })
                                    
                                }
                            }.padding(.top, -55)
                            //MARK: - Content View
                            contentView
                        }.padding(.horizontal)
                    }
                }).ignoresSafeArea(.all,edges: .top)
                
                Spacer()
                // MARK: - Common footer: Tabbar
                HStack {
                    Spacer()
                    //MARK: - Back button
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
                    // MARK: - Description tab
                    TabItem(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "info.circle", tabName: "Description", tabbarRouter: tabbarRouter, assignedPage: .home)
                    
                    Spacer()
                    // MARK: - Add post tab
                    if gameForum.members.contains(where: {$0.id == currentUser.currentUser.id}){
                        TabPlusButton(width: geometry.size.width/7, height: geometry.size.width/7, systemIconName: "plus.circle.fill", tabName: "plus"){
                            CreatePostView(tabRouter: tabbarRouter)
                        }.offset(y: -geometry.size.height/8/2)
                    }
                    Spacer()
                    // MARK: - Discussion post tab
                    TabItem(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "message.circle", tabName: "Discussion", tabbarRouter: tabbarRouter, assignedPage: .post)
                    Spacer()
                    TabItem(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "person.3", tabName: "Members", tabbarRouter: tabbarRouter, assignedPage: .member).padding(.trailing, 15)
                    
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
