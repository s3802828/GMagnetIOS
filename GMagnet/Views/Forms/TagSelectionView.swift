/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 11/09/2022
  Last modified: 18/09/2022
*/

import SwiftUI

struct TagSelectionView: View {
    
    let tagColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 3, alignment: nil),
        GridItem(.flexible(), spacing: 3, alignment: nil),
    ]
    
    @Binding var selectedTags: [Category] 
    @State var tagList: [Category] = []
    
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
        ZStack {
            ScrollView{
                VStack {
                    //MARK: - List of category view
                    LazyVGrid(columns: tagColumns, alignment: .center, spacing: 5, pinnedViews: [], content: {
                        ForEach (tagList.sorted(){
                            $0.category_name < $1.category_name
                        }, id: \.id) {
                            i in
                            
                            //MARK: - Category button
                            Button(action: {
                                if (selectedTags.contains(where: { $0.id == i.id})) {
                                    selectedTags.remove(at: index(of: i, array: selectedTags))
                                } else {
                                    selectedTags.append(i)
                                }
                            }, label: {
                                // When the category button is clicked, add that category to the list and highlight the button
                                HStack{
                                    Image(systemName: selectedTags.contains(where: { $0.id == i.id}) ? "checkmark.circle" : "circle")
                                        .foregroundColor(selectedTags.contains(where: { $0.id == i.id}) ? .green : .black)
                                    Text("\(i.category_name)")
                                    Spacer()
                                }.foregroundColor(.black)
                                .padding(.all, 5)
                                    .frame(width: 150)
                                .background{
                                    RoundedRectangle(cornerRadius: 8).stroke(selectedTags.contains(where: { $0.id == i.id}) ? .green : .black).opacity(0.6)
                                }
                            })
                            
                        }
                        
                    })
                }
            }
        }.onAppear(){
            Category.get_all_categories(){cat_list in
                self.tagList = cat_list
            }
        }
    }
}

struct TagSelectionView_Previews: PreviewProvider {
    static var previews: some View {
//        TagSelectionView()
        HStack{}
    }
}
