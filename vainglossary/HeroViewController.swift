//
//  HeroViewController.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/8/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

class HeroViewController: UIViewController {
    
    let hero: Character
    init(hero: Character) {
        self.hero = hero
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = hero.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        backgroundImageView.image = UIImage(named: hero.largeIconName)
        
        view.addSubview(backgroundImageView)
        view.addSubview(detailBackgroundView)
        
        let bestAgainst = (try? hero.bestAgainst()) ?? []
        let worstAgainst = (try? hero.bestCounters()) ?? []
        
        let bestAgainstStackView = relatedHeroesStackView(heroes: bestAgainst)
        let worstAgainstStackView = relatedHeroesStackView(heroes: worstAgainst)
        
        let bestAgainstLabel = relatedHeroesLabel(title: "Best Against:")
        let worstAgainstLabel = relatedHeroesLabel(title: "Countered By:")
        
        detailBackgroundView.addSubview(bestAgainstLabel)
        detailBackgroundView.addSubview(bestAgainstStackView)
        detailBackgroundView.addSubview(worstAgainstLabel)
        detailBackgroundView.addSubview(worstAgainstStackView)
        
        let views: [String:UIView] = [
            "background": backgroundImageView,
            "details": detailBackgroundView,
            "bestAgainstLabel": bestAgainstLabel,
            "bestAgainstStack": bestAgainstStackView,
            "worstAgainstLabel": worstAgainstLabel,
            "worstAgainstStack": worstAgainstStackView
        ]
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[background]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[details]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[bestAgainstLabel]-(Margin)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[bestAgainstStack]-(>=Margin)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[worstAgainstLabel]-(Margin)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[worstAgainstStack]-(>=Margin)-|", views: views)
        
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[background]", views: views)
        detailBackgroundView.topAnchor.constraint(greaterThanOrEqualTo: backgroundImageView.bottomAnchor, constant: -128.0).isActive = true
        detailBackgroundView.topAnchor.constraint(greaterThanOrEqualTo: view.centerYAnchor).isActive = true
        detailBackgroundView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        NSLayoutConstraint.activeConstraintsWithFormat("V:|-(Margin)-[bestAgainstLabel]-(Padding)-[bestAgainstStack(==worstAgainstStack)]-(Margin)-[worstAgainstLabel]-(Padding)-[worstAgainstStack(==bestAgainstStack)]-(Margin)-|", views: views)
    }
    
    //==========================================================================
    // MARK: - Actions
    //==========================================================================
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var detailBackgroundView: UIVisualEffectView = {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }()
    
    func relatedHeroesStackView(heroes: [Character]) -> UIStackView {
        let imageViews = heroes.map { (hero) -> UIImageView in
            let imageView = UIImageView(image: UIImage(named: hero.smallIconName))
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            return imageView
        }
        
        let stackView = UIStackView(arrangedSubviews: imageViews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = CGFloat(FFMargin)
        
        return stackView
    }
    
    func relatedHeroesLabel(title: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        
        label.textColor = .lightGrayText
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        
        label.text = title
        
        return label
    }
}
