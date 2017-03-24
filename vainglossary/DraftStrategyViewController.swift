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
        
        self.title = "Draft Strategy"
        self.tabBarItem.image = #imageLiteral(resourceName: "strategy")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        backgroundImageView.image = #imageLiteral(resourceName: "BackgroundB")
        
        if let path = Bundle.main.path(forResource: "strategy", ofType: "txt") {
            let strategyText = try? String(contentsOfFile: path)
            textView.text = strategyText ?? "Failed to load strategy"
        }
        
        view.addSubview(backgroundImageView)
        view.addSubview(backgroundBlurView)
        view.addSubview(textView)
        
        let views: [String:UIView] = [
            "background": backgroundImageView,
            "backgroundBlur": backgroundBlurView,
            "text": textView
        ]
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[background]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[background]|", views: views)
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[backgroundBlur]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[backgroundBlur]|", views: views)
        
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
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var backgroundBlurView: UIVisualEffectView = {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .lightGrayText
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        return textView
    }()
}
