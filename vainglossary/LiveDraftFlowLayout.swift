//
//  LiveDraftFlowLayout.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/23/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

class RecommendedBackgroundView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
}

class LiveDraftFlowLayout: UICollectionViewFlowLayout {

//    override init() {
//        super.init()
//        
//        register(RecommendedBackgroundView.self, forDecorationViewOfKind: recommendedBackgroundKind)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("Storyboards Ugh")
//    }
//    
//    let recommendedBackgroundKind = "RecommendedBackground"
//    var recommendedSectionBackgroundAttributes: UICollectionViewLayoutAttributes?
//    
//    override func prepare() {
//        super.prepare()
//        
//        recommendedSectionBackgroundAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: recommendedBackgroundKind, with: IndexPath(row: 0, section: 0))
//        recommendedSectionBackgroundAttributes?.frame
//        
//        let sectionHeaderAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: 0))
//    }
//    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        var attributes = super.layoutAttributesForElements(in: rect)
//        
//        if let recommendedSectionBackgroundAttributes = recommendedSectionBackgroundAttributes {
//            attributes?.append(recommendedSectionBackgroundAttributes)
//        }
//        
//        return attributes
//    }
//    
//    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return recommendedSectionBackgroundAttributes
//    }
}
