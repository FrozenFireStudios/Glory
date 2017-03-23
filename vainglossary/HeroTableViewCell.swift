//
//  HeroTableViewCell.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/21/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

class HeroTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .background
        self.contentView.backgroundColor = .background
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .darkBackground
        
        self.contentView.addSubview(iconView)
        self.contentView.addSubview(titleLabel)
        
        let views: [String:UIView] = [
            "image": iconView,
            "title": titleLabel,
        ]
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[image]-(Margin)-[title]-(>=Margin)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|-(HalfPadding)-[image]-(HalfPadding)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[title]|", views: views)
        iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        imageView.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.layer.cornerRadius = 2.0
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.textColor = .lightText
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
}
