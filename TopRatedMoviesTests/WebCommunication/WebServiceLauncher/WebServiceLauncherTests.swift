//
//  Copyright © 2021 HBR. All rights reserved.
//

import XCTest
@testable import TopRatedMovies

class WebServiceLauncherTest: XCTestCase {
    
    func testServiceLauncherCallWebService() {
        // arrange
        let mockWebService = MockWebService()
        let webServiceLauncher = WebServiceLauncher()
        let data = Data([0x00, 0x01, 0x02, 0x03])
        mockWebService.mockResult = Result<Data, Error>.success(data)
        webServiceLauncher.webService = mockWebService
        
        // act
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        var receivedResult: Result<Data, Error>?
        webServiceLauncher.callWebService {
            receivedResult = $0
            callingCompletionExpectation.fulfill()
        }
        
        // wait for expectation
        wait(for: [callingCompletionExpectation], timeout: 0.1)
        
        // assert
        guard let receivedData = try? receivedResult?.get() else {
            XCTFail("didn't get expected result")
            return
        }
        XCTAssertEqual(data, receivedData)
    }
}
