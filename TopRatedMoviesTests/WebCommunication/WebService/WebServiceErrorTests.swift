//
//  Copyright © 2021 HBR. All rights reserved.
//

import XCTest
@testable import TopRatedMovies

class WebServiceErrorTests: XCTestCase {
    
    func testLocalizationMessages() {
        XCTAssertEqual(WebServiceError.emptyData.localizedDescription, localized("webService.errors.noData"))
        XCTAssertEqual(WebServiceError.httpRequestStatusError.localizedDescription, localized("webService.errors.httpRequest"))
        XCTAssertEqual(WebServiceError.httpServerStatusError.localizedDescription, localized("webService.errors.httpServer"))
        XCTAssertEqual(WebServiceError.httpUnknownError.localizedDescription, localized("webService.errors.httpUnknown"))
    }
}
