//
//  HeroesViewController.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/8/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit
import CoreData

class HeroesViewController: UITableViewController {
    
    lazy var heroResultsController: NSFetchedResultsController<Character> = {
        return self.database.createCharacterResultsController()
    }()
    
    let database: Database
    init(database: Database) {
        self.database = database
        
        super.init(style: .plain)
        
        self.title = "Heroes"
        self.tabBarItem.image = #imageLiteral(resourceName: "heroes")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = nil
        tableView.backgroundColor = .darkBackground
        
        tableView.separatorColor = .black
        
        tableView.rowHeight = 64.0
        
        tableView.register(HeroTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        try? heroResultsController.performFetch()
    }
    
    //==========================================================================
    // MARK: - UITableViewDataSource
    //==========================================================================
    
    let cellIdentifier = "HeroCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HeroTableViewCell
        
        let character = heroResultsController.object(at: indexPath)
        
        cell.titleLabel.text = character.name
        cell.iconView.image = UIImage(named: character.smallIconName)
        
        return cell
    }
    
    //==========================================================================
    // MARK: - UITableViewDelegate
    //==========================================================================
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = heroResultsController.object(at: indexPath)
        
        let heroViewController = HeroViewController(hero: hero)
        navigationController?.pushViewController(heroViewController, animated: true)
    }
}
