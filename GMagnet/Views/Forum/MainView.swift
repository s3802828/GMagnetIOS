//
//  MainView.swift
//  GMagnet
//
//  Created by Huu Tri on 03/09/2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var mainViewModels: MainPageViewModel
    @State private var searchText=""
    
    @State var chosenCategory: [Category] = []
    var filteredForum: [GameForum] {
        if searchText == "" && chosenCategory.count == 0 {return mainViewModels.gameforum_list} //default: fetch all
        //only select tag
        else if searchText == "" {
        }
        return mainViewModels.gameforum_list.filter {
            $0.name.lowercased()
                .contains(searchText.lowercased())
        }
    }
    var body: some View {
        ZStack {
                ScrollView {
                    PullToRefresh(coordinateSpaceName: "pullToRefreshMainView") {
                        mainViewModels.fetch_all_forums()
                    }
                        
                        ZStack {

                            VStack {
                                ForEach (filteredForum) {
                                    forum in
                                    
                                    ForumCardView()
                                        .environmentObject(GameForumViewModel(gameforum_id: forum.id))
                                        .padding(.vertical, 5)
                                }
                            
                            }.padding(.top, 60)
                            
                            VStack {
                                TagFilter(textInput: $searchText, chosenCategory: $chosenCategory)
                                Spacer()
                            }
                            
                            
                        }.frame(width: UIScreen.main.bounds.width)
                        
                        
                    
                    
                }.coordinateSpace(name: "pullToRefreshMainView")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
