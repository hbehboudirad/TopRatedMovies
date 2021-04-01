//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation
@testable import TopRatedMovies

class MockURLSession: URLSession {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    var dataTaskCalled = false
    var receivedRequest: URLRequest?
    var task = MockURLSessionTask()
    
    override func dataTask(with request: URLRequest) -> URLSessionDataTask {
        dataTaskCalled = true
        receivedRequest = request
        return task
    }
}

class MockURLSessionTask: URLSessionDataTask {
    override func resume() {
        //Do nothing. I override this method only because of decoupling MockUrlSession from real network
    }
}
