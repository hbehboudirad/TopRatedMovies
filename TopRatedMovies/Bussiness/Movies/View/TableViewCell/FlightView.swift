//
//  FlightView.swift
//  SkyscannerCodingChallenge
//
//  Created by Hossein Behboudi Rad on 26/01/2021.
//

import UIKit

class LegView: UIView {
    lazy var airlineIcon: UIImageView = {
        Styles.cornerRadius($0, value: CornerRadius.sm)
        $0.sd_setImage(with: legViewModel.airlineURL, placeholderImage: Icons.placeholder)
        return $0
    }(UIImageView())
    lazy var timesLabel: UILabel = {
        $0.numberOfLines = 1
        Styles.bodyLabel($0)
        $0.textColor = .onSurface
        $0.text = legViewModel.times
        return $0
    }(UILabel())
    lazy var airportsAndAirlineLabel: UILabel = {
        $0.numberOfLines = 1
        Styles.bodyLabel($0)
        $0.textColor = .onSurfaceSupport
        $0.text = legViewModel.airportsAndAirline
        return $0
    }(UILabel())
    lazy var durationLabel: UILabel = {
        $0.numberOfLines = 1
        Styles.subTitleLabel($0)
        $0.textColor = .onSurfaceSupport
        $0.text = legViewModel.duration
        return $0
    }(UILabel())
    lazy var stopsLabel: UILabel = {
        $0.numberOfLines = 1
        Styles.subTitleLabel($0)
        $0.textColor = .onSurface
        $0.text = legViewModel.stop
        return $0
    }(UILabel())
    
    private let legViewModel: LegViewModel
    
    init(legViewModel: LegViewModel) {
        self.legViewModel = legViewModel
        super.init(frame: .zero)
        setupViewsHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewsHierarchy() {
        [airlineIcon, timesLabel, airportsAndAirlineLabel, durationLabel, stopsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate(
            [
                airlineIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
                airlineIcon.trailingAnchor.constraint(equalTo: timesLabel.leadingAnchor, constant: -Spacer.lg),
                airlineIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
                airlineIcon.widthAnchor.constraint(equalToConstant: Sizer.lg),
                airlineIcon.heightAnchor.constraint(equalTo: airlineIcon.widthAnchor),
                
                timesLabel.topAnchor.constraint(equalTo: topAnchor),
                timesLabel.bottomAnchor.constraint(equalTo: airportsAndAirlineLabel.topAnchor, constant: -Spacer.md),
                                
                airportsAndAirlineLabel.leadingAnchor.constraint(equalTo: timesLabel.leadingAnchor),
                airportsAndAirlineLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                stopsLabel.topAnchor.constraint(equalTo: topAnchor),
                stopsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

                durationLabel.trailingAnchor.constraint(equalTo: stopsLabel.trailingAnchor),
                durationLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
        
}
