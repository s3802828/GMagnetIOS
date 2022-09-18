/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 03/09/2022
  Last modified: 18/09/2022
 Acknowledgement:
 T.Huynh."SSETContactList/ContactList/Views/ContactList.swift".GitHub.https://github.com/TomHuynhSG/SSETContactList/blob/main/ContactList/Views/ContactList.swift.
*/

import SwiftUI

struct MainView: View {
    @EnvironmentObject var mainViewModels: MainPageViewModel
    @State private var searchText=""
    
    @State var chosenCategory: [Category] = []
    //MARK: - Handle search & filter function
    var filteredForum: [GameForum] {
        if searchText == "" && chosenCategory.count == 0 {return mainViewModels.gameforum_list} //default: fetch all if not search and filter
        //only filter tag
        else if searchText == "" {
            //filter the forum that has at least 1 common category with chosen category in filter
            let categoryID = chosenCategory.map{$0.id}
            let chosenCatSet: Set<String> = Set(categoryID)
            return mainViewModels.gameforum_list.filter {
                let curCarID = $0.category_list.map{$0.id}
                let curCatSet: Set<String> = Set(curCarID)
                return curCatSet.intersection(chosenCatSet).count > 0
            }
        } else if chosenCategory.count == 0 { //only search text
            return mainViewModels.gameforum_list.filter { // filter the forum whose name contain search text
                $0.name.lowercased()
                    .contains(searchText.lowercased())
            }
        } else { //if both search + filter,
            let categoryID = chosenCategory.map{$0.id}
            let chosenCatSet: Set<String> = Set(categoryID)
            return mainViewModels.gameforum_list.filter { // filter the forum whose name contain search text
                $0.name.lowercased()
                    .contains(searchText.lowercased())
            }.filter { //then, filter the forum that has at least 1 common category with chosen category in filter
                let curCarID = $0.category_list.map{$0.id}
                let curCatSet: Set<String> = Set(curCarID)
                return curCatSet.intersection(chosenCatSet).count > 0
            }
        }
    }
    var body: some View {
        ZStack {
                ScrollView {
                    //MARK: - Pull to refresh
                    PullToRefresh(coordinateSpaceName: "pullToRefreshMainView") {
                        mainViewModels.fetch_all_forums()
                    }
                    //MARK: - Forum list
                        ZStack {
                            VStack {
                                if filteredForum.count > 0 {
                                    // if forum list has elements
                                    ForEach (filteredForum) {
                                        forum in
                                        ForumCardView()
                                            .environmentObject(GameForumViewModel(gameforum_id: forum.id))
                                            .padding(.vertical, 5)
                                    }
                                } else { //otherwise, show this message
                                    Text("No forums to show")
                                        .foregroundColor(GameColor().gray)
                                        .font(.system(size: 20))
                                }
                                
                            }.padding(.top, 60)
                            //MARK: - Filter & Search
                            VStack {
                                TagFilter(textInput: $searchText, chosenCategory: $chosenCategory)
                                Spacer()
                            }
                        }.frame(width: UIScreen.main.bounds.width)
                }.coordinateSpace(name: "pullToRefreshMainView")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
