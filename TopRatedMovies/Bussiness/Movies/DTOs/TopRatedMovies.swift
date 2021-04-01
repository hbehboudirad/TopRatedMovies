//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation

/// DTO represents Top Rated Movies list
struct TopRatedMovies: Decodable {
    let movies: [Movie]
    
    let totalPages: Int
    
    let pageNumber: Int
    
    /// Describes the keys that server sends for each item
    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case totalPages = "total_pages"
        case pageNumber = "page"
    }
}

/// DTO represents data of a Movie
struct Movie: Decodable, Equatable {
    let title: String
    
    let overview: String
    
    let posterPath: String
    
    /// Describes the keys that server sends for each item
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case posterPath = "poster_path"
    }
}
