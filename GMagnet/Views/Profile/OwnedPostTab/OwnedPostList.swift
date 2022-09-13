//
//  OwnedPostList.swift
//  GMagnet
//
//  Created by Giang Le on 13/09/2022.
//

import SwiftUI

struct OwnedPostList: View {
    @State private var searchText=""
    @EnvironmentObject var profile : ProfileViewModel
    var filteredPost: [Post] {
        if searchText == "" {
            return profile.recent_posts.sorted(){
                $0.createdAt.dateValue() > $1.createdAt.dateValue()
            }
            
        }
        return profile.recent_posts.filter {
            $0.title.lowercased()
                .contains(searchText.lowercased()) || $0.content.lowercased()
                .contains(searchText.lowercased())
        }.sorted(){
            $0.createdAt.dateValue() > $1.createdAt.dateValue()
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding(.bottom, 10)
            if filteredPost.count > 0 {
                ForEach(filteredPost, id: \.id) { post in
                    OwnedPostRow().environmentObject(PostViewModel(post: post))
                    Spacer()
                }
            } else {
                Text("No post to show")
                    .foregroundColor(GameColor().gray)
                    .font(.system(size: 20))
            }
            
        }
    }
}

struct OwnedPostList_Previews: PreviewProvider {
    static var previews: some View {
        OwnedPostList()
    }
}
