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
        self.tabBarItem.image = #imageLiteral(resourceName: "draft")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        backgroundImageView.image = #imageLiteral(resourceName: "BackgroundC")
        
        view.addSubview(backgroundImageView)
        view.addSubview(backgroundBlurView)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, startButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 64.0
        
        view.addSubview(stackView)
        
        let views: [String:UIView] = [
            "background": backgroundImageView,
            "backgroundBlur": backgroundBlurView,
            "stack": stackView
        ]
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[background]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[background]|", views: views)
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[backgroundBlur]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[backgroundBlur]|", views: views)
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[stack]-(Margin)-|", views: views)
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
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var backgroundBlurView: UIVisualEffectView = {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 48.0, weight: UIFontWeightThin)
        label.textColor = .white
        
        label.text = "Live Draft"
        
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .lightGrayText
        label.numberOfLines = 0
        
        label.text = "Live draft helps you make the best picks while you're drafting. You can use Live draft on a separate iPhone or slideover on the iPad for one device gaming.\n\nAs draft picks are made enter them into the Live Draft and recommendations for the next pick will be updated automatically."
        
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
