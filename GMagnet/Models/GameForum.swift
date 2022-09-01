//
//  GameForum.swift
//  GMagnet
//
//  Created by Phan Anh on 01/09/2022.
//

import Foundation

struct GameForum: Identifiable{
    let id: String
    let name: String
    let description: String
    let logo: String
    let banner: String
    let admin: User
    let member_list: [User]
    let category_list: [Category]
    
    func to_dictionary()->[String: Any]{
        //convert to dictionary to save to Firebase

        var member_ids: [String] = []
        var category_ids: [String] = []
        
        for member in self.member_list{
            member_ids.append(member.id)
        }
        for category in self.category_list{
            category_ids.append(category.id)
        }
        
        return [
            "name": self.name,
            "description": self.description,
            "logo": self.logo,
            "banner": self.banner,
            "admin_id": self.admin.id,
            "member_list": member_ids,
            "category_list": category_ids
        ]
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
}
