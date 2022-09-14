//
//  User.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation
import Firebase
import CoreLocation

struct User: Identifiable{
    let id: String
    let username: String
    let name: String
    let email: String
    let avatar: String
    let description: String
    var joined_forums: [String]
    var posts: [String]
    var longitude: String
    var latitude: String
    
    init(id:String, username:String, name: String, email:String, avatar: String, description: String, joined_forums: [String], posts: [String], longitude: String, latitude: String){
        self.id = id
        self.username = username
        self.name = name
        self.email = email
        self.avatar = avatar
        self.description = description
        self.joined_forums = joined_forums
        self.posts = posts
        self.longitude = longitude
        self.latitude = latitude
    }
    init(id:String, username:String, name: String, email:String, avatar: String, description: String, joined_forums: [String], posts: [String]){
        self.id = id
        self.username = username
        self.name = name
        self.email = email
        self.avatar = avatar
        self.description = description
        self.joined_forums = joined_forums
        self.posts = posts
        self.longitude = ""
        self.latitude = ""
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
        self.latitude = ""
        self.longitude = ""
    }

    func to_dictionary()->[String: Any]{
        //convert to dictionary to save to Firebase
        
        let joined_forum_set = Set(self.joined_forums)

        return [
            "username": self.username,
            "name": self.name,
            "avatar": self.avatar,
            "description": self.description,
            "email": self.email,
            "joined_forums": Array(joined_forum_set),
            "posts": self.posts,
            "longitude": self.longitude,
            "latitude": self.latitude
        ]
    }
    
    static func get_users(users_ids: [String], completion: @escaping ([User])->Void){
        var user_list: [User] = []
//        var counter: Int = 0
        
        for member_id in users_ids {
            User.get_user(user_id: member_id){user in
                user_list.append(user)
                if user_list.count == users_ids.count{
                    completion(user_list)
                }
            }
            
        }
        if user_list.count == users_ids.count{
            completion(user_list)
        }
    }
    
    static func get_user(user_id: String, completion: @escaping (User) -> Void) {
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
                                posts: data["posts"] as? [String] ?? [String](),
                                longitude: data["longitude"] as? String ?? String(),
                                 latitude: data["latitude"] as? String ?? String()
                        )
                }
                completion(user)
            } else {
                print("Doc does not exist")
                completion(User())
            }
        }
    }
    
    static func add_user(added_user: User){
        let db = Firestore.firestore()
        
        db.collection("users").addDocument(data: added_user.to_dictionary()){error in
            if let error = error{
                print(error)
            }
        }
    }
    
    static func update_user(updated_user: User, completion: @escaping (User)->Void){
        let db = Firestore.firestore()
        
        db.collection("users").document(updated_user.id).setData(updated_user.to_dictionary(), merge: true)
        {error in
            if let error = error{
                print(error)
                completion(updated_user)
            }else{
                completion(updated_user)
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
