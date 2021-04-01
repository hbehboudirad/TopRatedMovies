//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation
import XCTest
@testable import TopRatedMovies

class MockWebClient: WebClientProtocol {

    // MARK: - Mock Implementations
    
    var request: NSMutableURLRequest = NSMutableURLRequest()

    var response: HTTPURLResponse?
    
    func setTimeout(timeout: TimeInterval) { }
    
    func setHTTPMethod(method: WebClientHTTPMethod) {
        self.receivedMethod = method
    }
    
    func setContentType(contentType: String) { }
    
    func setHTTPBody(body: String) { }
    
    func sendData(completion: WebCommunicationCompletionHandler? = nil) {
        sendDataCalled = true
        guard let mockResult = mockResult else {
            XCTFail("coreponding result has not been filled")
            return
        }
        completion?(mockResult)
    }
    
    // MARK: - Data for test verification

    var receivedMethod: WebClientHTTPMethod?
    
    var sendDataCalled: Bool = false
    var mockResult: Result<Data, Error>?
}
