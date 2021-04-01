//
//  Copyright © 2021 HBR. All rights reserved.
//

import XCTest
@testable import TopRatedMovies

class WebServiceCreatorTest: XCTestCase {
    
    func testInitializeWithNotCorrectWebService() {
        // arrange
        let webrequest = MockWebRequest(mockUrl: "worng format")
        
        // act
        let webservice = WebServiceCreator.makeWebService(webRequest: webrequest)
        
        // assert
        
        //1- check instance is nil
        XCTAssertNil(webservice)
    }
    
    func testInitializeWithEmptytURL() {
        // arrange
        let webrequest = MockWebRequest(mockUrl: "")
        
        // act
        let webservice = WebServiceCreator.makeWebService(webRequest: webrequest)

        // assert
        
        //1- check instance is nil
        XCTAssertNil(webservice)
    }
    
    func testInitializeWithCorrecURL() {
        // arrange
        let webrequest = MockWebRequest(mockUrl: "http://test.com")
        
        // act
        let webservice = WebServiceCreator.makeWebService(webRequest: webrequest)

        // assert
        
        //1- check instance is not nil
        XCTAssertNotNil(webservice)
    }
}
