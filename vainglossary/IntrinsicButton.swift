//
//  IntrinsicButton.swift
//  vainglossary
//
//  Created by Ryan Poolos on 3/25/17.
//  Copyright © 2017 FrozenFireStudios. All rights reserved.
//

import UIKit

class IntrinsicButton: UIButton {
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += titleEdgeInsets.left + titleEdgeInsets.right
        size.height += titleEdgeInsets.top + titleEdgeInsets.bottom
        return size
    }
}
