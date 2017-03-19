//
//  HeroCollectionViewCell.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/18/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

class HeroCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.lightGray
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        
        let views: [String:UIView] = [
            "image": imageView,
            "title": titleLabel,
        ]
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[image]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[image]|", views: views)
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[title]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:[title]|", views: views)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.lightGray
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        
        return label
    }()
}
