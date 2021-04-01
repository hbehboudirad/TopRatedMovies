//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

protocol WebClientCreatorProtocol  {
    
    /// Create a working instance of webclient
    ///
    /// Create a working instance of webclient that connects to the given url. Also the cache for the instance is nil.
    ///
    /// - Parameters:
    ///      - url: The url that you want to connect into
    ///
    /// - Returns: An instance of the webclient if the give string has a correct URL. If the format is incorrect it will returns nil
    static func makeWebClient(url: String) -> WebClient?
}

class WebClientCreator: WebClientCreatorProtocol {
    
    static func makeWebClient(url: String) -> WebClient? {
        //create required request instance
        guard let urlInstance = URL(string: url) else { return nil }
        
        let request = NSMutableURLRequest(url: urlInstance)
        
        //create webclient instance
        let webClient = WebClient(request: request)
        webClient.setTimeout(timeout: 10.0)
        
        //create required url session instance
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        let session = URLSession(configuration: configuration, delegate: webClient, delegateQueue: nil)
        
        //assigned url-session to web client
        webClient.connection = session
        
        return webClient
    }
}
