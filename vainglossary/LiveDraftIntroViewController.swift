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
        
        view.backgroundColor = .background
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, startButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = CGFloat(FFDoubleMargin)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(DoubleMargin)-[stack]-(DoubleMargin)-|", views: ["stack": stackView])
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //==========================================================================
    // MARK: - Draft
    //==========================================================================
    
    func startDraft() {
        let draft = database.createNewDraft()
        
        let draftViewController = LiveDraftViewController(draft: draft)
        present(draftViewController, animated: true, completion: nil)
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.textColor = .lightText
        
        label.text = "Live Draft"
        
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        
        label.text = "We will give you recommendations for draft picks during the draft."
        
        return label
    }()
    
    lazy var startButton: FFBorderButton = {
        let button = FFBorderButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        
        button.setTitle("Start Draft", for: .normal)
        
        button.addTarget(self, action: #selector(LiveDraftIntroViewController.startDraft), for: .primaryActionTriggered)
        
        return button
    }()
}
