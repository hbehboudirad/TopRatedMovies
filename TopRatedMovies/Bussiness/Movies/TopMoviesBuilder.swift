//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

/// Builds an instance of TopMovies view
struct TopMoviesBuilder {
    static let mainViewControllerId = "MoviesViewControllerID"
    static var mainStoryboard: UIStoryboard { return UIStoryboard(name: "movies", bundle: Bundle.main) }
    
    static func build() -> UIViewController {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: mainViewControllerId)
        
        if let view = viewController as? MoviesViewController {
            let presenter = TopRatedMoviesPresenter()
            let interactor  = TopRatedMoviesInteractor()
            
            view.presenter = presenter
            presenter.interactor = interactor
                        
            return viewController
        }
        return UIViewController()
    }
}
