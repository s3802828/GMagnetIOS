//
//  JoinedForumList.swift
//  GMagnet
//
//  Created by Giang Le on 13/09/2022.
//

import SwiftUI

struct JoinedForumList: View {
    @EnvironmentObject var profile: ProfileViewModel
    @State private var searchText=""
    var filteredForum: [GameForum] {
        if searchText == "" {return profile.joined_forums}
        return profile.joined_forums.filter {
            $0.name.lowercased()
                .contains(searchText.lowercased())
        }
    }
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding(.bottom, 10)
            ForEach (filteredForum) {
                forum in
                JoinedForumCardView()
                    .environmentObject(GameForumViewModel(gameforum_id: forum.id))
                    .padding(.vertical, 5)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}


struct JoinedForumList_Previews: PreviewProvider {
    static var previews: some View {
        JoinedForumList()
    }
}
