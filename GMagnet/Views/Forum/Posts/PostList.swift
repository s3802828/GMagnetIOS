/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 07/09/2022
  Last modified: 18/09/2022
 Acknowledgement:
 T.Huynh."SSETContactList/ContactList/Views/ContactList.swift".GitHub.https://github.com/TomHuynhSG/SSETContactList/blob/main/ContactList/Views/ContactList.swift.
*/

import SwiftUI

struct PostList: View {
    @State private var searchText=""
    @EnvironmentObject var gameForum : GameForumViewModel
    //MARK: - Handle search function
    var filteredPost: [Post] {
        if searchText == "" { //if not search, return all
            return gameForum.posts.sorted(){ // sort by created date
                $0.createdAt.dateValue() > $1.createdAt.dateValue()
            }
            
        }
        return gameForum.posts.filter { //otherwise, filter the posts whose title or content contain search text
            $0.title.lowercased()
                .contains(searchText.lowercased()) || $0.content.lowercased()
                .contains(searchText.lowercased())
        }.sorted(){ // sort by created date
            $0.createdAt.dateValue() > $1.createdAt.dateValue()
        }
    }
    
    var body: some View {
        VStack {
            //MARK: - Search Bar
            SearchBar(text: $searchText)
                .padding(.bottom, 10)
            //MARK: - Post list
            if filteredPost.count > 0 {// if post list has elements
                ForEach(filteredPost, id: \.id) { post in
                    PostRow().environmentObject(PostViewModel(post: post))
                    Spacer()
                }
            } else { //otherwise, show this message
                Text("No posts to show")
                    .foregroundColor(GameColor().gray)
                    .font(.system(size: 20))
            }
            
        }
    }
}
