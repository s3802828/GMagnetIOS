import SwiftUI

struct MemberList: View {
    
    @State private var searchText=""
    var filteredMember: [listMember] {
        if searchText == "" {return members}
        return members.filter {
            $0.name.lowercased()
                .contains(searchText.lowercased())
        }
    }
    var body: some View {
        ZStack{
            NavigationView {
                List(filteredMember){
                    listMember in
                    NavigationLink{
//                        MemberCard(member: listMember)
                    } label: {
                        MemberRow(member: listMember)
                    }
                    .navigationTitle("Member List ")
                    
                    
                }
            }.searchable(text: $searchText)
        }.navigationBarHidden(true)
        
    }
}

struct MemberList_Previews: PreviewProvider {
    static var previews: some View {
        MemberList()
    }
}
