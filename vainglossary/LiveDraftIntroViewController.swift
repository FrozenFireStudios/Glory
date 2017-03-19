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

        // Do any additional setup after loading the view.
    }
    
    func startDraft() {
        let draft = database.createNewDraft()
        
        // TODO: Present LiveDraftViewController(draft: draft)
    }

}
