//
//  UpdatePostView.swift
//  GMagnet
//
//  Created by Huu Tri on 12/09/2022.
//

import SwiftUI

struct UpdatePostView: View {
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            Button(action: {
                dismiss()
            }, label: {
                Text("dismiss")
            })
        }
    }
}

struct UpdatePostView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePostView()
    }
}
