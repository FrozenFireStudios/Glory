//
//  FFBorderButton.swift
//  ClemsonRSS
//
//  Created by Ryan Poolos on 10/8/15.
//  Copyright © 2015 FrozenFireStudios. All rights reserved.
//

import UIKit

public class FFBorderButton: UIButton {

    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = CGFloat(FFPixelHeight)
        
        layer.cornerRadius = 4.0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards Ugh")
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        
        layer.borderColor = tintColor.cgColor
        setTitleColor(tintColor, for: .normal)
    }
    
    public func updateBackgroundColor() {
        if isHighlighted || isSelected {
            backgroundColor = activeBackgroundColor
        }
        else {
            backgroundColor = normalBackgroundColor
        }
    }
    
    override public var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    override public var isSelected: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    public var normalBackgroundColor: UIColor? {
        didSet {
            backgroundColor = normalBackgroundColor
        }
    }
    
    public lazy var activeBackgroundColor: UIColor? = self.tintColor.withAlphaComponent(0.25)
    
    override public var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += titleEdgeInsets.left + titleEdgeInsets.right
        size.height += titleEdgeInsets.top + titleEdgeInsets.bottom
        return size
    }
}
