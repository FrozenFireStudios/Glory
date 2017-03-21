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
        
        backgroundImageView.image = UIImage(named: hero.largeIconName)
        
        view.addSubview(backgroundImageView)
        
        let views: [String:UIView] = [
            "background": backgroundImageView
        ]
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[background]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[background]|", views: views)
    }
    
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
    
}
