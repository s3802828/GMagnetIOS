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
//  User.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation
import Firebase
import CoreLocation

struct User: Identifiable{
    
    // MARK: - attributes of user struct
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
    
    //MARK: - constructor to create users with all attributes
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
    
    //MARK: - constructor to create users without longitude and latitude
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
    
    //MARK: - default constructor
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

    //MARK: - convert to dictionary format before storing on the database
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
    
    //MARK: - fetch users from database from list of user ids
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
    
    //MARK: - fetch user from database with id and map it as a User struct
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
    
    //MARK: - add new user to the database
    static func add_user(added_user: User){
        let db = Firestore.firestore()
        
        db.collection("users").addDocument(data: added_user.to_dictionary()){error in
            if let error = error{
                print(error)
            }
        }
    }
    
    //MARK: - update user to the database
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
    
    //MARK: - delete user from the database
    static func delete_user(deleted_user: User){
        let db = Firestore.firestore()
        
        db.collection("users").document(deleted_user.id).delete{ error in
            if let error = error{
                print(error)
            }
        }

    }

}
