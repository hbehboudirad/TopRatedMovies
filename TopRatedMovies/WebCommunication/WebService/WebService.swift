//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

/// Defines functionalities of a WebService
///
/// Webservice is a layer that is responsible to convert business data to networking protocol data. Make
/// sures that this data is delivering in correct way to server and also convert server data to
/// business data and makes sure that received data is correct.
///
/// In order to achieve above responsibility web service uses WebRequests that provides data for
/// each server call; WebService may apply any transformation to the data and then send it to
/// the server. For example if there is any encryption/decryption operations these kind of
/// operations will done here.
///
/// Differences between the shared operations that WebService is doing with shared operations
/// that WebServiceLauncher is doing is that WebServiceLauncher is at business side operations
/// and WebService is at web communication, protocol and server side operations.
protocol WebService: class {
    /// Instance of the web-request that must send to server.
    ///
    /// For more information read `WebRequestProtocol`
    var webRequest: WebRequestProtocol { get }
            
    /// Calls the corresponding API of the web-request
    ///
    /// - Parameters:
    ///     - completion: Calls this closure when network call finishes, that delivers a result object
    ///                   with Data for successful case and Error for failure case.
    func call(completion: WebCommunicationCompletionHandler?)
}

class CoreWebService: WebService {
    let webRequest: WebRequestProtocol
    var mainQueue = DispatchQueue.main
        
    private let webClient: WebClientProtocol
        
    init(webRequest: WebRequestProtocol, webClient: WebClientProtocol) {
        self.webRequest = webRequest
        self.webClient = webClient
    }
    
    func call(completion: WebCommunicationCompletionHandler? = nil) {
        webClient.setHTTPMethod(method: WebClientHTTPMethod.GET)
        webClient.sendData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.handleSuccessfulResult(data: data, completion: completion)
            case .failure(let error):
                self.passError(error: error, completion: completion)
            }
        }
    }
    
    // MARK: - Private
    
    private func handleSuccessfulResult(data: Data, completion: WebCommunicationCompletionHandler?) {
           let statusCode = webClient.response?.statusCode ?? -1
           
           switch statusCode {
           case 200:
               handleReceivedData(data: data, completion: completion)
           case 400..<500:
               passError(error: WebServiceError.httpRequestStatusError, completion: completion)
           case 500..<600:
               passError(error: WebServiceError.httpServerStatusError, completion: completion)
           default:
               passError(error: WebServiceError.httpUnknownError, completion: completion)
           }
       }
    
    private func handleReceivedData(data: Data, completion: WebCommunicationCompletionHandler?) {
        guard data.count > 0 else {
            passError(error: WebServiceError.emptyData, completion: completion)
            return
        }
        mainQueue.async { completion?(.success(data)) }
    }
    
    private func passError(error: Error, completion: WebCommunicationCompletionHandler?) {
        mainQueue.async { completion?(.failure(error)) }
    }
}
