//
//  DraftPicksView.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/25/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

class DraftPicksView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(teamAPicksStack)
        self.addSubview(teamBPicksStack)
        
        let views: [String:UIView] = [
            "teamA": teamAPicksStack,
            "teamB": teamBPicksStack,
        ]
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[teamA]-(>=Padding)-[teamB]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|-(Padding)-[teamA]-(Padding)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|-(Padding)-[teamB]-(Padding)-|", views: views)
        teamAPicksStack.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    //==========================================================================
    // MARK: - Data
    //==========================================================================
    
    var draft: Draft? {
        didSet {
            updateCurrentPicks()
        }
    }
    
    private func updateCurrentPicks() {
        teamAPicksStack.arrangedSubviews.forEach {$0.removeFromSuperview()}
        teamBPicksStack.arrangedSubviews.forEach {$0.removeFromSuperview()}
        
        if let teamABan = draft?.teamABan {
            addCharacterToTeamStack(stackView: teamAPicksStack, banned: true)(teamABan)
        }
        
        if let teamBBan = draft?.teamBBan {
            addCharacterToTeamStack(stackView: teamBPicksStack, banned: true)(teamBBan)
        }
        
        draft?.teamAPicks.forEach(addCharacterToTeamStack(stackView: teamAPicksStack))
        draft?.teamBPicks.forEach(addCharacterToTeamStack(stackView: teamBPicksStack))
    }
    
    private func addCharacterToTeamStack(stackView: UIStackView, banned: Bool = false) -> ((Character) -> Void) {
        let function: (Character) -> Void = { character in
            let imageView = UIImageView(image: UIImage(named: character.smallIconName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            
            imageView.layer.cornerRadius = self.teamAPicksStack.frame.height / 2.0
            
            stackView.addArrangedSubview(imageView)
            
            if banned {
                let banView = UIImageView(image: #imageLiteral(resourceName: "ban"))
                banView.translatesAutoresizingMaskIntoConstraints = false
                imageView.addSubview(banView)
                
                NSLayoutConstraint.activeConstraintsWithFormat("H:|[ban]|", views: ["ban": banView])
                NSLayoutConstraint.activeConstraintsWithFormat("V:|[ban]|", views: ["ban": banView])
            }
        }
        return function
    }

    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    lazy var teamAPicksStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        stackView.axis = .horizontal
        stackView.spacing = CGFloat(FFHalfPadding)
        stackView.semanticContentAttribute = .forceLeftToRight
        return stackView
    }()
    
    lazy var teamBPicksStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        stackView.axis = .horizontal
        stackView.spacing = CGFloat(FFHalfPadding)
        stackView.semanticContentAttribute = .forceRightToLeft
        return stackView
    }()
}
