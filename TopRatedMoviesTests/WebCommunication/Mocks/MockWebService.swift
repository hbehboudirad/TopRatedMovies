//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation
import XCTest
@testable import TopRatedMovies

class MockWebService: WebService {
    
    // MARK: - Mock Implementation

    var webRequest: WebRequestProtocol = MockWebRequest(mockUrl: "")
    
    func call(completion: WebCommunicationCompletionHandler?) {
        sendDataCalled = true
        guard let mockResult = mockResult else {
            XCTFail("coreponding result has not been filled")
            return
        }
        completion?(mockResult)
    }
    
    // MARK: - Data for test verification
    
    var sendDataCalled: Bool = false
    var mockResult: Result<Data, Error>?
}
