import Foundation
import NeoNetworking

class FavoriteInput: NeoApiInputable {

    var queryType: QueryType = .city
    var requestType: NeoRequestType = .get
    var pathToApi: String = "https://60865d28d14a870017579284.mockapi.io/api/favorites" 
    
    func makeRequestableBody() -> [String: Any] {
        return [:]
    }

    func makeRequestableHeader() -> [String: String] {
        return [:]
    }
}
