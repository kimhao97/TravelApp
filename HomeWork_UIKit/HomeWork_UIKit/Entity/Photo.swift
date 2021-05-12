import Foundation

struct Photo: Decodable {
    let id: String?
    let placeID: String?
    let cityID: String?
    let userID: String?
    let imageUrl: String?
    let like: String?
    let commentID: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case placeID
        case cityID
        case userID
        case imageUrl
        case like = "likes"
        case commentID
    }
}
