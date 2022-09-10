//
//  TabViews.swift
//  GMagnet
//
//  Created by Huu Tri on 03/09/2022.
//

import SwiftUI

enum Page {
    case home
    case post
    case member
    case profile
    case plus
}

struct TabViews: View {
    let gradient = LinearGradient(colors: [.blue.opacity(0.3), .green.opacity(0.5)],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    @StateObject var tabbarRouter = TabBarRouter()
    @EnvironmentObject var currentUser: AuthenticateViewModel
    
    @State var showSearchBar = false
    @State var searchInput = ""
    
    @ViewBuilder var contentView: some View {
        switch tabbarRouter.currentPage {
        case .home:
            MainView()
        case .post:
            Text("Post")
        case .member:
            Text("member")
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
                
                HStack {
                    if !self.showSearchBar {
                        Text("GMagnet").fontWeight(.bold).font(.title).foregroundColor(.white)
                    }
                    
                    Spacer(minLength: 0)
                    
                    HStack {
                        
                        if self.showSearchBar {
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                            
                            TextField("Search...", text: self.$searchInput)
                            
                            Button(action: {
                                searchInput = ""
                                withAnimation{
                                    self.showSearchBar.toggle()
                                }
                                
                            }, label: {
                                
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                
                            })
                            .padding(.horizontal, 8)
                            
                        } else {
                            
                            Button(action: {
                                withAnimation{
                                    self.showSearchBar.toggle()
                                }
                            }, label: {
                                
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black)
                                    .padding(10)
                                
                            })
                            
                            
                        }
                        
                    }
                    .padding(self.showSearchBar ? 10 : 0)
                    .background(Color.white)
                        .cornerRadius(20)
                    
                    
                }.padding(.top, 40)
                    .padding(.horizontal)
                    .padding(.bottom,10)
                    .background(Color.blue)
                
                Spacer()
                // Contents
                contentView
                Spacer()
                // Tabbar
                HStack {
                    Spacer()
                    
                    TabItem(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "homekit", tabName: "Home", tabbarRouter: tabbarRouter, assignedPage: .home)

                    Spacer()
                    TabPlusButton(width: geometry.size.width/7, height: geometry.size.width/7, systemIconName: "plus.circle.fill", tabName: "plus")
                          .offset(y: -geometry.size.height/8/2)
                    Spacer()
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

struct TabPlusButton: View {
    let width, height: CGFloat
    let systemIconName, tabName: String
    
    var body: some View {
        ZStack {
            Button(action: {
                
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
            })
            
        }
        .padding(.horizontal, -4)
    }
}