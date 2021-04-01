//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

/// Protocol for WebServiceLauncher responsibilities.
///
/// A web service launcher is responsible for calling the web-service and do the operations that is shared for all web-service calls.
/// Some of these shared operation are  taking care of shared business security status codes like session expire and etc, or logging
/// information on the data base based on results.
///
/// It is also responsible for any logics around calling webservice like configs about the calling webservices as
/// fire and forget or cancelling them and etc.
protocol WebServiceLauncherProtocol: class {
    /// Business web service that must launch
    var webService: WebService? { get set }
    
    /// Calls web service API
    ///
    /// - Parameters:
    ///     - completion: Calls this closure when network call finishes, that delivers a result object
    ///                   with Data for successful case and Error for failure case.
    func callWebService(completion: WebCommunicationCompletionHandler?)
}

/// An implementation of WebServiceLauncherProtocol for general usages.
class WebServiceLauncher: WebServiceLauncherProtocol {
    var webService: WebService?
    
    func callWebService(completion: WebCommunicationCompletionHandler? = nil) {
        self.webService?.call {
            // Web service launcher can do its related operations like session management, success log, error log or any shared
            // business operations like taking care of responses with security alerts here
            
            completion?($0)
        }
    }    
}
