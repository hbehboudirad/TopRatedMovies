//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit
import SDWebImage

class MoviesTableViewCell: UITableViewCell {
    static let cellIdentifier = "ItineraryCellID"
   
    private let informationStackView: UIStackView = {
        $0.clipsToBounds = true
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = Spacer.xlg
        return $0
    }(UIStackView())
    private let posterImageView = UIImageView()
    private let titleLabel: UILabel = {
        Styles.bodyLabel($0)
        $0.textColor = .onSurface
        return $0
    }(UILabel())
    private let overviewLabel: UILabel = {
        Styles.subTitleLabel($0)
        $0.textColor = .onSurfaceSupport
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .surface
        selectionStyle = .none
        configureSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(movie: MoviesViewModel) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
        posterImageView.sd_setImage(with: movie.posterLogo, placeholderImage: Icons.placeholder)

        layoutSubviews()
    }
    
    // MARK: - Private
    
    func configureSubViews() {
        backgroundColor = .clear
        [informationStackView, posterImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacer.md),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacer.md),
            posterImageView.widthAnchor.constraint(equalToConstant: 85),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),

            informationStackView.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: Spacer.md),
            informationStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: Spacer.md),
            informationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacer.md),
            informationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacer.md)
        ])
    }
}
