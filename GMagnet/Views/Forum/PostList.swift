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
    var listPost : [Post]
    @State private var searchText=""
    var filteredPost: [Post] {
        if searchText == "" {return listPost}
        return listPost.filter {
            $0.title.lowercased()
                .contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        VStack{
            TextField("Search...", text: $searchText)
            ForEach(filteredPost, id: \.id) { post in
                Button(action: {}){
                    PostRow(post: post)
                }
            }
        }
        
        
    }
}

//struct PostList_Previews: PreviewProvider {
//    static var previews: some View {
//        PostList()
//    }
//}
