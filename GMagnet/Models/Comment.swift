//
//  Comment.swift
//  GMagnet
//
//  Created by Phan Anh on 02/09/2022.
//

import Foundation
import Firebase

struct Comment: Identifiable{
    let id: String
    let user: User
    let post: String
    var content: String
    let createdAt: Timestamp
    
    init(id: String, user: User, post: String, content: String, createdAt: Timestamp){
        self.id = id
        self.user = user
        self.post = post
        self.content = content
        self.createdAt = createdAt
    }
    init(){
        self.id = ""
        self.user = User()
        self.post = ""
        self.content = ""
        self.createdAt = Timestamp.init()
    }
    
    func to_dictionary()->[String: Any]{
        return [
            "user_id": self.user.id,
            "post_id": self.post,
            "content": self.content,
            "createdAt": self.createdAt
        ]
    }
    
    static func get_comments(comment_ids: [String], completion: @escaping ([Comment])->Void){
        var comment_list: [Comment] = []
        
//        let db = Firestore.firestore()
        for comment_id in comment_ids {
            Comment.get_comment(comment_id: comment_id){comment in
                comment_list.append(comment)
                if comment_list.count == comment_ids.count{
                    completion(comment_list)
                }
            }
        }
        
        if comment_list.count == comment_ids.count{
            completion(comment_list)
        }
//        return comment_list
    }
                        
    static func get_comment(comment_id: String, completion: @escaping (Comment)->Void){
        let db = Firestore.firestore()
        var comment: Comment = Comment()
        
        db.collection("comments").document(comment_id).getDocument{doc, error in
            if let doc = doc, doc.exists {
                let data = doc.data()
                if let data = data {
                    User.get_user(user_id: data["user_id"] as? String ?? ""){user in
                        comment = Comment(id: doc.documentID,
                                          user: user,
                                          post: data["post_id"] as? String ?? "",
                                          content: data["content"] as? String ?? "",
                                          createdAt: data["createdAt"] as? Timestamp ?? Timestamp.init())
                        completion(comment)
                    }
                }
            }else{
                print("Doc does not exist")
                completion(comment)
            }
        }
        
//        return comment
    }
    
    static func add_comment(added_comment: Comment, completion: @escaping () -> Void){
        let db = Firestore.firestore()
        
        Post.get_post(post_id: added_comment.post){updated_post in
            var updated_post = updated_post
            
            //add post to Post collection
            let new_id = db.collection("comments").addDocument(data: added_comment.to_dictionary()){error in
                if let error = error{
                    print(error)
                }
            }
            
            // update post with new comment
            Comment.get_comment(comment_id: new_id.documentID){new_comment in
                updated_post.comment_list.append(new_comment)
                
                //update post with new comment
                Post.update_post(updated_post: updated_post){post in
                    completion()
                }
            }
        }
    }
    
    static func delete_comment(deleted_comment: Comment, completion: @escaping (Post) -> Void){
        let db = Firestore.firestore()
        
        Post.get_post(post_id: deleted_comment.post){updated_post in
            var updated_post = updated_post
            if let comment_index = updated_post.comment_list.firstIndex(where: {$0.id == deleted_comment.id}){
                updated_post.comment_list.remove(at: comment_index)
            }
            
            Post.update_post(updated_post: updated_post){post in
                db.collection("comments").document(deleted_comment.id).delete{error in
                    if let error = error{
                        print(error)
                    }
                }
                
                completion(post)
            }
            
        }
    }
    
    static func update_comment(updated_comment: Comment, completion: @escaping (Comment) -> Void){
        let db = Firestore.firestore()
        
        db.collection("comments").document(updated_comment.id).setData(updated_comment.to_dictionary(), merge: true)
        {error in
            if let error = error{
                print(error)
            }else{
                completion(updated_comment)
            }
        }
    }
                        
}
