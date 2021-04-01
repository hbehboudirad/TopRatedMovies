//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

protocol WebServiceCreatorProtocol  {
    
    /// Create a working instance of webservice
    ///
    /// Create a working instance of webservice that uses given web request for connecting to server.
    ///
    /// - Parameters:
    ///      - webrequest: The request for sending to server
    ///
    /// - Returns: An instance of the webservice. if the given request contains has a valid URL and nil if the format is incorrect
    static func makeWebService(webRequest: WebRequestProtocol) -> WebService?
}

class WebServiceCreator: WebServiceCreatorProtocol {
    static func makeWebService(webRequest: WebRequestProtocol) -> WebService? {
        guard let webClient = WebClientCreator.makeWebClient(url: webRequest.url) else { return nil }
        return CoreWebService(webRequest: webRequest, webClient: webClient)
    }
}
