//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

class ActionedButtonTableViewCell: UITableViewCell {
    static let cellIdentifier = "LoadMoreCellID"
    
    let actionButton: UIButton = {
        Styles.button($0)
        $0.setTitle(localized(<#T##key: String##String#>), for: <#T##UIControl.State#>)
        return $0
    }(UIButton())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .surface
        selectionStyle = .none
        configureSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(actionTask: @escaping () -> Void) {
        self.actionTask = actionTask
    }
    
    // MARK: - Private
    
    func configureSubViews() {
        backgroundColor = .clear
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: bottomAnchor, constant: Spacer.md),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacer.md),
            actionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
    
    private var actionTask: (() -> Void)?
}
