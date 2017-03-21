//
//  LiveDraftIntroViewController.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/18/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

class LiveDraftIntroViewController: UIViewController {

    let database: Database
    init(database: Database) {
        self.database = database
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Live Draft"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(startButton)
        
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func startDraft() {
        let draft = database.createNewDraft()
        
        let draftViewController = LiveDraftViewController(draft: draft)
        present(draftViewController, animated: true, completion: nil)
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Draft", for: .normal)
        button.addTarget(self, action: #selector(LiveDraftIntroViewController.startDraft), for: .primaryActionTriggered)
        return button
    }()
}
