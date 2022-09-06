import Foundation
import CoreLocation

var members = decodeJsonFromJsonFile(jsonFileName: "Details.json")

// How to decode a json file into a struct
func decodeJsonFromJsonFile(jsonFileName: String) -> [listMember] {
    if let file = Bundle.main.url(forResource: jsonFileName, withExtension: nil){
        if let data = try? Data(contentsOf: file) {
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([listMember].self, from: data)
                return decoded
            } catch let error {
                fatalError("Failed to decode JSON: \(error)")
            }
        }
    } else {
        fatalError("Couldn't load \(jsonFileName) file")
    }
    return [ ] as [listMember]
}
