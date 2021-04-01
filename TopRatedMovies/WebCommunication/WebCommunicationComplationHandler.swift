//
//  Created by Hossein Behboudi Rad on 18/08/2020.
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation

/// A type-alias for a closure that is used by several components in the WebCommunication layer
typealias WebCommunicationCompletionHandler = (Result<Data, Error>) -> Void
