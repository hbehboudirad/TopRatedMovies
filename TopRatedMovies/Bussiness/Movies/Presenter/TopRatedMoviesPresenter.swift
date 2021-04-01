//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation
import UIKit

/// Defines functionalities that a presenter must provide for the view of top rated movies screen
///
/// Presenter is responsible for providing data from datastore, collect them  and convert them into
/// a format that view needs and deliver them properly to view
protocol TopRatedMoviesPresenting {
    /// Instance of a interactor that can provide top rated movies
    var interactor: TopRatedMoviesInteracting? { get set }
    
    /// Binds a view to this presenter
    ///
    /// The binding means, the presenter get some methods that needs to be called at some meaningful moments
    /// and returns a list of methods that view can call on some meaningful moment to achieve some goals
    ///
    /// - Parameters:
    ///     - onLoadingStarted: a method that presenter should call when it start loading first page of data
    ///     - onDataLoaded: a method that presenter should call when loading first page of data completed successfully
    ///     - onLoadingFailed: a method that presenter should call when loading first page of data failed
    ///     - onLoadingMoreData: a method that presenter should call when it start loading extra page of data
    ///     - onMoreDataAdded: a method that presenter should call when loading extra page of data completed successfully
    ///     - onLoadingMoreDataFailed: a method that presenter should call when loading extra page of data failed
    ///     - onLoadingAddDataFinished: a method that presenter should call when there is no more page to load
    /// - Returns: a method that view calls when it want to load data (or to load more data)
    func bind(
        onLoadingStarted: @escaping () -> Void,
        onDataLoaded: @escaping ([MovieViewModel]) -> Void,
        onLoadingFailed: @escaping (String) -> Void,
        onLoadingMoreData: @escaping () -> Void,
        onMoreDataAdded: @escaping ([MovieViewModel]) -> Void,
        onLoadingMoreDataFailed:  @escaping (String) -> Void,
        onLoadingAllDataFinished: @escaping () -> Void
    ) -> () -> Void
}

class TopRatedMoviesPresenter: TopRatedMoviesPresenting {
    // dependencies
    var interactor: TopRatedMoviesInteracting?
    
    // Event handlers
    private var onLoadingStarted: (() -> Void)?
    private var onDataLoaded: (([MovieViewModel]) -> Void)?
    private var onLoadingFailed: ((String) -> Void)?
    private var onLoadingMoreData: (() -> Void)?
    private var onMoreDataAdded: (([MovieViewModel]) -> Void)?
    private var onLoadingMoreDataFailed: ((String) -> Void)?
    private var onLoadingAllDataFinished: (() -> Void)?
    
    private var loadingPage: Int = 1
    private var allMovies: [MovieViewModel] = []
    
    // MARK: - Rop Rated Presenting
    
    internal func bind(
        onLoadingStarted: @escaping () -> Void,
        onDataLoaded: @escaping ([MovieViewModel]) -> Void,
        onLoadingFailed: @escaping (String) -> Void,
        onLoadingMoreData: @escaping () -> Void,
        onMoreDataAdded: @escaping ([MovieViewModel]) -> Void,
        onLoadingMoreDataFailed: @escaping (String) -> Void,
        onLoadingAllDataFinished: @escaping () -> Void
    ) -> () -> Void {
        self.onLoadingStarted = onLoadingStarted
        self.onDataLoaded = onDataLoaded
        self.onLoadingFailed = onLoadingFailed
        self.onLoadingMoreData = onLoadingMoreData
        self.onMoreDataAdded = onMoreDataAdded
        self.onLoadingMoreDataFailed = onLoadingMoreDataFailed
        self.onLoadingAllDataFinished = onLoadingAllDataFinished
            
        return loadData
    }
    
    // MARK: - Private
    
    private func loadData() {
        loadingPage == 1 ? onLoadingStarted?() : onLoadingMoreData?()
        
        //ask interactor to load all data
        interactor?.retrieveDataFromServer(page: loadingPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                let movies = result.movies.map { MovieViewModel.init(movie: $0) }
                self.allMovies.append(contentsOf: movies)
                self.loadingPage == 1 ? self.onDataLoaded?(self.allMovies) : self.onMoreDataAdded?(self.allMovies)
                
                // call the listener if all data is loaded
                self.loadingPage += 1
                if self.loadingPage > result.totalPages {
                    self.onLoadingAllDataFinished?()
                }
            case .failure(let error):
                self.loadingPage == 1 ?
                    self.onLoadingFailed?(error.localizedDescription) :
                    self.onLoadingMoreDataFailed?(error.localizedDescription)
            }
        }
    }
}
