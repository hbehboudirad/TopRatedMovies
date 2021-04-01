//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

extension UIButton {
    open override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize

        return .init(width: superSize.width + titleEdgeInsets.right + titleEdgeInsets.left ,
                     height: superSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
    }
}
