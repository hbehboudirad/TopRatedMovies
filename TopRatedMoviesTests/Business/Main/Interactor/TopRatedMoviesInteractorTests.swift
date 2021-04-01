//
//  Copyright © 2021 HBR. All rights reserved.
//

import XCTest
@testable import TopRatedMovies

class TopRatedMoviesInteractorTests: XCTestCase {
    var interactor: TopRatedMoviesInteractor!

    var mockServiceLauncher: MockServiceLauncher!

    var mockDeserializeQueue: DispatchQueue!
    var mockNorth = 1.2
    var mockSouth = 3.4
    var mockEast = 4.5
    var mockWest = 5.6

    override func setUp() {
        interactor = TopRatedMoviesInteractor()

        mockServiceLauncher = MockServiceLauncher()
        interactor.webServiceLauncher = mockServiceLauncher
    }
    
    func testRetrive() {
        // act
        let mokPage = 12
        interactor.retrieveDataFromServer(page: mokPage) { _ in }

        // assert ...

        //1- check service launcher called
        XCTAssert(mockServiceLauncher.callWebServiceCalled)

        //3- requested data is correct
        if let request = mockServiceLauncher.webService?.webRequest as? TopRatedMoviesWebRequest {
            XCTAssertEqual(request.baseURL, MoviesURLS.topRated.rawValue)
            XCTAssertEqual(request.page, mokPage)
        } else {
            XCTFail("Request type is not correct")
        }
    }
    
    func testRetriveSucceed() {
        //TODO: Move to local data file
        let sampleJson = """
                                {
                                    "page": 1,
                                    "results": [
                                        {
                                            "adult": false,
                                            "backdrop_path": "/fQq1FWp1rC89xDrRMuyFJdFUdMd.jpg",
                                            "genre_ids": [
                                                10749,
                                                35
                                            ],
                                            "id": 761053,
                                            "original_language": "en",
                                            "original_title": "Gabriel's Inferno Part III",
                                            "overview": "some_mock_overview",
                                            "popularity": 33.05,
                                            "poster_path": "/fYtHxTxlhzD4QWfEbrC1rypysSD.jpg",
                                            "release_date": "2020-11-19",
                                            "title": "some_mock_title",
                                            "video": false,
                                            "vote_average": 8.8,
                                            "vote_count": 739
                                        }
                                    ],
                                    "total_pages": 425,
                                    "total_results": 8488
                                }
                                """
        mockServiceLauncher.mockResult = Result<Data, Error>.success(Data(sampleJson.utf8))
        
        // act
        var receivedResult: Result<TopRatedMovies, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        interactor.retrieveDataFromServer(page: 1) {
            receivedResult = $0
            callingCompletionExpectation.fulfill()
        }

        // wait for expectation
        wait(for: [callingCompletionExpectation], timeout: 0.1)
        
        // assert ...

        //check data received
        XCTAssertNotNil(receivedResult)

        //check correctness of data
        switch receivedResult {
        case .success(let result):
            guard result.movies.count == 1 else {
                XCTFail("data not delivered as expected")
                return
            }
            XCTAssertEqual(result.movies[0].title, "some_mock_title")
            XCTAssertEqual(result.movies[0].overview, "some_mock_overview")
            XCTAssertEqual(result.movies[0].posterPath, "/fYtHxTxlhzD4QWfEbrC1rypysSD.jpg")
        default:
            XCTFail("data not delivered correctly")
        }
    }

    func testRetrieveFailed() {
        mockServiceLauncher.mockResult = Result<Data, Error>.failure(MockError.mockError)
        
        // act
        var receivedResult: Result<TopRatedMovies, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        interactor.retrieveDataFromServer(page: 1) {
            receivedResult = $0
            callingCompletionExpectation.fulfill()
        }

        // wait for expectation
        wait(for: [callingCompletionExpectation], timeout: 0.1)
        
        // assert

        //check correct method called
        XCTAssertNotNil(receivedResult)

        //check correctness of data
        switch receivedResult {
        case .failure(let error):
            guard let error = error as? MockError else {
                XCTFail("data not delivered as expected")
                return
            }
            XCTAssertEqual(error, MockError.mockError)
        default:
            XCTFail("data not delivered correctly")
        }
    }
    
    func testRetrieveSucceedWithInvalidJson() {
        let sampleJson = "{"
        mockServiceLauncher.mockResult = Result<Data, Error>.success(Data(sampleJson.utf8))
        
        // act
        var receivedResult: Result<TopRatedMovies, Error>?
        let callingCompletionExpectation = expectation(description: "callingCompletion")
        interactor.retrieveDataFromServer(page: 1) {
            receivedResult = $0
            callingCompletionExpectation.fulfill()
        }

        // wait for expectation
        wait(for: [callingCompletionExpectation], timeout: 0.1)
        
        // assert

        //check correct method called
        XCTAssertNotNil(receivedResult)

        //check correctness of data
        switch receivedResult {
        case .failure(let error):
            guard let error = error as? InteractorError else {
                XCTFail("data not delivered as expected")
                return
            }
            XCTAssertEqual(error, InteractorError.parsingError)
        default:
            XCTFail("data not delivered correctly")
        }
    }
}
