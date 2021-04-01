//
//  Copyright © 2021 HBR. All rights reserved.
//

import XCTest
@testable import TopRatedMovies

class WebClientErrorTests: XCTestCase {
    
    func testLocalizationMessages() {
        XCTAssertEqual(WebClientError.callingRequestError.localizedDescription, localized("webService.errors.call"))
        XCTAssertEqual(WebClientError.parsingResponseError.localizedDescription, localized("webService.errors.parse"))
    }
}
