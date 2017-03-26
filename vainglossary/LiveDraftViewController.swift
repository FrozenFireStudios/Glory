//
//  LiveDraftViewController.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/8/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

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
        
        view.addSubview(backgroundImageView)
        view.addSubview(backgroundBlurView)
        backgroundBlurView.contentView.addSubview(vibrancyView)
        view.addSubview(doneButton)
        view.addSubview(titleLabel)
        view.addSubview(heroesCollection)
        view.addSubview(finishedView)
        
        vibrancyView.contentView.addSubview(picksBackgroundView)
        view.addSubview(picksView)
        
        let views: [String:UIView] = [
            "background": backgroundImageView,
            "backgroundBlur": backgroundBlurView,
            "vibrancy": vibrancyView,
            "done": doneButton,
            "title": titleLabel,
            "picks": picksView,
            "heroes": heroesCollection,
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
                
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[title]-(Margin)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[done(==68.0)]", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|-(Margin)-[picks]-(Margin)-|", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("H:|[heroes]|", views: views)
        
        titleLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: CGFloat(FFPadding)).isActive = true
        NSLayoutConstraint.activeConstraintsWithFormat("V:|[done(==88.0)]", views: views)
        NSLayoutConstraint.activeConstraintsWithFormat("V:[title]-(Margin)-[picks]-(Margin)-[heroes]", views: views)
        heroesCollection.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        finishedView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        finishedView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDraft()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //==========================================================================
    // MARK: - Actions
    //==========================================================================
    
    func done() {
        dismiss(animated: true, completion: nil)
    }
    
    //==========================================================================
    // MARK: - Draft
    //==========================================================================
    
    func characters(section: Int) -> [Character] {
        if section == 0 {
            return draft.recommendationsForNextPick
        }
        else {
            return draft.remainingCharacters
        }
    }
    
    func updateDraft() {
        heroesCollection.reloadData()
        
        updateTitle()
        
        picksView.draft = draft
        
        if draft.isFinished {
            finishedView.teamAPicks = draft.teamAPicks
            finishedView.teamBPicks = draft.teamBPicks
            
            UIView.animate(withDuration: 0.25, animations: {
                self.titleLabel.alpha = 0.0
                self.doneButton.alpha = 0.0
                self.picksView.alpha = 0.0
                self.picksBackgroundView.alpha = 0.0
                self.heroesCollection.alpha = 0.0
                
                self.finishedView.alpha = 1.0
            })
        }
    }
    
    func updateTitle() {
        if draft.teamABan == nil {
            titleLabel.text = "Team A Ban"
        }
        else if draft.teamBBan == nil {
            titleLabel.text = "Team B Ban"
        }
        else if draft.teamAPick1 == nil {
            titleLabel.text = "Team A 1st Pick"
        }
        else if draft.teamBPick1 == nil {
            titleLabel.text = "Team B 1st Pick"
        }
        else if draft.teamBPick2 == nil {
            titleLabel.text = "Team B 2nd Pick"
        }
        else if draft.teamAPick2 == nil {
            titleLabel.text = "Team A 2nd Pick"
        }
        else if draft.teamAPick3 == nil {
            titleLabel.text = "Team A 3rd Pick"
        }
        else if draft.teamBPick3 == nil {
            titleLabel.text = "Team B 3rd Pick"
        }
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
            return CGSize(width: view.frame.width, height: 36.0)
        }
        
        return .zero
    }
    
    //==========================================================================
    // MARK: - Background
    //==========================================================================
    
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
    
    //==========================================================================
    // MARK: - Header
    //==========================================================================
    
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.addTarget(self, action: #selector(LiveDraftViewController.done), for: .primaryActionTriggered)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 28.0, weight: UIFontWeightThin)
        label.textAlignment = .center
        label.textColor = .lightGrayText
        
        return label
    }()
    
    //==========================================================================
    // MARK: - Current Picks
    //==========================================================================
    
    lazy var picksView: DraftPicksView = {
        let view = DraftPicksView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var picksBackgroundView: UIView = {
        let picksBackgroundView = UIView()
        picksBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        picksBackgroundView.backgroundColor = UIColor(white: 1.0, alpha: 0.25)
       return picksBackgroundView
    }()
    
    //==========================================================================
    // MARK: - CollectionView
    //==========================================================================
    
    lazy var layout: LiveDraftFlowLayout = {
        let layout = LiveDraftFlowLayout()
        
        layout.itemSize = CGSize(width: 100, height: 100)
        
        layout.sectionInset = UIEdgeInsets(top: CGFloat(FFMargin), left: CGFloat(FFMargin), bottom: CGFloat(FFMargin), right: CGFloat(FFMargin))
        
        return layout
    }()
    
    lazy var heroesCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .clear
        
        collectionView.bounces = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: self.cellReuseIdentifier)
        collectionView.register(HeroesCollectionTitleView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UICollectionElementKindSectionHeader)
        
        return collectionView
    }()
    
    //==========================================================================
    // MARK: - Finished View
    //==========================================================================
    
    lazy var finishedView: FinishedDraftView = {
        let view = FinishedDraftView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.alpha = 0.0
        
        view.addTarget(self, action: #selector(LiveDraftViewController.done), for: .primaryActionTriggered)
        
        return view
    }()
}
