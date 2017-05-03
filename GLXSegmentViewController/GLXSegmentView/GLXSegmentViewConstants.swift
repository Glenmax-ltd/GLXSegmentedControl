//
//  GLXSegmentConstants.swift
//  GLXSegmentViewController
//
//  Created by Si MA on 17/06/2016.
//  Copyright © 2016 si.ma. All rights reserved.
//

import Foundation

public struct GLXSegmentedControlKeys {
    
    // Image/text margin to segment top/bottom
    static let kContentVerticalMargin = "VerticalMargin"
    
    // Segment colour when is under selected/deselected
    static let kSegmentOnSelectionColour = "SegmentOnSelectionColour"
    static let kSegmentOffSelectionColour = "SegmentOffSelectionColour"
    
    // Title colour when is under selected/deselected
    static let kTitleOnSelectionColour = "TitleOnSelectionColour"
    static let kTitleOffSelectionColour = "TitleOffSelectionColour"
    
    // Font of the title
    static let kTitleFont = "TitleFont"
}

public enum GLXSegmentOrganiseMode: Int {
    case horizontal
    case vertical
}
