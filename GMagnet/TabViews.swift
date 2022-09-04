//
//  TabViews.swift
//  GMagnet
//
//  Created by Huu Tri on 03/09/2022.
//

import SwiftUI

enum Page {
    case home
    case map
    case videos
    case profile
    case plus
}

struct TabViews: View {
    let gradient = LinearGradient(colors: [.blue.opacity(0.3), .green.opacity(0.5)],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    @StateObject var tabbarRouter = TabBarRouter()
    
    @ViewBuilder var contentView: some View {
        switch tabbarRouter.currentPage {
        case .home:
            MainView()
        case .map:
            Text("Map")
        case .videos:
            Text("Video")
        case .profile:
            Text("Profile")
        case .plus:
            EmptyView()
        }
    }
    
//    var body: some View {
//        TabView {
//            ZStack {
//                Color.green
//                    .opacity(0.1)
//                    .ignoresSafeArea()
//
//                VStack {
//                    Text("You can use gradients as the TabView's background color.")
//                        .padding()
//                        .frame(maxHeight: .infinity)
//
//                    Rectangle()
//                        .fill(Color.clear)
//                        .frame(height: 10)
//                        .background(gradient)
//                }
//                .font(.title2)
//            }
//            .tabItem {
//                Image(systemName: "star")
//                Text("Tab 1")
//            }
//
//            Text("Tab 2")
//                .tabItem {
//                    Image(systemName: "moon")
//                    Text("Tab 2")
//                }
//
//            Text("Tab 3")
//                .tabItem {
//                    Image(systemName: "sun.max")
//                    Text("Tab 3")
//                }
//        }
//    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
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
                .frame(width: geometry.size.width, height: geometry.size.height/8)
                .background(Color(.black).shadow(radius: 2).opacity(0.03))
            }
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
