//
//  MainView.swift
//  GMagnet
//
//  Created by Huu Tri on 03/09/2022.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var mainViewModels = MainPageViewModel()
    @State private var searchText=""
    var filteredForum: [GameForum] {
        if searchText == "" {return mainViewModels.gameforum_list}
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
                    VStack {
                        SearchBar(text: $searchText)
                            .padding(.bottom, 10)
                        ForEach (filteredForum) {
                            forum in
                            ForumCardView()
                                .environmentObject(GameForumViewModel(gameforum_id: forum.id))
                                .padding(.vertical, 5)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                }.coordinateSpace(name: "pullToRefreshMainView")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
