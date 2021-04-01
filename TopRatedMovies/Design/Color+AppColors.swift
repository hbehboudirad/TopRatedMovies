//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

/// An extension on UIColor to define some semantic colors for using in the app
///
/// This extension has been defined in order to define colors that is used in the app theme and make it
/// easy to change the theme of the app in future.
extension UIColor {
    
    open class var foundation: UIColor { #colorLiteral(red: 0.9490196078, green: 0.9450980392, blue: 0.9568627451, alpha: 1) }
    open class var onFoundationDefault: UIColor { return .black }

    open class var surface: UIColor { return .white }
    open class var onSurface: UIColor { return .black }
    open class var onSurfaceSupport: UIColor { #colorLiteral(red: 0.5061336756, green: 0.4841683507, blue: 0.5587174296, alpha: 1) }
    open class var onSurfaceMinor: UIColor { #colorLiteral(red: 0.7395054698, green: 0.7281323075, blue: 0.7807304263, alpha: 1) }

    open class var primary: UIColor { #colorLiteral(red: 0, green: 0.8155806065, blue: 0.7469041944, alpha: 1) }
    open class var onPrimary: UIColor { return .white }
    
    open class var accent: UIColor { #colorLiteral(red: 0.225705415, green: 0.4361172318, blue: 0.7520490289, alpha: 1) }
    open class var onAccent: UIColor { return .white }
}
