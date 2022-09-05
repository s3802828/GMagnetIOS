//
//  TestAdding.swift
//  GMagnet
//
//  Created by Phan Anh on 05/09/2022.
//

import SwiftUI

struct TestAdding: View {
//    let admin = User.get_user(user_id: "C2ZWRdRxkXYOdeXwCC2f7JXaZ5j2")
    
    var body: some View {
        
        Button("Add category"){
            Category.add_category(added_category: Category(id: "1", category_name: "Action"))
        }
        
        Button("Add Forum"){
            User.get_user(user_id: "C2ZWRdRxkXYOdeXwCC2f7JXaZ5j2"){admin in
//                print("User retrieved in add forum: \(admin.id) \(admin.username)")
                let new_forum = GameForum(
                    id: "1",
                    name: "Genshin Impact",
                    description: "Gacha the game",
                    logo: "https://img.captain-droid.com/wp-content/uploads/com-mihoyo-genshinimpact-icon.png",
                    banner: "https://cdn.oneesports.gg/cdn-data/2022/08/GenshinImpact_SumeruCharacters_Wallpaper2.jpg",
                    admin: admin,
                    member_list: [],
                    post_list: [],
                    category_list: [])
                
                GameForum.add_forum(added_forum: new_forum)
            }
            
        }
        
        Button("Show forum"){
            GameForum.get_forum(forum_id: "o4Y7OEUG2GugnKYC1E0E"){forum in
                print(forum)
            }
        }
        
        Button("Toggle join forum"){
            User.get_user(user_id: "C2ZWRdRxkXYOdeXwCC2f7JXaZ5j2"){user in
                GameForum.get_forum(forum_id: "o4Y7OEUG2GugnKYC1E0E"){forum in
                    GameForum.toggle_join_forum(forum: forum, user: user)
                }
            }
        }
        
        Button("Add post"){
            User.get_user(user_id: "C2ZWRdRxkXYOdeXwCC2f7JXaZ5j2"){user in
                GameForum.get_forum(forum_id: "o4Y7OEUG2GugnKYC1E0E"){forum in
                    print("user of new post \(user.username)")
                    print("forum of new post \(forum.name)")
                    let new_post = Post(user: user,
                                        game: forum,
                                        title: "New post",
                                        content: "henloo",
                                        image: "https://cdn.oneesports.gg/cdn-data/2022/08/GenshinImpact_SumeruCharacters_Wallpaper2.jpg",
                                        liked_users: [User](),
                                        comment_list: [Comment]())
                    Post.add_post(added_post: new_post)
                }
            }
        }
        
        Button("Add comment"){
            User.get_user(user_id: "C2ZWRdRxkXYOdeXwCC2f7JXaZ5j2"){user in
                let new_comment = Comment(id: "1", user: user, post: "JF4BNy8GVvBkxkQa0hYO", content: "I ran out of brain cells")
                Comment.add_comment(added_comment: new_comment)
            }
        }
        
        Button("Print users"){
            User.get_users(users_ids: ["C2ZWRdRxkXYOdeXwCC2f7JXaZ5j2"]){user_list in
                print(user_list)
            }
        }
        
    }
}

struct TestAdding_Previews: PreviewProvider {
    static var previews: some View {
        TestAdding()
    }
}
