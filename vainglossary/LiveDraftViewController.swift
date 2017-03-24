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

class LiveDraftViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let draft: Draft
    init(draft: Draft) {
        self.draft = draft
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Live Draft"
        
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Ban a Hero"
        
        view.addSubview(backgroundImageView)
        view.addSubview(backgroundBlurView)
        backgroundBlurView.contentView.addSubview(vibrancyView)
        view.addSubview(cancelButton)
        view.addSubview(titleLabel)
        view.addSubview(picksView)
        picksView.addSubview(teamAPicksStack)
        picksView.addSubview(teamBPicksStack)
        view.addSubview(heroesCollection)
        
        let picksBackgroundView = UIView()
        picksBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        picksBackgroundView.backgroundColor = UIColor(white: 1.0, alpha: 0.25)
        vibrancyView.contentView.addSubview(picksBackgroundView)
        
        let views: [String:UIView] = [
            "background": backgroundImageView,
            "backgroundBlur": backgroundBlurView,
            "vibrancy": vibrancyView,
            "cancel": cancelButton,
            "title": titleLabel,
            "picks": picksView,
            "heroes": heroesCollection,
            "teamA": teamAPicksStack,
            "teamB": teamBPicksStack
        ]
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[background]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[background]|", views: views)
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[backgroundBlur]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[backgroundBlur]|", views: views)
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[vibrancy]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[vibrancy]|", views: views)
        
        picksBackgroundView.topAnchor.constraint(equalTo: picksView.topAnchor).isActive = true
        picksBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        picksBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        picksBackgroundView.bottomAnchor.constraint(equalTo: picksView.bottomAnchor).isActive = true
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[teamA]-(>=Padding)-[teamB]|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|-(Padding)-[teamA]-(Padding)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:|-(Padding)-[teamB]-(Padding)-|", views: views)
        teamAPicksStack.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[title]-(Margin)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[cancel(==68.0)]", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[picks]-(Margin)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[heroes]|", views: views)
        
        titleLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: CGFloat(FFPadding)).isActive = true
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[cancel(==88.0)]", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:[title]-(Margin)-[picks]-(Margin)-[heroes]", views: views)
        heroesCollection.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
            return draft.remainingCharacters
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
    
    private func downloadHeroIcons() {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let contents = try! FileManager.default.contentsOfDirectory(atPath: documentsPath)
        
        while contents.count <= 34 {
            let character = draft.remainingCharacters.first!
            
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionElementKindSectionHeader, for: indexPath) as! HeroesCollectionTitleView
        view.titleLabel.text = "Recommended"
        return view
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
    // MARK: - UICollectionViewDelegateFlowLayout
    //==========================================================================
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.width, height: 32.0)
        }
        
        return .zero
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.addTarget(self, action: #selector(LiveDraftViewController.cancel), for: .primaryActionTriggered)
        return button
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let blurEffect = UIBlurEffect(style: .dark)
    lazy var backgroundBlurView: UIVisualEffectView = {
        let effectView = UIVisualEffectView(effect: self.blurEffect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }()
    
    lazy var vibrancyView: UIVisualEffectView = {
        let effectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: self.blurEffect))
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 28.0, weight: UIFontWeightThin)
        label.textAlignment = .center
        label.textColor = .lightGrayText
        
        return label
    }()
    
    lazy var picksView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    lazy var layout: LiveDraftFlowLayout = {
        let layout = LiveDraftFlowLayout()
        
        layout.itemSize = CGSize(width: 100, height: 100)
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(FFDoubleMargin), right: 0)
        
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
        collectionView.register(HeroesCollectionTitleView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UICollectionElementKindSectionHeader)
        
        return collectionView
    }()
}
