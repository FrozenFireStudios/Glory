//
//  HeroesViewController.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/8/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit
import CoreData

class HeroesViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var heroResultsController: NSFetchedResultsController<Character> = {
        let frc = self.database.createCharacterResultsController()
        frc.delegate = self
        return frc
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
        
        loadingIndicator.startAnimating()
        
        view.addSubview(loadingIndicator)
        
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
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
    
    //==========================================================================
    // MARK: - NSFetchedResultsControllerDelegate
    //==========================================================================
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        loadingIndicator.stopAnimating()
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
}
