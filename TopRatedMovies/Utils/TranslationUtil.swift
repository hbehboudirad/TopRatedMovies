//
//  Copyright © 2021 HBR. All rights reserved.
//

import Foundation

/// A wrapper above NSLocalizedString with empty string as comment
///
/// This is a shorter and simply usable wrapper method over NSLocalizedString for translating
/// keywords in the app.
///
/// - Parameters:
///    - key: The keyword that looking for its localized value
///
/// - Returns: localized value of the keyword
func localized(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
