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

        view.backgroundColor = UIColor.white
    }
}
