/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors:
- Le Quynh Giang (s3802828)
- Phan Truong Quynh Anh (s3818245)
- Ngo Huu Tri (s3818520)
- Pham Thanh Dat (s3678437)
  Created  date: 01/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
- Get data with Cloud Firestore: https://firebase.google.com/docs/firestore/query-data/get-data
- Add data to Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/add-data
- Delete data from Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/delete-data
- Update a document: https://firebase.google.com/docs/firestore/manage-data/add-data#update-data
- Wait until Firestore detdocuments()is finished before moving on - Swift: https://www.appsloveworld.com/swift/100/304/swiftui-wait-until-firestore-getdocuments-is-finished-before-moving-on
*/

//
//  GameForumViewModel.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation
import Firebase

// View Model for Main view and its children Views
class MainPageViewModel: ObservableObject {
    // variable keep track list of game forums
    @Published var gameforum_list: [GameForum] = []
    
    init(){
        self.fetch_all_forums()
    }
    
    // MARK: - function to fetch all forums to display
    func fetch_all_forums(){
        //get database reference
        GameForum.get_all_forums(){all_forums in
            self.gameforum_list = all_forums
        }
    }
    
    // MARK: - function to update forum on main page and refresh UI
    func update_forum(updated_forum: GameForum){
        GameForum.update_forum(updated_forum: updated_forum){forum in
            self.fetch_all_forums()
        }
    }
    
    // MARK: - function to add forum to main page and refresh UI
    func add_forum(added_forum: GameForum){
        let new_id = GameForum.add_forum(added_forum: added_forum)
        GameForum.get_forum(forum_id: new_id){forum in
            GameForum.toggle_join_forum(forum: forum, user: forum.admin){ _ in
                self.fetch_all_forums()
            }
        }
    }
    
    // MARK: - function to delete forum from main page and refresh UI
    func delete_forum(deleted_forum: GameForum){
        GameForum.delete_forum(deleted_forum: deleted_forum){
            self.fetch_all_forums()
        }
    }
    
}
