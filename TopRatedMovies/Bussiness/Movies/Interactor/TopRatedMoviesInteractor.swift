//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

/// Protocol that define functionalities of an interactor that loads the top rated moveis data
///
/// Interactors are responsible to load data from a data storage. it can be database, cache, network or etc.
/// Generally their purpose is to abstract data loading from other aspects of the app.
///
/// From communication perspective generally it is what presenter calls from interactor.
protocol TopRatedMoviesInteracting {

    /// Retrieve data of top rated movies
    ///
    /// - Parameters:
    ///     - page: page number of the data to be loaded
    ///     - completion: a closure that will be called when retrieve operation done. It will pass
    ///                   a result object with a `TopRatedMovies` DTO for success case and Error for failure case
    func retrieveDataFromServer(page: Int, completion: @escaping ((Result<TopRatedMovies, Error>) -> Void))
}

struct TopRatedMoviesInteractor: TopRatedMoviesInteracting {
    
    var webServiceLauncher: WebServiceLauncherProtocol = WebServiceLauncher()
            
    // MARK: - TopRatedMoviesInteracting
    func retrieveDataFromServer(page: Int, completion: @escaping ((Result<TopRatedMovies, Error>) -> Void)) {
        let request = TopRatedMoviesWebRequest(baseURL: MoviesURLS.topRated.rawValue, page: page)
        let webService = WebServiceCreator.makeWebService(webRequest: request)
        
        self.webServiceLauncher.webService = webService
        
        self.webServiceLauncher.callWebService { result in
            switch result {
            case .success(let data):
                self.parse(data, with: completion)
            case .failure(let error):
                self.pass(error, to: completion)
            }
        }
    }
    
    // MARK: - Private
    private func parse(_ jsonData: Data, with completion: @escaping ((Result<TopRatedMovies, Error>) -> Void)) {
        //do data conversion and deserialization on back thread
        DispatchQueue.global().async {
            guard let response = try? JSONDecoder().decode(TopRatedMovies.self, from: jsonData) else {
                self.pass(InteractorError.parsingError, to: completion)
                return
            }
            DispatchQueue.main.async { completion(.success(response)) }
        }
    }
    
    private func pass(_ error: Error, to completion: @escaping ((Result<TopRatedMovies, Error>) -> Void)) {
        DispatchQueue.main.async { completion(.failure(error)) }
    }
}
