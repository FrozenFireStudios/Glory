//
//  HeroesCollectionTitleView.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/23/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

class HeroesCollectionTitleView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        
        let views: [String:UIView] = ["title": titleLabel]
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[title]-(Margin)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|-(Padding)-[title]", views: views)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium)
        label.textColor = .lightGrayText
        
        return label
    }()
}
