//
//  Post.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation
import Firebase

struct Post: Identifiable{
    let id: String
    let user: User
    let game: GameForum
    let title: String
    let content: String
    let image: String
    var liked_users: [User]
    var comment_list: [Comment]
    var createdAt: Timestamp
    
    init(id: String, user: User, game: GameForum, title: String, content: String, image: String, liked_users: [User], comment_list: [Comment], createdAt: Timestamp){
        self.id = id
        self.user = user
        self.game = game
        self.title = title
        self.content = content
        self.image = image
        self.liked_users = liked_users
        self.comment_list = comment_list
        self.createdAt = createdAt
    }
    
    init(user: User, game: GameForum, title: String, content: String, image: String, liked_users: [User], comment_list: [Comment], createdAt: Timestamp){
        self.id = "\(UUID())"
        self.user = user
        self.game = game
        self.title = title
        self.content = content
        self.image = image
        self.liked_users = liked_users
        self.comment_list = comment_list
        self.createdAt = createdAt
    }
    
    init(){
        self.id = ""
        self.user = User()
        self.game = GameForum()
        self.title = ""
        self.content = ""
        self.image = ""
        self.liked_users = [User]()
        self.comment_list = [Comment]()
        self.createdAt = Timestamp.init()
    }
    
    func to_dictionary()->[String: Any]{
        //convert to dictionary to save to Firebase

        var liked_users_id: [String] = []
        var comment_list_id: [String] = []
        
        for liked_user in self.liked_users{
            liked_users_id.append(liked_user.id)
        }
        for user_comment in self.comment_list{
            comment_list_id.append(user_comment.id)
        }
        
        return [
            "user_id": self.user.id,
            "game_id": self.game.id,
            "title": self.title,
            "content": self.content,
            "image": self.image,
            "liked_user": liked_users_id,
            "comment_list": comment_list_id,
            "createdAt": self.createdAt
        ]
    }
    
    static func get_posts(post_ids: [String], completion: @escaping ([Post])->Void){
        var posts_list: [Post] = []
        
        for post_id in post_ids{
            Post.get_post(post_id: post_id){post in
                posts_list.append(post)
                if posts_list.count == post_ids.count{
                    completion(posts_list)
                }
            }
        }
        if posts_list.count == post_ids.count{
            completion(posts_list)
        }
//        return posts_list
    }
    
    static func add_post(added_post: Post){
        User.get_user(user_id: added_post.user.id){post_owner in
            GameForum.get_forum(forum_id: added_post.game.id){updated_forum in
                print("add post invoked")
                
                let db = Firestore.firestore()
                    
                //make variable mutable
                var post_owner = post_owner
                var updated_forum = updated_forum
            
                //add post to Post collection
                let new_id = db.collection("posts").addDocument(data: added_post.to_dictionary()){error in
                    if let error = error{
                        print("Failed to add post \n \(error)")
                    }
                }

                // update user and game forum with new post id
                post_owner.posts.append(new_id.documentID)
                updated_forum.post_list.append(new_id.documentID)

                //update user and game forum with the new post id
                User.update_user(updated_user: post_owner)
                GameForum.update_forum(updated_forum: updated_forum)
            }
        }
        
    }
    
    static func update_post(updated_post: Post, completion: @escaping (Post)->Void){
        let db = Firestore.firestore()
        
        db.collection("posts").document(updated_post.id).setData(updated_post.to_dictionary(), merge: true)
        {error in
            if let error = error{
                print(error)
            } else {
                completion(updated_post)
            }
        }
    }
    
    static func delete_post(deleted_post: Post, completion: @escaping (Post)->Void){
//        var post_owner = User.get_user(user_id: deleted_post.user.id)
//        var updated_forum = GameForum.get_forum(forum_id: deleted_post.game.id)
        
        User.get_user(user_id: deleted_post.user.id){post_owner in
            GameForum.get_forum(forum_id: deleted_post.game.id){updated_forum in
                let db = Firestore.firestore()

                //make variable mutable
                var post_owner = post_owner
                var updated_forum = updated_forum
                
                if let post_index = post_owner.posts.firstIndex(where: {$0 == deleted_post.id}){
                    post_owner.joined_forums.remove(at: post_index)
                }

                if let post_index = updated_forum.post_list.firstIndex(where: {$0 == deleted_post.id}){
                    updated_forum.post_list.remove(at: post_index)
                }

                //update user and game forum with removed post id
                User.update_user(updated_user: post_owner)
                GameForum.update_forum(updated_forum: updated_forum)

                db.collection("posts").document(deleted_post.id).delete{ error in
                    if let error = error{
                        print(error)
                    }
                }
            }
        }
        
    }
    
    static func get_post(post_id: String, completion: @escaping (Post)->Void){
        let db = Firestore.firestore()
        var post = Post()
        
        db.collection("posts").document(post_id).getDocument{doc, error in
            if let doc = doc, doc.exists {
                let data = doc.data()
                if let data = data {
                    User.get_user(user_id: data["user_id"] as? String ?? ""){user in
                        GameForum.get_forum(forum_id: data["game_id"] as? String ?? ""){forum in
                            User.get_users(users_ids: data["liked_user"] as? [String] ?? [String]()){liked_users in
                                Comment.get_comments(comment_ids: data["comment_list"] as? [String] ?? [String]()){comment_list in
                                    post =  Post(id: doc.documentID,
                                                 user: user,
                                                 game: forum,
                                                 title: data["title"] as? String ?? "",
                                                 content: data["content"] as? String ?? "",
                                                 image: data["image"] as? String ?? "",
                                                 liked_users: liked_users,
                                                 comment_list: comment_list,
                                                 createdAt: data["createdAt"] as? Timestamp ?? Timestamp.init())
                                    completion(post)
                                }
                            }
                        }
                    }
                    
                }
            }else{
                print("Doc does not exist")
                completion(post)
                return
            }
        }
        
//        return post
    }
    
    static func toggle_like_post(post: Post, user: User, completion: @escaping (Post)->Void) {
        // Call when user click Like/Unlike a post
        Post.get_post(post_id: post.id){updated_post in
            var updated_post = updated_post
            if let user_index = updated_post.liked_users.firstIndex(where: {$0.id == user.id}){
                // if user have liked the post -> remove user and update post
                updated_post.liked_users.remove(at: user_index)
                Post.update_post(updated_post: updated_post){post in
                    completion(post)
                }
                
            } else{
                // if user have not liked the post -> add user and update post
                updated_post.liked_users.append(user)
                Post.update_post(updated_post: updated_post){post in
                    completion(post)
                }
            }
        }
        
    }
}
