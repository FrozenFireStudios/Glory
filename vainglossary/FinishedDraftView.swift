//
//  FinishedDraftView.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/25/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

class FinishedDraftView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(teamAPicksStack)
        self.addSubview(vsLabel)
        self.addSubview(teamBPicksStack)
        self.addSubview(doneButton)
        
        let views: [String:UIView] = [
            "title": titleLabel,
            "teamA": teamAPicksStack,
            "vs": vsLabel,
            "teamB": teamBPicksStack,
            "done": doneButton
        ]
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[title]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[teamA]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[vs]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[teamB]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[done]|", views: views)
        
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[title]-(DoubleMargin)-[teamA(==80.0)]-(Margin)-[vs]-(Margin)-[teamB(==teamA)]-(DoubleMargin)-[done]|", views: views)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    //==========================================================================
    // MARK: - Data
    //==========================================================================
    
    var teamAPicks: [Character] = [] {
        didSet {
            teamAPicksStack.arrangedSubviews.forEach {$0.removeFromSuperview()}
            teamAPicks.forEach(addCharacterToTeamStack(stackView: teamAPicksStack))
        }
    }
    
    var teamBPicks: [Character] = [] {
        didSet {
            teamBPicksStack.arrangedSubviews.forEach {$0.removeFromSuperview()}
            teamBPicks.forEach(addCharacterToTeamStack(stackView: teamBPicksStack))
        }
    }
    
    open func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        doneButton.addTarget(target, action: action, for: controlEvents)
    }
    
    private func addCharacterToTeamStack(stackView: UIStackView, banned: Bool = false) -> ((Character) -> Void) {
        let function: (Character) -> Void = { character in
            let imageView = UIImageView(image: UIImage(named: character.smallIconName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            
            imageView.layer.cornerRadius = self.teamAPicksStack.frame.height / 2.0
            
            stackView.addArrangedSubview(imageView)
        }
        return function
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 40.0, weight: UIFontWeightUltraLight)
        label.textAlignment = .center
        label.textColor = .lightGrayText
        
        label.text = "Good Luck!"
        
        return label
    }()
    
    lazy var vsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightLight)
        label.textAlignment = .center
        label.textColor = .lightGrayText
        
        label.text = "VS"
        
        return label
    }()
    
    lazy var teamAPicksStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        stackView.axis = .horizontal
        stackView.spacing = CGFloat(FFMargin)
        return stackView
    }()
    
    lazy var teamBPicksStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        stackView.axis = .horizontal
        stackView.spacing = CGFloat(FFMargin)
        return stackView
    }()
    
    lazy var doneButton: FFBorderButton = {
        let button = FFBorderButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        
        button.setTitle("Done", for: .normal)
        
        return button
    }()
}
