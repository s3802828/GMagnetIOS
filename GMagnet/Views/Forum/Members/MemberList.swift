/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 06/09/2022
  Last modified: 18/09/2022
 Acknowledgement:
 T.Huynh."SSETContactList/ContactList/Views/ContactList.swift".GitHub.https://github.com/TomHuynhSG/SSETContactList/blob/main/ContactList/Views/ContactList.swift.
*/
import SwiftUI

struct MemberList: View {
    @EnvironmentObject var gameForum : GameForumViewModel
    @State private var searchText=""
    //MARK: - Handle search function
    var filteredMember: [User] {
        if searchText == "" {//if not search, return all
            return gameForum.members}
        return gameForum.members.filter {
            //otherwise, filter the member whose name contain search text
            $0.name.lowercased()
                .contains(searchText.lowercased())
        }
    }
    var body: some View {
        VStack (alignment: .leading, spacing: 5){
            //MARK: - Search Bar
            SearchBar(text: $searchText)
                .padding(.bottom, 10)
            //MARK: - Member list
            if filteredMember.count > 0 {
                // if member list has elements
                ForEach(filteredMember, id: \.id) { member in
                        MemberRow(member: member)
                }
            } else { //otherwise, show this message
                Text("No members to show")
                    .foregroundColor(GameColor().gray)
                    .font(.system(size: 20))
            }
        }
    }
}

