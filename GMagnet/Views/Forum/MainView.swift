//
//  MainView.swift
//  GMagnet
//
//  Created by Huu Tri on 03/09/2022.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var mainViewModels = MainPageViewModel()
    
    var body: some View {
        ZStack {
                ScrollView {
                    VStack {
                        ForEach (mainViewModels.gameforum_list) {
                            forum in
                            ForumCardView()
                                .environmentObject(GameForumViewModel(gameforum_id: forum.id))
                                .padding(.vertical, 5)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                }            
        }.onAppear(){
            mainViewModels.fetch_all_forums()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
