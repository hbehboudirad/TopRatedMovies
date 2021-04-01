//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation

/// Request protocol that web service uses
///
/// This protocol provides what web service needs to get from the request to create its data and send it to the server.
protocol WebRequestProtocol {
    /// URL that web services use for sending the request to
    var url: String { get }
}

extension WebRequestProtocol {
    func appendAPIKey(url: String, isFirstQueryParam: Bool = true) -> String {
        let apiKeyValue = "e4f9e61f6ffd66639d33d3dde7e3159b"
        return "\(url)\(isFirstQueryParam ? "?" : "&")\(apiKeyValue)"
    }
}


/// Request instance for the Itineraries web endpoints
struct TopRatedMoviesWebRequest: WebRequestProtocol {
    var url: String {
        return appendAPIKey(url: baseURL)
    }
    
    /// Base part of the URL
    ///
    /// Base part includes host and path to the end point
    let baseURL: String
}
