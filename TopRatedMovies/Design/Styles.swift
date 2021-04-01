//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

/// Defines some stylings that is used for different elements in the app
///
/// This struct has been defined in order to define style that is used in the app theme and make it
/// easy to change the theme of the app in future.
struct Styles {
    
    // MARK: - Navigation Bar
       
    static func navigationBar(_ navigationBar: UINavigationBar) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.onFoundationDefault]
        navigationBar.largeTitleTextAttributes = textAttributes
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.barTintColor = UIColor.foundation
        navigationBar.backgroundColor = UIColor.foundation
        navigationBar.tintColor = UIColor.onFoundationDefault
        Styles.shadow(navigationBar)
    }
    
    // MARK: - Views
    
    static func container(_ view: UIView) {
        cornerRadius(view)
    }
    
    // MARK: - Button
    
    static func button(_ button: UIButton) {
        button.backgroundColor = .accent
        button.setTitleColor(.onAccent, for: .normal)
        cornerRadius(button)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.contentEdgeInsets = .init(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    // MARK: - Labels
    
    static func titleLabel(_ label: UILabel) {
        label.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
    }
    
    static func bodyLabel(_ label: UILabel, important: Bool = false) {
        label.font = UIFont.preferredFont(forTextStyle: .body, weight: important ? .bold : .regular)
    }
    
    static func subTitleLabel(_ label: UILabel) {
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
    }
}

extension Styles {
    static func cornerRadius(_ view: UIView, value: CGFloat = CornerRadius.md) {
        view.layer.cornerRadius = value
        view.layer.masksToBounds = true
    }
    
    static func shadow(_ view: UIView, value: CGFloat = CornerRadius.md) {
        view.layer.shadowOffset = .init(width: 0, height: 2)
        view.layer.shadowOpacity = 0.2
        view.layer.cornerRadius = 2
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
    }
}

