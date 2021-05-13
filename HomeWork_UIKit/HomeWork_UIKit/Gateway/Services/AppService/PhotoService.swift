import Foundation
import NeoNetworking

protocol PhotoServiceable {
    func loadAPI(with PhotoID: String, queryType: QueryType, completionHandler: @escaping (_ Photo: PhotoOutput?, _ error: AppError?) -> Void)
    
    func postLike(with photo: Photo, completionHandler: @escaping (_ photo: PhotoOutput?, _ error: AppError?) -> Void)
}

class PhotoServiceImplement: PhotoServiceable {
    
    var networkProvider: NeoNetworkProviable? {
        return ServiceFacade.getService(NeoNetworkProviable.self)
    }
    
    func loadAPI(with query: String, queryType: QueryType, completionHandler: @escaping (PhotoOutput?, AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = PhotoInput()
        input.pathToApi += queryType.path + (query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "" )
        let request = PhotoAPI(with: input, and: PhotoOutput())
        apiService.load(api: request, onComplete: { (request) in
            guard let output = request.getOutput() else {
                    completionHandler(nil, nil)
                    return
                }
            completionHandler(output, nil)
        }, onRequestError: { request in
            completionHandler(nil, request.output.error)
        }, onServerError: { (error) in
            completionHandler(nil, error?.transformToAppError())
        })
    }
    
    func postLike(with photo: Photo, completionHandler: @escaping (_ comment: PhotoOutput?, _ error: AppError?) -> Void) {
        guard let apiService = networkProvider else { return }
        
        let input = PhotoInput(photo: photo)
        input.requestType = .put
        
        input.pathToApi += "/\(photo.id ?? "0")"
        
        let request = PhotoAPI(with: input, and: PhotoOutput())
        apiService.load(api: request, onComplete: { (request) in
            guard let output = request.getOutput() else {
                    completionHandler(nil, nil)
                    return
                }
            completionHandler(output, nil)
        }, onRequestError: { request in
            completionHandler(nil, request.output.error)
        }, onServerError: { (error) in
            completionHandler(nil, error?.transformToAppError())
        })
    }
}
