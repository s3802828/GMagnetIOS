//
//  CreatePost.swift
//  GMagnet
//
//  Created by Giang Le on 11/09/2022.
//

import SwiftUI

struct CreatePost: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button(action: {
            dismiss()
        }){
            HStack (spacing: 2) {
                Image(systemName: "xmark")
                Text("Cancel")
            }.padding(.horizontal, 5)
        }
    }
}

struct CreatePost_Previews: PreviewProvider {
    static var previews: some View {
        CreatePost()
    }
}
