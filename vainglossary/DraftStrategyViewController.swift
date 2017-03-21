//
//  DraftStrategyViewController.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/8/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

class DraftStrategyViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        title = "Draft Strategy"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        if let path = Bundle.main.path(forResource: "strategy", ofType: "txt") {
            let strategyText = try? String(contentsOfFile: path)
            textView.text = strategyText ?? "Failed to load strategy"
        }
        
        view.addSubview(backgroundImageView)
        view.addSubview(textView)
        
        let views: [String:UIView] = [
            "background": backgroundImageView,
            "text": textView
        ]
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[background]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[background]|", views: views)
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[text]|", views: views)
        textView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        NSLayoutConstraint.activeConstraintsWithFormat("V:[text]|", views: views)
        
        textView.contentInset = UIEdgeInsetsMake(CGFloat(FFPadding), 0, 0, 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .lightText
        return textView
    }()
}
