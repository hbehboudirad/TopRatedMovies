//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

class ProgressIndicatorTableViewCell: UITableViewCell {
    static let cellIdentifier = "ProgressIndicatorCellID"
    
    private let activityIndicator: UIActivityIndicatorView = {
        $0.color = .onFoundationDefault
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIActivityIndicatorView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .foundation
        configureSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicator.startAnimating()
    }
    
    // MARK: - Private
    
    func configureSubViews() {
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacer.md),
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacer.md),
        ])
    }
}
