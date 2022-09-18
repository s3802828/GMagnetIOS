//
//  TagFilter.swift
//  GMagnet
//
//  Created by Huu Tri on 14/09/2022.
//

import SwiftUI

struct TagFilter: View {
    
    @Binding var textInput: String
    
    @State var isFiltering = false
    @Binding var chosenCategory: [Category]
    
    //MARK: - Get index of item in array function
    func index(of character: Category, array: Array<Category>) -> Int {
        for index in 0..<array.count {
            if array[index].id == character.id {
                return index
            }
        }
        
        return 0
    }
    
    var body: some View {
        VStack {
            HStack {
                SearchBar(text: $textInput)
                
                Spacer()
                
                //MARK: - Filter button
                Button(action: {
                    withAnimation(.default) {
                        isFiltering.toggle()
                    }
                    
                }, label: {
                    if chosenCategory.count == 0 {
                        Image(systemName: isFiltering ? "x.circle" : "line.3.horizontal.decrease.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(.black)
                    } else {
                        Image(systemName: isFiltering ? "x.circle" : "\(chosenCategory.count).circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(isFiltering ? .black : .green)
                    }
                    
                        
                }).padding(.trailing, 15)
                
            }
            
            if isFiltering {
                
                //MARK: - Filter section
                HStack {
                    Text("Selected: ")
                        .padding(.vertical, 10)
                    //MARK: - Display selected tag
                    ScrollView(.horizontal){
                        HStack {
                            ForEach (0..<chosenCategory.count, id: \.self) {
                                i in
                                HStack {
                                    Button(action: {
                                        chosenCategory.remove(at: index(of: chosenCategory[i], array: chosenCategory))
                                    }, label: {
                                        Image(systemName: "x.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15)
                                            .foregroundColor(.gray)
                                    })
                                    .padding(.leading, 5)
                                    
                                    Text("\(chosenCategory[i].category_name)")
                                        .padding(.trailing, 5)
                                }.background{
                                    RoundedRectangle(cornerRadius: 5).fill(.white)
                                }.overlay{
                                    RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1).opacity(0.6)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        
                    }
                }.padding(.horizontal, 10)
                    .padding(.vertical, 5)
                
                
                Divider()
                //MARK: - Display list of tags
                VStack {
                    TagSelectionView(selectedTags: self.$chosenCategory)
                        .frame(height: 200)
                }
                .padding(.vertical, 10)
            }
        }
        .background{
            RoundedRectangle(cornerRadius: 8).fill(.white)
        }.overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1).opacity(0.5))
            .padding(.horizontal, 10)

        
    }
}

//struct TagFilter_Previews: PreviewProvider {
//    static var previews: some View {
//        TagFilter()
//    }
//}
