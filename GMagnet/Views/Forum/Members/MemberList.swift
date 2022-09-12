import SwiftUI

struct MemberList: View {
    @EnvironmentObject var gameForum : GameForumViewModel
    @State private var searchText=""
    var filteredMember: [User] {
        if searchText == "" {return gameForum.members}
        return gameForum.members.filter {
            $0.name.lowercased()
                .contains(searchText.lowercased())
        }
    }
    var body: some View {
        VStack (alignment: .leading, spacing: 5){
            SearchBar(text: $searchText)
                .padding(.bottom, 10)
            if filteredMember.count > 0 {
                ForEach(filteredMember, id: \.id) { member in
                    Button(action: {}){
                        MemberRow(member: member)
                    }
                }
            } else {
                Text("No members to show")
                    .foregroundColor(GameColor().gray)
                    .font(.system(size: 20))
            }
        }
    }
}

