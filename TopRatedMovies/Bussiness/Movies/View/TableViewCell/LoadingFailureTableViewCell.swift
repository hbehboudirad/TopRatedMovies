//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

class LoadingFailureTableViewCell: UITableViewCell {
    static let cellIdentifier = "LoadingFailureCellID"
    
    let errorView: ErrorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(ErrorView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        configureSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, message: String, actionTask: @escaping () -> Void) {
        self.actionTask = actionTask
        errorView.actionButton.setTitle(title, for: .normal)
        errorView.updatedMessage(message: message)
        layoutSubviews()
    }
    
    // MARK: - Private
    
    func configureSubViews() {
        errorView.actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

        contentView.addSubview(errorView)

        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacer.md),
            errorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacer.md),
            errorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacer.md),
            errorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacer.md),
        ])
    }
    
    @objc private func actionButtonTapped() {
        actionTask?()
    }
    
    private var actionTask: (() -> Void)?
}
