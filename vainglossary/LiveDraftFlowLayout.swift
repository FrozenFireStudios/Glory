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
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
}

class LiveDraftFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        
        register(RecommendedBackgroundView.self, forDecorationViewOfKind: recommendedBackgroundKind)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    let recommendedBackgroundKind = "RecommendedBackground"
    var recommendedSectionBackgroundAttributes: UICollectionViewLayoutAttributes?
    
    override func prepare() {
        super.prepare()
        
        guard
            let firstSectionHeaderAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: 0)),
            let secondSectionHeaderAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: 1))
            else {
                return
        }
        
        let x = firstSectionHeaderAttributes.frame.minX
        let y = firstSectionHeaderAttributes.frame.minY
        let width = firstSectionHeaderAttributes.frame.width
        let height = secondSectionHeaderAttributes.frame.minY - firstSectionHeaderAttributes.frame.minY
        
        recommendedSectionBackgroundAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: recommendedBackgroundKind, with: IndexPath(row: 0, section: 0))
        recommendedSectionBackgroundAttributes?.frame = CGRect(x: x, y: y, width: width, height: height)
        recommendedSectionBackgroundAttributes?.zIndex = -1000
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = super.layoutAttributesForElements(in: rect)
        
        if let recommendedSectionBackgroundAttributes = recommendedSectionBackgroundAttributes {
            attributes?.append(recommendedSectionBackgroundAttributes)
        }
        
        return attributes
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return recommendedSectionBackgroundAttributes
    }
}
