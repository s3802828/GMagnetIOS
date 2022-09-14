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
    @Published var gameforum_list: [GameForum] = []
    
    init(){
        self.fetch_all_forums()
    }
    
    func fetch_all_forums(){
        //get database reference
        GameForum.get_all_forums(){all_forums in
            self.gameforum_list = all_forums
        }
    }
    
    func update_forum(updated_forum: GameForum){
        GameForum.update_forum(updated_forum: updated_forum){forum in
            self.fetch_all_forums()
        }
    }
    
    func add_forum(added_forum: GameForum){
        let new_id = GameForum.add_forum(added_forum: added_forum)
        GameForum.get_forum(forum_id: new_id){forum in
            GameForum.toggle_join_forum(forum: forum, user: forum.admin){ _ in
                self.fetch_all_forums()
            }
        }
    }
    
    func delete_forum(deleted_forum: GameForum){
        GameForum.delete_forum(deleted_forum: deleted_forum){
            self.fetch_all_forums()
        }
    }
    
}
