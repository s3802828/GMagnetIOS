/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 11/09/2022
  Last modified: 18/09/2022
  Acknowledgement:
  Building a Search Bar in SwiftUI: https://www.appcoda.com/swiftui-search-bar/
*/

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        HStack {
            //MARK: - Text field to input
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        //clear search text button
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    withAnimation(.default){
                        self.isEditing = true
                    }
                }
            //MARK: - Cancel button
            //cancel searching mode
            if isEditing {
                Button(action: {
                    withAnimation(.default){
                        self.isEditing = false
                        self.text = ""
                    }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

