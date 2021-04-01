//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

/**
Provides some helper methods for UIFont
*/
extension UIFont {
    /// Returns a font with the size on given text style font size and given weight
    ///
    /// - Parameters:
    ///     - style: the text style that desired font should be with same size as that
    ///     - weight: the weight that desired font should use
    static func preferredFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
    }
}
