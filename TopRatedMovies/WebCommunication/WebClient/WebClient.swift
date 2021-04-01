//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

/// Defines functionalities of a WebClient
///
/// WebClient is a class that is responsible to send the web-service data to the server and
/// take care of its connection side challenges like timeout, collecting data, ssl configurations,
/// content-types and content lengths.
///
/// Differences between this class and a web-service is that anything in this class is related
/// to the HTTP web protocol and it do not involve at any business protocol or business challenges
/// like encryption, decryption, checking response as valid string or etc.
protocol WebClientProtocol: class {
   
    /// Instance of the data that have to be sent to the server.
    var request: NSMutableURLRequest { get }

    /// Instance of the HTTPURLResponse that is received from server.
    ///
    /// If no response received then this would be nil.
    var response: HTTPURLResponse? { get }
    
    /// Timeout for the web request.
    ///
    /// Default is 60 Seconds.
    func setTimeout(timeout: TimeInterval)
    
    /// HTTP Method of the web call.
    ///
    /// Default is GET
    ///
    /// - Parameters:
    ///    - method: http method type as `WebClientHTTPMethod`
    func setHTTPMethod(method: WebClientHTTPMethod)
    
    /// Sends data to the server
    ///
    /// - Parameters:
    ///     - completion: Calls this closure when network call finishes, that delivers a result object
    ///                   with Data for successful case and Error for failure case.
    func sendData(completion: WebCommunicationCompletionHandler?)
}

// MARK: - WebClientProtocol
class WebClient: NSObject, WebClientProtocol {
    
    var response: HTTPURLResponse?
                
    let request: NSMutableURLRequest
    
    var connection: URLSession?
    
    // The data will be collected in this instance and after completing the operation it will send to the completion handler
    private var responseData: NSMutableData?
    
    private var completion: WebCommunicationCompletionHandler?
    
    init(request: NSMutableURLRequest) {
        self.request = request
        super.init()
    }
    
    func setTimeout(timeout: TimeInterval) {
        self.request.timeoutInterval = timeout
    }
    
    func setHTTPMethod(method: WebClientHTTPMethod) {
        self.request.httpMethod = method.rawValue
    }
    
    func sendData(completion: WebCommunicationCompletionHandler? = nil) {
        self.completion = completion
        if let task = self.connection?.dataTask(with: self.request as URLRequest) {
            responseData = NSMutableData()
            task.resume()
        } else {
            completion?(.failure(WebClientError.callingRequestError))
        }
    }
}

// MARK: - URLSessionDelegate
extension WebClient: URLSessionDataDelegate {
    typealias ReceivedResponseResult = (URLSession.ResponseDisposition) -> Void
 
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        responseData?.append(data)
    }
    
    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping ReceivedResponseResult) {
        //check wether the received response is a valid HTTPURLResponse
        if let httpResponse =  response as? HTTPURLResponse {
            self.response = httpResponse
            completionHandler(URLSession.ResponseDisposition.allow)
        } else {
            completion?(.failure(WebClientError.parsingResponseError))
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            completion?(.failure(error))
            return
        }
        guard let responseData = self.responseData else { return }//unexpected situation
        
        completion?(.success(responseData as Data))
    }
}
