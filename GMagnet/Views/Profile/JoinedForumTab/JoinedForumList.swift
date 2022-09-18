/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 13/09/2022
  Last modified: 18/09/2022
 Acknowledgement:
 T.Huynh."SSETContactList/ContactList/Views/ContactList.swift".GitHub.https://github.com/TomHuynhSG/SSETContactList/blob/main/ContactList/Views/ContactList.swift.
*/

import SwiftUI

struct JoinedForumList: View {
    @EnvironmentObject var profile: ProfileViewModel
    @State private var searchText=""
    //MARK: - Handle search function
    var filteredForum: [GameForum] {
        if searchText == "" {//if not search, return all
            return profile.joined_forums}
        return profile.joined_forums.filter {
            //otherwise, filter the forum whose name contain search text
            $0.name.lowercased()
                .contains(searchText.lowercased())
        }
    }
    var body: some View {
        VStack {
            //MARK: - Search Bar
            SearchBar(text: $searchText)
                .padding(.bottom, 10)
            //MARK: - Forum list
            if filteredForum.count > 0 {
                // if forum list has elements
                ForEach (filteredForum) {
                    forum in
                    JoinedForumCardView()
                        .environmentObject(GameForumViewModel(gameforum_id: forum.id))
                        .padding(.vertical, 5)
                }
            } else {//otherwise, show this message
                Text("No forums to show")
                    .foregroundColor(GameColor().gray)
                    .font(.system(size: 20))
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
