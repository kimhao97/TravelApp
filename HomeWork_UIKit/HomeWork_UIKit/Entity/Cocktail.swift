import Foundation

struct Cocktail: Decodable {
    
    let name: String?
    let thumbnail: String?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case thumbnail = "strDrinkThumb"
        case id = "idDrink"
    }
}

//struct Cocktail: Decodable {
//
//    let name: String
//    let thumbnail: String
//    let id: String
//
//    enum CodingKeys: String, CodingKey {
//        case response = "drinks"
//        case name = "strDrink"
//        case thumbnail = "strDrinkThumb"
//        case id = "idDrink"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
//
//        name = try response.decode(String.self, forKey: .name)
//        thumbnail = try response.decode(String.self, forKey: .thumbnail)
//        id = try response.decode(String.self, forKey: .id)
//    }
//}
