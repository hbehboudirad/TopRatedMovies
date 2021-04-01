//
//  Copyright © 2021 HBR. All rights reserved.
//

import XCTest
@testable import TopRatedMovies

class TopRatedMoviesPresenterTests: XCTestCase {

    var presenter: TopRatedMoviesPresenter!
    var mockInteractor: MockInteractor!
    
    let movie0 = Movie(title: "title1", overview: "overview1", posterPath: "/path1")
    let movie1 = Movie(title: "title2", overview: "overview2", posterPath: "/path2")
    lazy var topRatedMoviesPage1 = TopRatedMovies(movies: [movie0, movie1], totalPages: 3, pageNumber: 1)
    
    override func setUp() {
        presenter = TopRatedMoviesPresenter()
        mockInteractor = MockInteractor()

        presenter.interactor = mockInteractor
    }
    
    func testLoadData() {
        // arrange
        var loadingStartedCalled = false
        let onLoadingStarted: () -> Void = {
            loadingStartedCalled = true
        }
        let output = presenter.bind(onLoadingStarted: onLoadingStarted,
                                    onDataLoaded: { _ in },
                                    onLoadingFailed: { _ in },
                                    onLoadingMoreData: {  },
                                    onMoreDataAdded: { _ in },
                                    onLoadingMoreDataFailed: { _ in },
                                    onLoadingAllDataFinished: { })
        
        // act
        output()

        // assert ...

        //1- called interactor?
        XCTAssertTrue(mockInteractor.retrieveMethodCalled)

        //2- called loading started?
        XCTAssertTrue(loadingStartedCalled)
    }

    func testRetrieveDataSuccessfully() {
        // arrange
        mockInteractor.mockResult = Result.success(topRatedMoviesPage1)
        
        var onLoadingCalled = false
        var receivedData: [MovieViewModel]?
        var loadingFailedCalled = false
        var onLoadingMoreDataCalled = false
        var receivedMoreData: [MovieViewModel]?
        var onLoadingMoreDataFailed = false
        var onLoadingDataFinished = false

        let output = presenter.bind(onLoadingStarted: { onLoadingCalled = true },
                                    onDataLoaded: { receivedData = $0 },
                                    onLoadingFailed: { _ in loadingFailedCalled = true },
                                    onLoadingMoreData: { onLoadingMoreDataCalled = true },
                                    onMoreDataAdded: { receivedMoreData = $0 },
                                    onLoadingMoreDataFailed: { _ in onLoadingMoreDataFailed = false },
                                    onLoadingAllDataFinished: { onLoadingDataFinished = true })
        
        //MARK: - Loading first page
        
        // act for first page
        output()
        
        // assert for first page
        
        XCTAssertTrue(onLoadingCalled)
        
        guard let firstPageData = receivedData, firstPageData.count == 2 else {
            XCTFail("didn't receive expected data")
            return
        }
        XCTAssertEqual(firstPageData[0].title, movie0.title)
        XCTAssertEqual(firstPageData[0].overview, movie0.overview)
        XCTAssertEqual(firstPageData[0].posterLogo?.lastPathComponent, "\(movie0.posterPath)".replacingOccurrences(of: "/", with: ""))
                
        XCTAssertEqual(firstPageData[1].title, movie1.title)
        XCTAssertEqual(firstPageData[1].overview, movie1.overview)
        XCTAssertEqual(firstPageData[1].posterLogo?.lastPathComponent, "\(movie1.posterPath)".replacingOccurrences(of: "/", with: ""))
        
        XCTAssertFalse(loadingFailedCalled)
        XCTAssertFalse(onLoadingMoreDataCalled)
        XCTAssertFalse(onLoadingMoreDataFailed)
        XCTAssertFalse(onLoadingDataFinished)
        XCTAssertNil(receivedMoreData)

        // MARK: - Loading pages between 1-last
        
        // arrange for second page
        let topRatedMoviesPage2 = TopRatedMovies(movies: [movie0, movie1], totalPages: 3, pageNumber: 2)
        mockInteractor.mockResult = Result.success(topRatedMoviesPage2)
        onLoadingCalled = false
        receivedData = nil
        
        // call for second-page
        output()
        
        XCTAssertTrue(onLoadingMoreDataCalled)
        XCTAssertEqual(receivedMoreData?.count, 4)
        XCTAssertFalse(onLoadingCalled)
        XCTAssertFalse(loadingFailedCalled)
        XCTAssertFalse(onLoadingMoreDataFailed)
        XCTAssertFalse(onLoadingDataFinished)
        XCTAssertNil(receivedData)
        
        // MARK: - Loading last page
        
        // arrange for last page
        let topRatedMoviesPage3 = TopRatedMovies(movies: [movie0, movie1], totalPages: 3, pageNumber: 3)
        mockInteractor.mockResult = Result.success(topRatedMoviesPage3)
        onLoadingMoreDataCalled = false
        receivedMoreData = nil
        
        // call for last page
        output()
        
        XCTAssertTrue(onLoadingMoreDataCalled)
        XCTAssertTrue(onLoadingDataFinished)
        XCTAssertEqual(receivedMoreData?.count, 6)
        XCTAssertFalse(onLoadingCalled)
        XCTAssertFalse(loadingFailedCalled)
        XCTAssertNil(receivedData)
    }
    
    func testRetrieveFailedOnFirstPage() {
        // arrange
        mockInteractor.mockResult = Result.failure(MockError.mockError)
        var onLoadingCalled = false
        var receivedData: [MovieViewModel]?
        var receivedLoadingErrorMessage: String?
        var onLoadingMoreDataCalled = false
        var receivedMoreData: [MovieViewModel]?
        var receivedMoreErrorMessage: String?
        var onLoadingDataFinishedCalled = false
        
        let output = presenter.bind(onLoadingStarted: { onLoadingCalled = true },
                                    onDataLoaded: { receivedData = $0 },
                                    onLoadingFailed: { receivedLoadingErrorMessage = $0 },
                                    onLoadingMoreData: { onLoadingMoreDataCalled = true },
                                    onMoreDataAdded: { receivedMoreData = $0 },
                                    onLoadingMoreDataFailed: { receivedMoreErrorMessage = $0 },
                                    onLoadingAllDataFinished: { onLoadingDataFinishedCalled = true })
        
        // act
        output()
        
        // assert ...
        XCTAssertTrue(onLoadingCalled)
        XCTAssertEqual(receivedLoadingErrorMessage, MockError.mockError.localizedDescription)
        XCTAssertNil(receivedData)
        XCTAssertNil(receivedMoreData)
        XCTAssertNil(receivedMoreErrorMessage)
        XCTAssertFalse(onLoadingMoreDataCalled)
        XCTAssertFalse(onLoadingDataFinishedCalled)
    }
    
    func testRetrieveFailedAfterFirstPage() {
        // arrange
        var onLoadingCalled = false
        var receivedData: [MovieViewModel]?
        var receivedLoadingErrorMessage: String?
        var onLoadingMoreDataCalled = false
        var receivedMoreData: [MovieViewModel]?
        var receivedMoreErrorMessage: String?
        var onLoadingDataFinishedCalled = false
        
        // 1- load first page
        mockInteractor.mockResult = Result.success(topRatedMoviesPage1)
        let output = presenter.bind(onLoadingStarted: { onLoadingCalled = true },
                                    onDataLoaded: { receivedData = $0 },
                                    onLoadingFailed: { receivedLoadingErrorMessage = $0 },
                                    onLoadingMoreData: { onLoadingMoreDataCalled = true },
                                    onMoreDataAdded: { receivedMoreData = $0 },
                                    onLoadingMoreDataFailed: { receivedMoreErrorMessage = $0 },
                                    onLoadingAllDataFinished: { onLoadingDataFinishedCalled = true })
        output()
        
        //2- arrange for second page
        receivedData = nil
        onLoadingCalled = false
        mockInteractor.mockResult = Result.failure(MockError.mockError)
        
        // act on loading second page
        output()
        
        // assert ...
        XCTAssertTrue(onLoadingMoreDataCalled)
        XCTAssertEqual(receivedMoreErrorMessage, MockError.mockError.localizedDescription)
        XCTAssertNil(receivedData)
        XCTAssertNil(receivedMoreData)
        XCTAssertNil(receivedLoadingErrorMessage)
        XCTAssertFalse(onLoadingCalled)
        XCTAssertFalse(onLoadingDataFinishedCalled)
    }
}
