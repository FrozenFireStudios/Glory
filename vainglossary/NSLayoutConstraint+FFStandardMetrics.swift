//
//  NSLayoutConstraint+FFStandardMetrics.swift
//
//  Created by Ryan Poolos on 4/22/15.
//  Copyright (c) 2015 Frozen Fire Studios, Inc. All rights reserved.
//

import UIKit

public let FFHalfPadding = 4.0
public let FFPadding = 8.0
public let FFMargin = 16.0
public let FFDoubleMargin = 32.0
public let FFPixelHeight = 1.0 / Double(UIScreen.main.scale)

public let FFHalfPaddingKey = "HalfPadding"
public let FFPaddingKey = "Padding"
public let FFMarginKey = "Margin"
public let FFDoubleMarginKey = "DoubleMargin"
public let FFPixelHeightKey = "PixelHeight"

private var _standardMetrics: [String:Double] = [
    FFHalfPaddingKey: FFHalfPadding,
    FFPaddingKey: FFPadding,
    FFMarginKey: FFMargin,
    FFDoubleMarginKey: FFDoubleMargin,
    FFPixelHeightKey: FFPixelHeight
]

public extension NSLayoutConstraint {
    
    //==========================================================================
    // MARK: - Standard Metrics
    //==========================================================================
    
    public static var standardMetrics: [String:Double] {
        get {
            return _standardMetrics
        }
    }
    
    public class func addStandardMetric(_ key: String, value: Double) {
        _standardMetrics[key] = value
    }
    
    //==========================================================================
    // MARK: - Visual Format Convenience
    //==========================================================================
    
    @discardableResult public class func constraintsWithFormat(_ format: String, views: [String:UIView], metrics: [String:Double] = standardMetrics, options: NSLayoutFormatOptions = []) -> [NSLayoutConstraint] {
        return constraints(withVisualFormat: format, options: options, metrics: metrics, views: views)
    }
    
    @discardableResult public class func activeConstraintsWithFormat(_ format: String, views: [String:UIView], metrics: [String:Double] = standardMetrics, options: NSLayoutFormatOptions = []) -> [NSLayoutConstraint] {
        let constraints = constraintsWithFormat(format, views: views, metrics: metrics, options: options)
        
        activate(constraints)
        
        return constraints
    }
}

// This could be a fun addition to make your visual format array code look like 
// your regular constraint code
//
// i.e. constraintsWithFormat().isActive = true
//      constraintEqualToAnchor().isActive = true
//
//extension SequenceType where Generator.Element == NSLayoutConstraint {
//    var active: Bool {
//        get {
//            return reduce(false) { (active, constraint) -> Bool in
//                return active && constraint.active
//            }
//        }
//        set {
//            forEach { constraint in
//                constraint.isActive = newValue
//            }
//        }
//    }
//}
