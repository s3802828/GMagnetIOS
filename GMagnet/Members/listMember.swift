import Foundation
import SwiftUI
import CoreLocation

struct listMember: Identifiable, Codable{
    var id: Int
    var name: String
    var imageName: String
    var imageAvatar: Image {
        Image(imageName)
    }
}


