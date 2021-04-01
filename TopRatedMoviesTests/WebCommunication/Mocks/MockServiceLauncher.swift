//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation
@testable import TopRatedMovies

class MockServiceLauncher: WebServiceLauncherProtocol {
    
    // MARK: - Mock implementation
    
    var webService: WebService?
    
    func callWebService(completion: WebCommunicationCompletionHandler?) {
        callWebServiceCalled = true
        guard let result = mockResult else { return }
        completion?(result)
    }
    
    // MARK: - Data for test verification
    
    var callWebServiceCalled = false
    var mockResult: Result<Data, Error>?
}
