//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

/// Presents movie data that top rated movie view requires for each individual movie
struct MovieViewModel {
    init(movie: Movie) {
        self.movie = movie
    }
    
    var title: String { movie.title }
    
    var overview: String { movie.overview }
    
    var posterLogo: URL? {  URL(string: "\(MoviesURLS.filmPoster.rawValue)\(movie.posterPath)")  }
    
    // MARK: - Private
    
    private let movie: Movie
}

