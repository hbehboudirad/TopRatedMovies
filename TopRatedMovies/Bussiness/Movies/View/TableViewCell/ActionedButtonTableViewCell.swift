//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

class ActionedButtonTableViewCell: UITableViewCell {
    static let cellIdentifier = "ActionedButtonCellID"
    
    let actionButton: UIButton = {
        Styles.button($0)
        $0.titleEdgeInsets = .init(top: Spacer.sm, left: Spacer.sm, bottom: Spacer.sm, right: Spacer.sm)
        $0.contentEdgeInsets = .init(top: Spacer.sm, left: Spacer.sm, bottom: Spacer.sm, right: Spacer.sm)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        configureSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, actionTask: @escaping () -> Void) {
        self.actionTask = actionTask
        actionButton.setTitle(title, for: .normal)
    }
    
    // MARK: - Private
    
    func configureSubViews() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

        contentView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacer.md),
            actionButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacer.md),
        ])
    }
    
    @objc private func actionButtonTapped() {
        actionTask?()
    }
    
    private var actionTask: (() -> Void)?
}
