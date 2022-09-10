/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 1
 Author: Pham Thanh Dat
 ID: 3678437
 Created  date: 29/07/2022
 Last modified: 07/08/2022
 Acknowledgement: Acknowledge the resources that you use here.
 */

import SwiftUI

struct PostList: View {
    @State private var searchText=""
    @State var showPostDetail = false
    @EnvironmentObject var gameForum : GameForumViewModel
    var filteredPost: [Post] {
        if searchText == "" {return gameForum.posts}
        return gameForum.posts.filter {
            $0.title.lowercased()
                .contains(searchText.lowercased()) || $0.content.lowercased()
                .contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding(.bottom, 10)
            ForEach(filteredPost, id: \.id) { post in
                PostRow(post: post)
                Spacer()
            }
        }
    }
}

//struct PostList_Previews: PreviewProvider {
//    static var previews: some View {
//        PostList()
//    }
//}