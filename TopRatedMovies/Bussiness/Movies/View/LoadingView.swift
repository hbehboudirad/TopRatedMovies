//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

class LoadingView: UIView {
       
    let messageLabel: UILabel = {
        Styles.titleLabel($0)
        $0.textColor = .onPrimary
        $0.textAlignment = .center
        Styles.subTitleLabel($0)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(UILabel())
    private let activityIndicator: UIActivityIndicatorView = {
        $0.color = .onPrimary
        $0.startAnimating()
        return $0
    }(UIActivityIndicatorView())
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //styling
        backgroundColor = .primary
        
        //subviews
        configureSubViews()
    }
    
    // MARK: - Private
    
    private func configureSubViews() {
        [messageLabel, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        Styles.container(self)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacer.md),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1 * Spacer.md),
            messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Spacer.xlg),
            
            activityIndicator.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: Spacer.md),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1 * Spacer.md)
        ])
    }
}
