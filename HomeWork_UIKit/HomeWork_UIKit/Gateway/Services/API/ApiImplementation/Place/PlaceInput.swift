import Foundation
import NeoNetworking

class PlaceInput: NeoApiInputable {

    var requestType: NeoRequestType = .get
    var pathToApi: String = "https://60865d28d14a870017579284.mockapi.io/api/places?id="
    
    func makeRequestableBody() -> [String: Any] {
        return [:]
    }

    func makeRequestableHeader() -> [String: String] {
        return [:]
    }
}
