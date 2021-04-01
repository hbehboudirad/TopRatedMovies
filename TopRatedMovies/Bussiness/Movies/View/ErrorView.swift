//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    
    let messageLabel: UILabel = {
        Styles.bodyLabel($0)
        $0.textColor = .onPrimary
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(UILabel())
    let actionButton: UIButton = {
        Styles.button($0)
        return $0
    }(UIButton())
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubViews()
    }
    
    func updatedMessage(message: String) {
        messageLabel.text = message
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    // MARK: - Private
    
    private func configureSubViews() {
        //styling
        Styles.container(self)
        backgroundColor = .primary
        
        [messageLabel, actionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacer.md),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacer.md),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1 * Spacer.md),
            messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Spacer.xlg),
            
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: Spacer.lg),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1 * Spacer.md),
            actionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
}
