//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

/// Errors that WebService may throw
enum WebServiceError: Error {
    /// Error when web client is successful but data length is 0.
    case emptyData
        
    /// Error when http status code is between 400 - 500
    case httpRequestStatusError
    
    /// Error when http status code is between 500 - 600
    case httpServerStatusError
    
    /// Error when http status code is some thing not in range 400-600
    case httpUnknownError
}

extension WebServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyData:
            return localized("webService.errors.noData")
        case .httpRequestStatusError:
            return localized("webService.errors.httpRequest")
        case .httpServerStatusError:
            return localized("webService.errors.httpServer")
        case .httpUnknownError:
            return localized("webService.errors.httpUnknown")
        }
    }
}
