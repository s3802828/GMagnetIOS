//
//  GameForum.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation
import Firebase

struct GameForum: Identifiable{
    let id: String
    let name: String
    let description: String
    let logo: String
    let banner: String
    let admin: User
    var member_list: [String]
    var post_list: [String]
    var category_list: [Category]
    
    init(id: String, name: String, description: String, logo: String, banner: String, admin: User, member_list: [String], post_list: [String], category_list: [Category]){
        self.id = id
        self.name = name
        self.description = description
        self.logo = logo
        self.banner = banner
        self.admin = admin
        self.member_list = member_list
        self.post_list = post_list
        self.category_list = category_list
    }
    
    init(){
        self.id = ""
        self.name = ""
        self.description = ""
        self.logo = ""
        self.banner = ""
        self.admin = User(id: "", username: "", name: "", password: "", avatar: "", description: "", joined_forums: [""], posts: [""])
        self.member_list = [String]()
        self.post_list = [String]()
        self.category_list = [Category]()
    }
        
    func to_dictionary()->[String: Any]{
        //convert to dictionary to save to Firebase

//        var member_ids: [String] = []
        var category_ids: [String] = []

//        for member in self.member_list{
//            member_ids.append(member.id)
//        }
        for category in self.category_list{
            category_ids.append(category.id)
        }
        
        return [
            "name": self.name,
            "description": self.description,
            "logo": self.logo,
            "banner": self.banner,
            "admin_id": self.admin.id,
            "member_list": self.member_list,
            "post_list": self.post_list,
            "category_list": category_ids
        ]
    }
    
    static func get_all_forums()->[GameForum]{
        //get database reference
        let db = Firestore.firestore()
        var forum_list: [GameForum] = []
        
        //fetch all the data from forums
        db.collection("GameForum").getDocuments { snapshot, error in
            if let error = error {
                print(error)
            }else{
                if let snapshot = snapshot {
                    forum_list = snapshot.documents.map{doc in
                        return GameForum(id: doc.documentID,
                                         name: doc["name"] as? String ?? "",
                                         description: doc["description"] as? String ?? "",
                                         logo: doc["logo"] as? String ?? "",
                                         banner: doc["banner"] as? String ?? "",
                                         admin: User.get_user(user_id: doc["admin_id"] as? String ?? ""),
                                         member_list: doc["member_lsit"] as? [String] ?? [String](),
                                         post_list: doc["post_list"] as? [String] ?? [String](),
                                         category_list: Category.get_categories(category_list: doc["category_list"] as? [String] ?? [String]())
                                )
                    }
                }
            }
        }
        
        return forum_list
    }
    
    static func get_forum(forum_id: String) -> GameForum {
        let db = Firestore.firestore()
        var forum: GameForum = GameForum()

        db.collection("GameForum").document(forum_id).getDocument{doc, error in
            if let doc = doc, doc.exists {
                let data = doc.data()
                if let data = data {
                    forum = GameForum(id: doc.documentID,
                                      name: data["name"] as? String ?? "",
                                      description: data["description"] as? String ?? "",
                                      logo: data["logo"] as? String ?? "",
                                      banner: data["banner"] as? String ?? "",
                                      admin: User.get_user(user_id: data["admin_id"] as? String ?? ""),
                                      member_list: data["member_list"] as? [String] ?? [String](),
                                      post_list: data["post_list"] as? [String] ?? [String](),
                                      category_list: Category.get_categories(category_list: data["category_list"] as? [String] ?? [String]()))
                    
                }
            }else{
                print("Forum fetch error: Doc \(forum_id) does not exist")
                return
            }
        }
        return forum
    }
    
    static func get_forums(forum_ids: [String])->[GameForum]{
        var forum_list: [GameForum] = []
        
        for forum_id in forum_ids {
            forum_list.append(GameForum.get_forum(forum_id: forum_id))
        }
        return forum_list
    }
    
    static func update_forum(updated_forum: GameForum){
        let db = Firestore.firestore()
        
        db.collection("GameForum").document(updated_forum.id).setData(updated_forum.to_dictionary(), merge: true)
        {error in
            if let error = error{
                print(error)
            }
        }
    }
    
    static func add_forum(added_forum: GameForum){
        let db = Firestore.firestore()
        
        db.collection("GameForum").addDocument(data: added_forum.to_dictionary()){error in
            if let error = error{
                print(error)
            }
        }
    }
    
    static func delete_forum(deleted_forum: GameForum){
        let db = Firestore.firestore()
        
        //remove the forum from users that joined the forum
        for user_id in deleted_forum.member_list{
            var edit_user = User.get_user(user_id: user_id)
            if let forum_index = edit_user.joined_forums.firstIndex(where: {$0 == deleted_forum.id}){
                edit_user.joined_forums.remove(at: forum_index)
                User.update_user(updated_user: edit_user)
            }
        }
        
        //remove the posts of the game forum
        for post_id in deleted_forum.post_list{
            let deleted_post = Post.get_post(post_id: post_id)
            Post.delete_post(deleted_post: deleted_post)
        }
        
        db.collection("GameForum").document(deleted_forum.id).delete{ error in
            if let error = error{
                print(error)
            }
        }
    }
    
    static func toggle_join_forum(forum: GameForum, user: User){
        var updated_forum = GameForum.get_forum(forum_id: forum.id)
        var updated_user = User.get_user(user_id: user.id)
        
        // Call when user click Join/Unjoin on GamePage View
        if let forum_index = updated_user.joined_forums.firstIndex(where: {$0 == updated_forum.id}){
            
            // if user have joined the post -> remove user and update post
            // update User object's joined forum list
            updated_user.joined_forums.remove(at: forum_index)
            
            if let user_id_index = updated_forum.member_list.firstIndex(where: {$0 == user.id}){
                //get index of user id in list of members of gameforum to remove
                updated_forum.member_list.remove(at: user_id_index)
            }
            
            //update user's joined forums on User db
            User.update_user(updated_user: updated_user)
            //update list of members on GameForum db
            GameForum.update_forum(updated_forum: updated_forum)
            
        }else{
            // add forum id to list of joined forum
            updated_user.joined_forums.append(forum.id)
            // add user to list of members of game forum
            updated_forum.member_list.append(updated_user.id)
            
            //save changes to db
            User.update_user(updated_user: updated_user)
            GameForum.update_forum(updated_forum: updated_forum)
        }
    }
}

struct Category: Identifiable{
    let id: String
    let category_name: String
    
    func to_dictionary()->[String: Any]{
        return [
            "category_name": self.category_name,
        ]
    }
    
    static func get_categories(category_list: [String])->[Category]{
        let db = Firestore.firestore()
        var cate_list: [Category] = []
        
        for cat in category_list{
            db.collection("Category").document(cat).getDocument{doc, error in
                if let doc = doc, doc.exists {
                    if let data = doc.data() {
                        cate_list.append(
                            Category(id: data["id"] as? String ?? "",
                                     category_name: data["category_name"] as? String ?? "")
                        )
                    }
                }else{
                    print("Doc for category \(cat) does not exist")
                }
            }
        }
        return cate_list
    }
}
