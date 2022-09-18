/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 03/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
 How To Create A Custom Tab Bar In SwiftUI: https://blckbirds.com/post/custom-tab-bar-in-swiftui/
*/

import SwiftUI
//MARK: - Tab page name declaration frame
enum Page {
    case home
    case post
    case member
    case profile
    case plus
}
//MARK: - TabView
struct TabViews: View {
    let gradient = LinearGradient(colors: [.blue.opacity(0.3), .green.opacity(0.5)],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    @StateObject var tabbarRouter = TabBarRouter()
    @StateObject var mainViewModels = MainPageViewModel()
    @EnvironmentObject var currentUser: AuthenticateViewModel
    //MARK: - Content of each tab declaration
    @ViewBuilder var contentView: some View {
        switch tabbarRouter.currentPage {
        case .home:
            //Default view is main view (list of forums)
            MainView().environmentObject(mainViewModels)
        case .post:
            // Unused tab name
            Text("Post")
        case .member:
            //Unused tab name
            Text("member")
        case .profile:
            //Profile tab show profile tab view
            ProfileTab()
                .environmentObject(ProfileViewModel(user_id: currentUser.currentUser.id))
                .environmentObject(mainViewModels)
        case .plus:
            //not used to show view
            EmptyView()
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                HStack {
                    //MARK: - GMagnet common header
                    Text("GMagnet").fontWeight(.bold).font(.title).foregroundColor(.white)
                    Spacer(minLength: 0)
                    
                    
                }.padding(.top, 40)
                    .padding(.horizontal)
                    .padding(.bottom,10)
                    .background(Color.blue)
                
                Spacer()
                // MARK: - Content view
                contentView
                Spacer()
                // Tabbar
                //MARK: - Tabbar Footer
                HStack {
                    Spacer()
                    //MARK: - Home main view tab
                    TabItem(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "homekit", tabName: "Home", tabbarRouter: tabbarRouter, assignedPage: .home)

                    Spacer()
                    //MARK: - Add forum tab
                    TabPlusButton(width: geometry.size.width/7, height: geometry.size.width/7, systemIconName: "plus.circle.fill", tabName: "plus"){
                        CreateForumView(curr_user: currentUser.currentUser)
                            .environmentObject(mainViewModels)
                            .environmentObject(currentUser)
                    }
                          .offset(y: -geometry.size.height/8/2)
                    Spacer()
                    //MARK: - Profile tab
                    TabItem(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "person.crop.circle", tabName: "Profile", tabbarRouter: tabbarRouter, assignedPage: .profile)
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height/10)
                .background(Color(.black).shadow(radius: 2).opacity(0.03))
            }
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct TabViews_Previews: PreviewProvider {
    static var previews: some View {
        TabViews()
    }
}


//MARK: - TabItem
struct TabItem: View {
    
     let width, height: CGFloat
     let systemIconName, tabName: String
    
    @ObservedObject var tabbarRouter: TabBarRouter
    let assignedPage: Page
     
     
     var body: some View {
         VStack {
             Image(systemName: systemIconName)
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width: width, height: height)
                 .padding(.top, 10)
             Text(tabName)
                 .font(.footnote)
             Spacer()
         }
         .padding(.horizontal, -4)
         .foregroundColor(tabbarRouter.currentPage == assignedPage ? .blue : .gray)
         .onTapGesture {
               tabbarRouter.currentPage = assignedPage
           }
     }
 }

//MARK: - TabPlus button
struct TabPlusButton<Content:View>: View {
    let width, height: CGFloat
    let systemIconName, tabName: String
    let openView : Content
    @State var isShowing = false
    init(width: CGFloat, height: CGFloat, systemIconName: String, tabName: String, @ViewBuilder content: () -> Content){
        self.width = width
        self.height = height
        self.systemIconName = systemIconName
        self.tabName = tabName
        self.openView = content()
    }
    var body: some View {
        ZStack {
            Button(action: {
                isShowing = true
            }, label: {
                Image(systemName: systemIconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width-6 , height: height-6)
                    .foregroundColor(.blue)
                    .background{
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: width, height: height)
                            .shadow(radius: 4)
                    }
            }).fullScreenCover(isPresented: $isShowing){
                openView
            }
            
        }
        .padding(.horizontal, -4)
    }
}
//MARK: - Edit & Delete Menu Frame
struct EditButtonSelection<Content:View>: View {
    
    let openEditView : Content
    @State var isEditShowing = false
    let deleteFunc: () -> Void
    init(deleteFunction: @escaping () -> Void, @ViewBuilder content: () -> Content){
        self.openEditView = content()
        self.deleteFunc = deleteFunction
    }
    
    var body: some View{
        Menu(content: {
            //edit button
            Button(action: {
                isEditShowing = true
                print("Edit clicked")
            }, label: {
                HStack {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .foregroundColor(Color("ButtonColor"))
                    Text("Edit")
                }
            })
            //delete button
            Button(action: {
                deleteFunc()
            }, label: {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(Color("ButtonColor"))
                    Text("Delete")
                }
            })
        }, label: {
            Image(systemName: "ellipsis.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 25)
                .foregroundColor(Color("ButtonColor"))
                
        }).fullScreenCover(isPresented: $isEditShowing) {
            openEditView
        }
    }
}
