//
//  User.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation
import Firebase

struct User: Identifiable{
    let id: String
    let username: String
    let name: String
    let email: String
    let avatar: String
    let description: String
    var joined_forums: [String]
    var posts: [String]
    
    init(id:String, username:String, name: String, email:String, avatar: String, description: String, joined_forums: [String], posts: [String]){
        self.id = id
        self.username = username
        self.name = name
        self.email = email
        self.avatar = avatar
        self.description = description
        self.joined_forums = joined_forums
        self.posts = posts
    }
    
    init(){
        self.id = ""
        self.username = ""
        self.name = ""
        self.email = ""
        self.avatar = ""
        self.description = ""
        self.joined_forums = [String]()
        self.posts = [String]()
    }

    func to_dictionary()->[String: Any]{
        //convert to dictionary to save to Firebase

//        var joined_forums_ids: [String] = []
//        var posts_ids: [String] = []
//
//        for forum in self.joined_forums{
//            joined_forums_ids.append(forum.id)
//        }
//        for post in self.posts{
//            posts_ids.append(post.id)
//        }
        
        return [
            "username": self.username,
            "name": self.name,
            "avatar": self.avatar,
            "description": self.description,
            "joined_forums": self.joined_forums,
            "posts": self.posts
        ]
    }
    
    static func get_users(users_ids: [String])->[User]{
        var user_list: [User] = []
        
//        let db = Firestore.firestore()
        for member_id in users_ids {
            user_list.append(User.get_user(user_id: member_id))
        }
        return user_list
    }
    
    static func get_user(user_id: String) -> User {
        let db = Firestore.firestore()
        var user: User = User()
        
        db.collection("users").document(user_id).getDocument{doc, error in
            if let doc = doc, doc.exists {
                let data = doc.data()
                if let data = data {
                    user =  User(id: doc.documentID,
                                username: data["username"] as? String ?? "",
                                name: data["name"] as? String ?? "",
                                email: data["email"] as? String ?? "",
                                avatar: data["avatar"] as? String ?? "",
                                description: data["description"] as? String ?? "",
                                joined_forums: data["joined_forums"] as? [String] ?? [String](),
                                posts: data["posts"] as? [String] ?? [String]()
                        )
                }
            }else{
                print("Doc does not exist")
                return
            }
        }
        
        return user
    }
    
    static func add_user(added_user: User){
        let db = Firestore.firestore()
        
        db.collection("users").addDocument(data: added_user.to_dictionary()){error in
            if let error = error{
                print(error)
            }
        }
    }
    
    static func update_user(updated_user: User){
        let db = Firestore.firestore()
        
        db.collection("users").document(updated_user.id).setData(updated_user.to_dictionary(), merge: true)
        {error in
            if let error = error{
                print(error)
            }
        }
    }
    
    static func delete_user(deleted_user: User){
        let db = Firestore.firestore()
        
        db.collection("users").document(deleted_user.id).delete{ error in
            if let error = error{
                print(error)
            }
        }

    }

}
