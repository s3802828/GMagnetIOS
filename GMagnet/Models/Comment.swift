/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 02/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
- Get data with Cloud Firestore: https://firebase.google.com/docs/firestore/query-data/get-data
- Add data to Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/add-data
- Delete data from Cloud Firestore: https://firebase.google.com/docs/firestore/manage-data/delete-data
- Update a document: https://firebase.google.com/docs/firestore/manage-data/add-data#update-data
- Wait until Firestore getdocuments() is finished before moving on - Swift: https://www.appsloveworld.com/swift/100/304/swiftui-wait-until-firestore-getdocuments-is-finished-before-moving-on
*/

import Foundation
import Firebase

struct Comment: Identifiable{
    // MARK: - attributes of comment struct
    let id: String
    let user: User
    let post: String
    var content: String
    let createdAt: Timestamp
    
    //MARK: - constructor to create comment with all attributes
    init(id: String, user: User, post: String, content: String, createdAt: Timestamp){
        self.id = id
        self.user = user
        self.post = post
        self.content = content
        self.createdAt = createdAt
    }
    
    //MARK: - default constructor for comment
    init(){
        self.id = ""
        self.user = User()
        self.post = ""
        self.content = ""
        self.createdAt = Timestamp.init()
    }
    
    //MARK: - convert to dictionary format before storing on the database
    func to_dictionary()->[String: Any]{
        return [
            "user_id": self.user.id,
            "post_id": self.post,
            "content": self.content,
            "createdAt": self.createdAt
        ]
    }
    
    //MARK: - get list of comments by ids
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
                 
    //MARK: - get comment by id
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
    
    //MARK: - add new commen to the database
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
    
    //MARK: - delete comment from the database
    static func delete_comment(deleted_comment: Comment, completion: @escaping (Post) -> Void){
        let db = Firestore.firestore()
        
        Post.get_post(post_id: deleted_comment.post){updated_post in
            var updated_post = updated_post
            
            //update the list of comments of the post
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
    
    //MARK: - update comment to the database
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
