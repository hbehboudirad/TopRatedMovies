//
//  Copyright © 2021 HBR. All rights reserved.
//

import XCTest
@testable import TopRatedMovies

class WebServiceTest: XCTestCase {
    
    var testURL: URL!
    var testData: Data!
    var request: MockWebRequest!
    var client: MockWebClient!
    var webService: CoreWebService!
    var mockMainQueue: DispatchQueue!
    
    override func setUp() {
        guard let url = URL(string: "http://test.com") else {
            XCTFail("url has not generated")
            return
        }
        testURL = url
        
        let bytes: [UInt8] = [0x00, 0x01, 0x02, 0x03]
        testData = Data(bytes)
        
        request = MockWebRequest(mockUrl: url.path)
        client = MockWebClient()
        webService = CoreWebService(webRequest: request, webClient: client)
        
        mockMainQueue = DispatchQueue(label: "MockMainQueueForUnitTestOfWebService")
        webService.mainQueue = mockMainQueue
    }
    
    func testCall() {
        // arrange
        client.mockResult = Result<Data, Error>.success(testData)
        
        // act
        webService.call()
        
        // assert ...
        
        //1- method has been set
        XCTAssertNotNil(client.receivedMethod)
        
        //2- method is Get
        XCTAssertEqual(client.receivedMethod, .GET)
        
        //4- client called for firing web service
        XCTAssert(client.sendDataCalled)
    }
    
    func testClientFailureWithError() {
        // arrange
        client.mockResult = Result<Data, Error>.failure(MockError.mockError)
        
        // act
        var receivedResult: Result<Data, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        webService.call {
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
            XCTAssertEqual(error.localizedDescription, MockError.mockError.localizedDescription)
        default:
            XCTFail("didn't get expected result")
        }
    }
    
    func testClientSuccessWithNilResponse() {
        // arrange
        client.mockResult = Result<Data, Error>.success(testData)
        
        // act
        var receivedResult: Result<Data, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        webService.call {
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
            guard let webServiceError = error as? WebServiceError else {
                XCTFail("didn't get expected error")
                return
            }
            XCTAssertEqual(webServiceError, WebServiceError.httpUnknownError)
        default:
            XCTFail("didn't get expected result")
        }
    }
    
    func testClientSuccessWithValidResponseAndData() {
        // arrange
        let response = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        client.response = response
        client.mockResult = Result<Data, Error>.success(testData)
        
        // act
        var receivedResult: Result<Data, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        webService.call {
            receivedResult = $0
            callingCompletionExpectation.fulfill()
        }
        
        // wait for expectation
        wait(for: [callingCompletionExpectation], timeout: 0.1)
        
        // assert ...
        
        //1- is success called?
        XCTAssertNotNil(receivedResult)
        
        switch receivedResult {
        case .success(let data):
            //2- is data as expected?
            XCTAssertEqual(data, testData)
        default:
            XCTFail("didn't get expected result")
        }
    }
    
    func testClientSuccessWithValidResponseAndEmptyData() {
        //config required data
        let bytes: [UInt8] = []
        let data = Data(bytes)
        let response = HTTPURLResponse(url: testURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        client.response = response
        client.mockResult = Result<Data, Error>.success(data)
        
        // act
        var receivedResult: Result<Data, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        webService.call {
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
            guard let webServiceError = error as? WebServiceError else {
                XCTFail("didn't get expected error")
                return
            }
            XCTAssertEqual(webServiceError, WebServiceError.emptyData)
        default:
            XCTFail("didn't get expected result")
        }
    }
    
    func testClientSuccessWithValidResponseAnd400Error() {
        //config required data
        let response = HTTPURLResponse(url: testURL, statusCode: 400, httpVersion: nil, headerFields: nil)
        client.response = response
        client.mockResult = Result<Data, Error>.success(testData)
        
        // act
        var receivedResult: Result<Data, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        webService.call {
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
            guard let webServiceError = error as? WebServiceError else {
                XCTFail("didn't get expected error")
                return
            }
            XCTAssertEqual(webServiceError, WebServiceError.httpRequestStatusError)
        default:
            XCTFail("didn't get expected result")
        }
    }
    
    func testClientSuccessWithValidResponseAnd400PlusLess500Error() {
        //config required data
        let response = HTTPURLResponse(url: testURL, statusCode: 404, httpVersion: nil, headerFields: nil)
        client.response = response
        client.mockResult = Result<Data, Error>.success(testData)
        
        // act
        var receivedResult: Result<Data, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        webService.call {
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
            guard let webServiceError = error as? WebServiceError else {
                XCTFail("didn't get expected error")
                return
            }
            XCTAssertEqual(webServiceError, WebServiceError.httpRequestStatusError)
        default:
            XCTFail("didn't get expected result")
        }
    }
    
    func testClientSuccessWithValidResponseAnd500Error() {
        //config required data
        let response = HTTPURLResponse(url: testURL, statusCode: 500, httpVersion: nil, headerFields: nil)
        client.response = response
        client.mockResult = Result<Data, Error>.success(testData)
        
        // act
        var receivedResult: Result<Data, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        webService.call {
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
            guard let webServiceError = error as? WebServiceError else {
                XCTFail("didn't get expected error")
                return
            }
            XCTAssertEqual(webServiceError, WebServiceError.httpServerStatusError)
        default:
            XCTFail("didn't get expected result")
        }
    }
    
    func testClientSuccessWithValidResponseAnd500PlusLessThan600Error() {
        //config required data
        let response = HTTPURLResponse(url: testURL, statusCode: 501, httpVersion: nil, headerFields: nil)
        client.response = response
        client.mockResult = Result<Data, Error>.success(testData)
        
        // act
        var receivedResult: Result<Data, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        webService.call {
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
            guard let webServiceError = error as? WebServiceError else {
                XCTFail("didn't get expected error")
                return
            }
            XCTAssertEqual(webServiceError, WebServiceError.httpServerStatusError)
        default:
            XCTFail("didn't get expected result")
        }
    }
    
    func testClientSuccessWithValidResponseAnd600Error() {
        //config required data
        let response = HTTPURLResponse(url: testURL, statusCode: 600, httpVersion: nil, headerFields: nil)
        client.response = response
        client.mockResult = Result<Data, Error>.success(testData)
        
        // act
        var receivedResult: Result<Data, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        webService.call {
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
            guard let webServiceError = error as? WebServiceError else {
                XCTFail("didn't get expected error")
                return
            }
            XCTAssertEqual(webServiceError, WebServiceError.httpUnknownError)
        default:
            XCTFail("didn't get expected result")
        }
    }
    
    func testClientSuccessWithValidResponseAnd600PlusError() {
        //config required data
        let response = HTTPURLResponse(url: testURL, statusCode: 601, httpVersion: nil, headerFields: nil)
        client.response = response
        client.mockResult = Result<Data, Error>.success(testData)
        
        // act
        var receivedResult: Result<Data, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        webService.call {
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
            guard let webServiceError = error as? WebServiceError else {
                XCTFail("didn't get expected error")
                return
            }
            XCTAssertEqual(webServiceError, WebServiceError.httpUnknownError)
        default:
            XCTFail("didn't get expected result")
        }
    }
}
