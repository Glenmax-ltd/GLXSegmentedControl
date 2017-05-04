//
//  GLXSegmentAppearance.swift
//  GLXSegmentedControl
//
//  Created by Si MA on 11/07/2016.
//  Copyright © 2016 si.ma. All rights reserved.
//

import UIKit

open class GLXSegmentAppearance {
    
    // PROPERTIES
    open var segmentOnSelectionColor: UIColor
    open var segmentOffSelectionColor: UIColor
    open var segmentTouchDownColor: UIColor {
        get {
            var onSelectionHue: CGFloat = 0.0
            var onSelectionSaturation: CGFloat = 0.0
            var onSelectionBrightness: CGFloat = 0.0
            var onSelectionAlpha: CGFloat = 0.0
            self.segmentOnSelectionColor.getHue(&onSelectionHue, saturation: &onSelectionSaturation, brightness: &onSelectionBrightness, alpha: &onSelectionAlpha)
            
            var offSelectionHue: CGFloat = 0.0
            var offSelectionSaturation: CGFloat = 0.0
            var offSelectionBrightness: CGFloat = 0.0
            var offSelectionAlpha: CGFloat = 0.0
            self.segmentOffSelectionColor.getHue(&offSelectionHue, saturation: &offSelectionSaturation, brightness: &offSelectionBrightness, alpha: &offSelectionAlpha)
            
            return UIColor(hue: onSelectionHue, saturation: (onSelectionSaturation + offSelectionSaturation)/2.0, brightness: (onSelectionBrightness + offSelectionBrightness)/2.0, alpha: (onSelectionAlpha + offSelectionAlpha)/2.0)
        }
    }
    
    open var titleOnSelectionColor: UIColor
    open var titleOffSelectionColor: UIColor
    
    open var titleOnSelectionFont: UIFont
    open var titleOffSelectionFont: UIFont
    
    open var contentVerticalMargin: CGFloat
    
    
    // Mark: INITIALISER
    public init() {
        
        self.segmentOnSelectionColor = UIColor.darkGray
        self.segmentOffSelectionColor = UIColor.gray
        
        self.titleOnSelectionColor = UIColor.white
        self.titleOffSelectionColor = UIColor.darkGray
        self.titleOnSelectionFont = UIFont.systemFont(ofSize: 17.0)
        self.titleOffSelectionFont = UIFont.systemFont(ofSize: 17.0)
        
        self.contentVerticalMargin = 5.0
    }
    
    public init(contentVerticalMargin: CGFloat, segmentOnSelectionColor: UIColor, segmentOffSelectionColor: UIColor, titleOnSelectionColor: UIColor, titleOffSelectionColor: UIColor, titleOnSelectionFont: UIFont, titleOffSelectionFont: UIFont) {
        
        self.contentVerticalMargin = contentVerticalMargin
        
        self.segmentOnSelectionColor = segmentOnSelectionColor
        self.segmentOffSelectionColor = segmentOffSelectionColor
        
        self.titleOnSelectionColor = titleOnSelectionColor
        self.titleOffSelectionColor = titleOffSelectionColor
        self.titleOnSelectionFont = titleOnSelectionFont
        self.titleOffSelectionFont = titleOffSelectionFont
    }
}
