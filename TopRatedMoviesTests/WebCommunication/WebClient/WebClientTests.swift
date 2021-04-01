//
//  Copyright © 2021 HBR. All rights reserved.
//

import XCTest
@testable import TopRatedMovies

class WebClientTests: XCTestCase {
    
    var webclient: WebClient!
    var session: MockURLSession!
    var mockRequest: NSMutableURLRequest = NSMutableURLRequest()
    
    override func setUp() {
        //create webclient instance for test
        webclient = WebClient(request: mockRequest)
        
        //create mock instances
        session = MockURLSession()

        //connect mock instances with webclientinstance
        webclient.connection = session
    }

    func testSendDataAndStartDelegate() {
        //action
        webclient.sendData()
        
        //assert
        
        //1- whether url session called correctly?
        XCTAssert(session.dataTaskCalled)
        XCTAssertEqual(session.receivedRequest, mockRequest as URLRequest)
    }
    
    func testSendDataWithoutInjectingConnection() {
        // arrange
        webclient.connection = nil
        
        // act
        var receivedResult: Result<Data, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        webclient.sendData {
            receivedResult = $0
            callingCompletionExpectation.fulfill()
        }
        
        // wait for expectation
        wait(for: [callingCompletionExpectation], timeout: 0.1)
        
        // assert ...
        
        //1- completion called?
        XCTAssertNotNil(receivedResult)
        
        switch receivedResult {
        case .failure(let error):
            //2- is passed correct error?
            guard let webClientError = error as? WebClientError else {
                XCTFail("didn't get expected error")
                return
            }
            XCTAssertEqual(webClientError, WebClientError.callingRequestError)
        default:
            XCTFail("didn't get expected result")
        }
    }
    
    func testRecivingNotValidResponse() {
        // act
        var receivedResult: Result<Data, Error>?
        webclient.sendData {
            receivedResult = $0
        }
        webclient.urlSession(session, dataTask: session.task, didReceive: URLResponse()) { _ in
        }
        
        // assert ...
                
        //1- completion called?
        XCTAssertNotNil(receivedResult)
        
        switch receivedResult {
        case .failure(let error):
            //2- is passed correct error?
            guard let webClientError = error as? WebClientError else {
                XCTFail("didn't get expected error")
                return
            }
            XCTAssertEqual(webClientError, WebClientError.parsingResponseError)
        default:
            XCTFail("didn't get expected result")
        }
    }
    
    func testSessionCompeleteWithError() {
        // act
        var receivedResult: Result<Data, Error>?
        webclient.sendData {
            receivedResult = $0
        }
        webclient.urlSession(session, dataTask: session.task, didReceive: HTTPURLResponse()) { _ in
        }
        webclient.urlSession(session, task: session.task, didCompleteWithError: MockError.mockError)
        
        // assert ...
                
        //1- completion called?
        XCTAssertNotNil(receivedResult)
        
        switch receivedResult {
        case .failure(let error):
            //2- is passed correct error?
            guard let mockError = error as? MockError else {
                XCTFail("didn't get expected error")
                return
            }
            XCTAssertEqual(mockError, MockError.mockError)
        default:
            XCTFail("didn't get expected result")
        }
    }

    func testCompeleteWithoutErrorAndDataDeliveredSuccessfully() {
        // act
        let bytes: [UInt8] = [0x00, 0x01, 0x02, 0x03]
        let data = Data(bytes)
        var receivedResult: Result<Data, Error>?
        webclient.sendData {
            receivedResult = $0
        }
        webclient.urlSession(session, dataTask: session.task, didReceive: HTTPURLResponse()) { _ in
        }
        webclient.urlSession(session, dataTask: session.task, didReceive: data)
        webclient.urlSession(session, task: session.task, didCompleteWithError: nil)
        
        // assert
        
        //1- completion called?
        XCTAssertNotNil(receivedResult)
        
        switch receivedResult {
        case .success(let responseData):
            //2- is passed correct data?
            XCTAssertEqual(responseData, data)
        default:
            XCTFail("didn't get expected result")
        }
    }
    
    func testSetHttpMethod() {
        //call target method
        webclient.setHTTPMethod(method: .POST)
        
        //so ...
        webclient.sendData()
        
        //1- whether url session called correctly?
        XCTAssert(session.dataTaskCalled)
        
        //2- delegate informed correctly?
        XCTAssertEqual(session.receivedRequest?.httpMethod, WebClientHTTPMethod.POST.rawValue)
    }
}
