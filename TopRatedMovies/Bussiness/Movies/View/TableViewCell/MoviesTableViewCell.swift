//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit
import SDWebImage

class MoviesTableViewCell: UITableViewCell {
    static let cellIdentifier = "MovieCellID"
   
    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, overviewLabel])
        stackView.clipsToBounds = true
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Spacer.md
        return stackView
    }()
    private lazy var titleLabel: UILabel = {
        Styles.bodyLabel($0)
        $0.textColor = .onSurface
        return $0
    }(UILabel())
    private lazy var overviewLabel: UILabel = {
        Styles.subTitleLabel($0)
        $0.textColor = .onSurfaceSupport
        return $0
    }(UILabel())
    private let posterImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .surface
        selectionStyle = .none
        configureSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(movie: MovieViewModel) {
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
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacer.lg),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacer.md),
            posterImageView.widthAnchor.constraint(equalToConstant: 85),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Spacer.lg),

            informationStackView.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: Spacer.md),
            informationStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: Spacer.md),
            informationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacer.md),
            informationStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Spacer.lg)
        ])
    }
}
