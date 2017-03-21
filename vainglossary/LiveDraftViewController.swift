//
//  LiveDraftViewController.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/8/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

/*
 
 ________________
 |First Team Ban| // Title gives current step
 |              |
 | x o        x | // Team A/B on each side. Shows ban and current picks.
 |              |
 | [] []  [] [] | // Heros to pick, recommended in their own row
 |              |
 | [] []  [] [] | // Rest of heroes to pick.
 | [] []  [] [] | // Banned/Picked heroes are just not shown.
 | [] []  [] [] |
 | [] []  [] [] |
 | [] []  [] [] |
 |              |
 |______________|
 
 */

class LiveDraftViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let draft: Draft
    init(draft: Draft) {
        self.draft = draft
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Live Draft"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Ban a Hero"
        
        
        
        view.addSubview(backgroundImageView)
        view.addSubview(cancelButton)
        view.addSubview(titleLabel)
        view.addSubview(picksView)
        picksView.addSubview(teamAPicksStack)
        picksView.addSubview(teamBPicksStack)
        view.addSubview(heroesCollection)
        
        let views: [String:UIView] = [
            "background": backgroundImageView,
            "cancel": cancelButton,
            "title": titleLabel,
            "picks": picksView,
            "heroes": heroesCollection,
            "teamA": teamAPicksStack,
            "teamB": teamBPicksStack
        ]
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[background]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[background]|", views: views)
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[teamA]-(>=Padding)-[teamB]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|-(Padding)-[teamA]-(Padding)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|-(Padding)-[teamB]-(Padding)-|", views: views)
        teamAPicksStack.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[cancel]-(Margin)-[title]-(Margin)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[picks]-(Margin)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[heroes]|", views: views)
        
        cancelButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: CGFloat(FFPadding)).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: CGFloat(FFPadding)).isActive = true
        NSLayoutConstraint.activeConstraintsWithFormat("V:[title]-(Margin)-[picks]-(Margin)-[heroes]", views: views)
        heroesCollection.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
    }
    
    //==========================================================================
    // MARK: - Actions
    //==========================================================================
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //==========================================================================
    // MARK: - Draft
    //==========================================================================
    
    func characters(section: Int) -> [Character] {
        if section == 0 {
            return draft.recommendationsForNextPick()
        }
        else {
            return draft.remainingCharacters()
        }
    }
    
    func updateDraft() {
        heroesCollection.reloadData()
        updateTitle()
        updateCurrentPicks()
    }
    
    func updateTitle() {
        if draft.teamABan == nil {
            titleLabel.text = "Team A Ban"
        }
        else if draft.teamBBan == nil {
            titleLabel.text = "Team B Ban"
        }
        else if draft.teamAPick1 == nil {
            titleLabel.text = "Team A Pick"
        }
        else if draft.teamBPick1 == nil {
            titleLabel.text = "Team B Pick"
        }
        else if draft.teamBPick2 == nil {
            titleLabel.text = "Team B Pick"
        }
        else if draft.teamAPick2 == nil {
            titleLabel.text = "Team A Pick"
        }
        else if draft.teamAPick3 == nil {
            titleLabel.text = "Team A Pick"
        }
        else if draft.teamBPick3 == nil {
            titleLabel.text = "Team B Pick"
        }
    }
    
    func updateCurrentPicks() {
        teamAPicksStack.arrangedSubviews.forEach {$0.removeFromSuperview()}
        teamBPicksStack.arrangedSubviews.forEach {$0.removeFromSuperview()}
        
        if let teamABan = draft.teamABan {
            addCharacterToTeamStack(stackView: teamAPicksStack, banned: true)(teamABan)
        }
        
        if let teamBBan = draft.teamBBan {
            addCharacterToTeamStack(stackView: teamBPicksStack, banned: true)(teamBBan)
        }
        
        draft.teamAPicks.forEach(addCharacterToTeamStack(stackView: teamAPicksStack))
        draft.teamBPicks.forEach(addCharacterToTeamStack(stackView: teamBPicksStack))
    }
    
    func addCharacterToTeamStack(stackView: UIStackView, banned: Bool = false) -> ((Character) -> Void) {
        let function: (Character) -> Void = { character in
            let imageView = UIImageView(image: UIImage(named: character.smallIconName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
            
            imageView.layer.cornerRadius = self.teamAPicksStack.frame.height / 2.0
            
            // TODO: Overlay ban (/) symbol
            if banned {
                imageView.layer.borderColor = UIColor.red.cgColor
                imageView.layer.borderWidth = 2.0
            }
            
            stackView.addArrangedSubview(imageView)
        }
        return function
    }
    
    private func downloadHeroIcons() {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let contents = try! FileManager.default.contentsOfDirectory(atPath: documentsPath)
        
        while contents.count <= 34 {
            let character = draft.remainingCharacters().first!
            
            print(documentsPath)
            
            var vaingloryFire = URL(fileURLWithPath: "http://www.vaingloryfire.com/images/wikibase/icon/heroes/")
            vaingloryFire.appendPathComponent(character.name.lowercased() + ".png")
            
            let data = try! Data(contentsOf: vaingloryFire)
            
            try! data.write(to: URL(fileURLWithPath: documentsPath + "/" + character.name.lowercased() + ".png"))
        }
        
    }
    
    //==========================================================================
    // MARK: - UICollectionViewDataSource
    //==========================================================================
    
    let cellReuseIdentifier = "HeroCell"
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // TODO: Section 0 is recommended. Add decorative view to highlight them
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters(section: section).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! HeroCollectionViewCell
        
        let character = characters(section: indexPath.section)[indexPath.row]
        
        cell.imageView.image = UIImage(named: character.largeIconName)
        
        return cell
    }
    
    //==========================================================================
    // MARK: - UICollectionViewDelegate
    //==========================================================================
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters(section: indexPath.section)[indexPath.row]
        draft.setNextCharacter(character)
        
        updateDraft()
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(LiveDraftViewController.cancel), for: .primaryActionTriggered)
        return button
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.lightGray
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        
        return label
    }()
    
    lazy var picksView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        return view
    }()
    
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
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 100, height: 100)
        
        layout.sectionInset = UIEdgeInsets(top: CGFloat(FFMargin), left: 0, bottom: 0, right: 0)
        
        return layout
    }()
    
    lazy var heroesCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .clear
        
        collectionView.bounces = true
        
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: CGFloat(FFMargin), bottom: 0.0, right: CGFloat(FFMargin))
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        return collectionView
    }()
}
