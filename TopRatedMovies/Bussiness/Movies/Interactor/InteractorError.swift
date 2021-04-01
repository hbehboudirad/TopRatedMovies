//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation

/// Errors that interactor may throw
enum InteractorError: Error {
    /// Error when interactor can not parse received data
    case parsingError
}

extension InteractorError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .parsingError:
            return localized("webService.errors.dataProcess")
        }
    }
}
