//
//  Copyright © 2021 HBR. All rights reserved.
//

import XCTest
@testable import TopRatedMovies

class InteractortErrorTests: XCTestCase {
    
    func testLocalizationMessages() {
        XCTAssertEqual(InteractorError.parsingError.localizedDescription, localized("webService.errors.dataProcess"))
    }
}
