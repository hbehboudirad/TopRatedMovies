//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation

/// Provides URL for all endpoint of web-services.
enum MoviesURLS: String {
    /// URL for fetching top-rated film list
    case topRated = "https://api.themoviedb.org/3/movie/top_rated"
    /// Base URL for downloading film poster
    case filmPoster = "https://image.tmdb.org/t/p/w500"
}
