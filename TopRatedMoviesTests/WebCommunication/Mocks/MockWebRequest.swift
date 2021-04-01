//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation
@testable import TopRatedMovies

struct MockWebRequest: WebRequestProtocol {
    var mockUrl: String
    var url: String { return mockUrl }
}
