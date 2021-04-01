//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation
@testable import TopRatedMovies

class MockInteractor: TopRatedMoviesInteracting {
    
    func retrieveDataFromServer(page: Int, completion: @escaping ((Result<TopRatedMovies, Error>) -> Void)) {
        retrieveMethodCalled = true
        receivedPage = page
        guard let result = mockResult else { return }
        completion(result)
    }
    
    var retrieveMethodCalled: Bool = false
    var receivedPage: Int?
    var mockResult: Result<TopRatedMovies, Error>?
}
