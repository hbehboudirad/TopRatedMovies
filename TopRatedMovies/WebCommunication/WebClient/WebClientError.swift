//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation

/// Error that a web client may throw
enum WebClientError: Error {
    ///Error on calling the server. Maybe connection error or other http errors.
    case callingRequestError
    
    ///Error on parsing the response to the http response or nil data on response data
    case parsingResponseError
}

extension WebClientError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .callingRequestError:
            return localized("webService.errors.call")
        case .parsingResponseError:
            return localized("webService.errors.parse")
        }
    }
}
