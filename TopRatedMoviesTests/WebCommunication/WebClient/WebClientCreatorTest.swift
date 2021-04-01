//
//  Copyright © 2021 HBR. All rights reserved.
//

import XCTest
@testable import TopRatedMovies

class WebClientCreatorTest: XCTestCase {
    func testNotCorrectURL() {
        // act
        let webClient = WebClientCreator.makeWebClient(url: "WRONG URL")
                
        // assert
        XCTAssertNil(webClient)
    }
    
    func testEmptyURL() {
        // act
        let webClient = WebClientCreator.makeWebClient(url: "")
                
        // assert
        XCTAssertNil(webClient)
    }
    
    func testCreateSucessfullyWithNilCache() {
        // act
        let webClient = WebClientCreator.makeWebClient(url: "http://test.com")
        
        // assert
        
        //1- check result is not nil
        XCTAssertNotNil(webClient)
        //2- also cache is disabled
        XCTAssertNil(webClient?.connection?.configuration.urlCache)
    }
}
