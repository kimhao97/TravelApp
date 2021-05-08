import NeoNetworking

class APIConfigableSample: APIConfigable {
    var debugger: DebuggerConfig = .none
    var host: String = ""
}

enum QueryType {
    case city
    case place
    case user
    case photo
    case none
    
    var path: String {
        switch self {
        case .city:
            return "?cityID="
        case .place:
            return "?placeID="
        case .user:
            return "?userID="
        case .photo:
            return "?photoID="
        case .none:
            return ""
        }
    }
}
