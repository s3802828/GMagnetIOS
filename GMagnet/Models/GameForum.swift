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
        self.admin = User()
        self.member_list = [String]()
        self.post_list = [String]()
        self.category_list = [Category]()
    }
    
    func to_dictionary()->[String: Any]{
        //convert to dictionary to save to Firebase
        
        var category_ids: [String] = []
        
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
    
    static func get_all_forums(completion: @escaping ([GameForum])->Void){
        //get database reference
        let db = Firestore.firestore()
        var forum_list: [GameForum] = []
        
        //fetch all the data from forums
        db.collection("gameforums").getDocuments { snapshot, error in
            if let error = error {
                print(error)
            }else{
                if let snapshot = snapshot {
                    snapshot.documents.map {doc in
                        User.get_user(user_id: doc["admin_id"] as? String ?? ""){user in
                            Category.get_categories(category_list: doc["category_list"] as? [String] ?? [String]()){categories in
                                let new_forum = GameForum(id: doc.documentID,
                                                          name: doc["name"] as? String ?? "",
                                                          description: doc["description"] as? String ?? "",
                                                          logo: doc["logo"] as? String ?? "",
                                                          banner: doc["banner"] as? String ?? "",
                                                          admin: user,
                                                          member_list: doc["member_list"] as? [String] ?? [String](),
                                                          post_list: doc["post_list"] as? [String] ?? [String](),
                                                          category_list: categories)
                                
                                forum_list.append(new_forum)
                                if snapshot.documents.count == forum_list.count{
                                    completion(forum_list)
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        
        //        return forum_list
    }
    
    static func get_forum(forum_id: String, completion: @escaping (GameForum)->Void) {
        let db = Firestore.firestore()
        var forum: GameForum = GameForum()
        
        db.collection("gameforums").document(forum_id).getDocument{doc, error in
            if let doc = doc, doc.exists {
                let data = doc.data()
                if let data = data {
                    User.get_user(user_id: data["admin_id"] as? String ?? ""){user in
                        //                        print("user in the forum \(user.username)")
                        Category.get_categories(category_list: data["category_list"] as? [String] ?? [String]()){categories in
                            //                            print("categories in the forum \(categories)")
                            forum = GameForum(id: doc.documentID,
                                              name: data["name"] as? String ?? "",
                                              description: data["description"] as? String ?? "",
                                              logo: data["logo"] as? String ?? "",
                                              banner: data["banner"] as? String ?? "",
                                              admin: user,
                                              member_list: data["member_list"] as? [String] ?? [String](),
                                              post_list: data["post_list"] as? [String] ?? [String](),
                                              category_list: categories)
                            
                            completion(forum)
                        }
                    }
                    
                }
            }else{
                print("Forum fetch error: Doc \(forum_id) does not exist")
                completion(forum)
            }
        }
        //        return forum
    }
    
    static func get_forums(forum_ids: [String], completion: @escaping ([GameForum])->Void){
        var forum_list: [GameForum] = []
        
        for forum_id in forum_ids {
            GameForum.get_forum(forum_id: forum_id){game_forum in
                forum_list.append(game_forum)
                
                if forum_list.count == forum_ids.count {
                    completion(forum_list)
                }
            }
        }
        
        if forum_list.count == forum_ids.count {
            completion(forum_list)
        }
        //        return forum_list
    }
    
    static func update_forum(updated_forum: GameForum, completion: @escaping (GameForum)->Void){
        let db = Firestore.firestore()
        
        db.collection("gameforums").document(updated_forum.id).setData(updated_forum.to_dictionary(), merge: true)
        {error in
            if let error = error{
                print(error)
            }else{
                completion(updated_forum)
            }
        }
    }
    
    static func add_forum(added_forum: GameForum){
        let db = Firestore.firestore()
        
        db.collection("gameforums").addDocument(data: added_forum.to_dictionary()){error in
            if let error = error{
                print(error)
            }
        }
    }
    
    static func delete_forum(deleted_forum: GameForum, completion: @escaping () -> Void){
        let db = Firestore.firestore()
        
        //remove the forum from users that joined the forum
        for user_id in deleted_forum.member_list{
            User.get_user(user_id: user_id){edit_user in
                //make it editable variable
                var edit_user = edit_user
                
                if let forum_index = edit_user.joined_forums.firstIndex(where: {$0 == deleted_forum.id}){
                    edit_user.joined_forums.remove(at: forum_index)
                    User.update_user(updated_user: edit_user){user in
                        
                    }
                }
            }
        }
        
        //remove the posts of the game forum
        if deleted_forum.post_list.count > 0 {
            for post_id in deleted_forum.post_list{
                Post.get_post(post_id: post_id){deleted_post in
                    Post.delete_post(deleted_post: deleted_post){
                        
                        if post_id == deleted_forum.post_list[deleted_forum.post_list.count - 1]{
                            db.collection("gameforums").document(deleted_forum.id).delete{ error in
                                if let error = error{
                                    print(error)
                                }else{
                                    completion()
                                }
                            }
                        }
                        
                    }
                }
            }
        }else{
            db.collection("gameforums").document(deleted_forum.id).delete{ error in
                if let error = error{
                    print(error)
                }else{
                    completion()
                }
            }
        }
    }
    
    static func toggle_join_forum(forum: GameForum, user: User, completion: @escaping (GameForum)->Void){
        
        
        GameForum.get_forum(forum_id: forum.id){forum in
            User.get_user(user_id: user.id){user in
                var updated_forum = forum
                var updated_user = user
                
                // Call when user click Join/Unjoin on GamePage View
                if let forum_index = updated_user.joined_forums.firstIndex(where: {$0 == updated_forum.id}){
                    
                    // if user have joined the post -> remove user and update post
                    // update User object's joined forum list
//                    updated_user.joined_forums.remove(at: forum_index)
                    
                    updated_user.joined_forums = updated_user.joined_forums.filter({$0 != updated_forum.id})
                    
                    if let user_id_index = updated_forum.member_list.firstIndex(where: {$0 == user.id}){
                        //get index of user id in list of members of gameforum to remove
//                        updated_forum.member_list.remove(at: user_id_index)
                        
                        updated_forum.member_list = updated_forum.member_list.filter({$0 != user.id})
                    }
                    
                    //update user's joined forums on User db
                    User.update_user(updated_user: updated_user){user in
                        //update list of members on GameForum db
                        GameForum.update_forum(updated_forum: updated_forum){ forum in
                            completion(forum)
                        }
                    }
                }else{
                    // add forum id to list of joined forum
                    updated_user.joined_forums.append(forum.id)
                    // add user to list of members of game forum
                    updated_forum.member_list.append(updated_user.id)
                    
                    //save changes to db
                    User.update_user(updated_user: updated_user){user in
                        //update list of members on GameForum db
                        GameForum.update_forum(updated_forum: updated_forum){ forum in
                            completion(forum)
                        }
                    }
                }
            }
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
    
    static func add_category(added_category: Category){
        let db = Firestore.firestore()
        
        db.collection("categories").addDocument(data: added_category.to_dictionary()){error in
            if let error = error{
                print(error)
            }
        }
    }
    
    static func get_category(category_id: String, completion: @escaping (Category)->Void){
        let db = Firestore.firestore()
        var category: Category = Category(id: "", category_name: "")
        
        db.collection("categories").document(category_id).getDocument{doc, error in
            if let doc = doc, doc.exists {
                if let data = doc.data() {
                    category = Category(id: doc.documentID,
                                        category_name: data["category_name"] as? String ?? "")
                    
                    completion(category)
                }
            }else{
                print("Doc for category \(category_id) does not exist")
                completion(category)
            }
        }
    }
    
    static func get_all_categories(completion: @escaping ([Category])->Void){
        //get database reference
        let db = Firestore.firestore()
        var categories_list: [Category] = []
        
        //fetch all the data from forums
        db.collection("categories").getDocuments { snapshot, error in
            if let error = error {
                print(error)
            }else{
                if let snapshot = snapshot {
                    snapshot.documents.map{doc in
                        categories_list.append(Category(id: doc.documentID, category_name: doc["category_name"] as? String ?? ""))
                        
                        if categories_list.count == snapshot.documents.count{
                            completion(categories_list)
                        }
                    }
                }
            }
        }
    }
    
    static func get_categories(category_list: [String], completion: @escaping ([Category]) -> Void){
        var cate_list: [Category] = []
        
        for cat in category_list{
            Category.get_category(category_id: cat){category in
                cate_list.append(category)
                
                if cate_list.count == category_list.count {
                    print(cate_list)
                    completion(cate_list)
                    
                }
            }
        }
        
        if cate_list.count == category_list.count{
            completion(cate_list)
        }
    }
}
