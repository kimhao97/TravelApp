import Foundation
import NeoNetworking

class PhotoInput: NeoApiInputable {

    var queryType: QueryType = .place
    var requestType: NeoRequestType = .get
    var pathToApi: String = "https://60865d28d14a870017579284.mockapi.io/api/photos"
    
    func makeRequestableBody() -> [String: Any] {
        return [:]
    }

    func makeRequestableHeader() -> [String: String] {
        return [:]
    }
}
