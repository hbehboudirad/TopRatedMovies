//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation
import UIKit

/// Define functionalities that a presenter must provide for a view of itineraries screen
///
/// Presenter is responsible for providing data from datastore, collect them  and convert them into
/// a format that view needs and deliver them properly to view
protocol ItinerariesPresentering {
    /// Instance of a interactor that can provide itineraries
    var interactor: ItinerariesInteracting? { get set }
    
    /// Binds a view to this presenter
    ///
    /// The binding means, the presenter get some methods that needs to be called at some meaningful moments
    /// and returns a list of methods that view can call on some meaningful moment to get achieve some goals
    ///
    /// - Parameters:
    ///     - onLoadingStarted: a method that presenter should call when it start loading new data
    ///     - onDataLoaded: a method that presenter should call when loading of data completed successfully
    ///     - onLoadingFailed: a method that presenter should call when loading data failed
    /// - Returns:
    ///     - onDataRequired: a method that view can when it requires a new and fresh data
    ///     - onItemSelected: a method that view can call when user selects an item and want to see it's detail
    func bind(
        onLoadingStarted: @escaping () -> Void,
        onDataLoaded: @escaping ([ItinerariesViewModel]) -> Void,
        onLoadingFailed: @escaping (String) -> Void,
        onLoadingMoreData: @escaping () -> Void,
        onMoreDataAdded: @escaping ([ItinerariesViewModel]) -> Void,
        onLoadingMoreDataFailed:  @escaping (String) -> Void
    ) -> () -> Void
}

class TopRatedMoviesPresenter: ItinerariesPresentering {
    // dependencies
    var interactor: ItinerariesInteracting?
    
    // Event handlers
    private var onLoadingStarted: (() -> Void)?
    private var onDataLoaded: (([ItinerariesViewModel]) -> Void)?
    private var onLoadingFailed: ((String) -> Void)?
    private var onLoadingMoreData: (() -> Void)?
    private var onMoreDataAdded: (([ItinerariesViewModel]) -> Void)?
    private var onLoadingMoreDataFailed: ((String) -> Void)?
    
    // MARK: - Weather Presenter
    
    func bind(
        onLoadingStarted: @escaping () -> Void,
        onDataLoaded: @escaping ([ItinerariesViewModel]) -> Void,
        onLoadingFailed: @escaping (String) -> Void,
        onLoadingMoreData: @escaping () -> Void,
        onMoreDataAdded: @escaping ([ItinerariesViewModel]) -> Void,
        onLoadingMoreDataFailed:  @escaping (String) -> Void
    ) -> () -> Void {
        self.onLoadingStarted = onLoadingStarted
        self.onDataLoaded = onDataLoaded
        self.onLoadingFailed = onLoadingFailed
        self.onLoadingMoreData = onLoadingMoreData
        self.onMoreDataAdded = onMoreDataAdded
        self.onLoadingMoreDataFailed = onLoadingMoreDataFailed
            
        return loadData
    }
    
    // MARK: - Private
    
    private func loadData() {
        onLoadingStarted?()
        
        //ask interactor to load all data
        interactor?.retrieveDataFromServer() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                let itineraries = result.itineraries.map { itinerary -> ItinerariesViewModel in
                    let legs = itinerary.legs.flatMap { leg in result.legs.filter { $0.id == leg } }
                    return ItinerariesViewModel(itinerary: itinerary, legs: legs)
                }
                self.onDataLoaded?(itineraries)
            case .failure(let error):
                self.onLoadingFailed?(error.localizedDescription)
            }
        }
    }
}
