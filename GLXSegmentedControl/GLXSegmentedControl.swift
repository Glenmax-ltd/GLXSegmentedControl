//
//  GLXSegmentedControl.swift
//  GLXSegmentedControlController
//
//  Created by Si Ma on 01/10/15.
//  Copyright © 2015 Si Ma and Glenmax Ltd. All rights reserved.
//

import UIKit

extension UILabel {
    
    func fontFitsCurrentFrame(_ font:UIFont) -> Bool {
        let attributes = [NSFontAttributeName:font]
        if let size = self.text?.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil) {
            if size.width > frame.size.width {
                return false
            }
            if size.height > frame.size.height {
                return false
            }
        }
        return true
    }
    
}

public enum GLXSegmentOrganiseMode: Int {
    case horizontal
    case vertical
}

open class GLXSegmentedControl: UIControl {

    open var segmentAppearance: GLXSegmentAppearance
    
    open var enforceEqualFontForLabels = true

    // Divider Color & width
    open var dividerColor: UIColor {
        get {
            return self.segmentAppearance.dividerColor
        }
    }
    open var dividerWidth: CGFloat {
        get {
            return self.segmentAppearance.dividerWidth
        }
    }

    open var selectedSegmentIndex: Int {
        get {
            if let segment = self.selectedSegment {
                return segment.index
            }
            else {
                return UISegmentedControlNoSegment
            }
        }
        set(newIndex) {
            self.deselectSegment()
            if newIndex >= 0 && newIndex < self.segments.count {
                let currentSelectedSegment = self.segments[newIndex]
                self.selectSegment(currentSelectedSegment)
            }
        }
    }

    open var organiseMode: GLXSegmentOrganiseMode = .horizontal {
        didSet {
            if self.organiseMode != oldValue {
                self.setNeedsDisplay()
            }
        }
    }

    open var numberOfSegments: Int {
        get {
            return segments.count
        }
    }

    fileprivate var segments: [GLXSegment] = []
    fileprivate var selectedSegment: GLXSegment?

    // INITIALISER
    required public init?(coder aDecoder: NSCoder) {
        self.segmentAppearance = GLXSegmentAppearance()
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
    }

    override public init(frame: CGRect) {
        self.segmentAppearance = GLXSegmentAppearance()
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
    }

    public init(frame: CGRect, segmentAppearance: GLXSegmentAppearance) {
        self.segmentAppearance = segmentAppearance
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
    }
    

    // MARK: Actions
    // MARK: Select/deselect Segment
    fileprivate func selectSegment(_ segment: GLXSegment, fireAction:Bool = false) {
        segment.setSelected(true)
        self.selectedSegment = segment
        if fireAction {
            self.sendActions(for: .valueChanged)
        }
    }
    fileprivate func deselectSegment() {
        self.selectedSegment?.setSelected(false)
        self.selectedSegment = nil
    }

    // MARK: Add Segment
    open func addSegment(withTitle title: String?, onSelectionImage: UIImage?, offSelectionImage: UIImage?) {
        self.insertSegment(withTitle:title, onSelectionImage: onSelectionImage, offSelectionImage: offSelectionImage, index: self.segments.count)
    }

    open func insertSegment(withTitle title: String?, onSelectionImage: UIImage?, offSelectionImage: UIImage?, index: Int) {

        let segment = GLXSegment(appearance: self.segmentAppearance)
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.title = title
        segment.onSelectionImage = onSelectionImage
        segment.offSelectionImage = offSelectionImage
        segment.index = index
        segment.didSelectSegment = { [unowned self] segment in
            if self.selectedSegment != segment {
                self.deselectSegment()
                self.selectSegment(segment, fireAction:true)
            }
        }
        segment.setupUIElements()
        
        self.resetSegmentIndices(withIndex: index, by: 1)
        self.segments.insert(segment, at: index)

        self.addSubview(segment)
        
        // now we setup constraints for segment
        
        self.updateConstraintsForSegmentInsertion(at: index)
    }
    
    // MARK: Remove Segment
    open func removeSegment(at index: Int) {
        assert(index >= 0 && index < self.segments.count, "Index (\(index)) is out of range")
        
        if index == self.selectedSegmentIndex {
            self.selectedSegmentIndex = UISegmentedControlNoSegment
        }
        self.resetSegmentIndices(withIndex: index, by: -1)
        let segment = self.segments.remove(at: index)
        segment.removeFromSuperview()
        
        guard segments.count > 0 else {
            return
        }
        
        // if some segments remain we need to update constraints
        
        self.updateConstraintsForSegmentRemoval(at: index)
    }
    
    fileprivate func resetSegmentIndices(withIndex index: Int, by: Int) {
        if index < self.segments.count {
            for i in index..<self.segments.count {
                let segment = self.segments[i]
                segment.index += by
            }
        }
    }

    // MARK: UI
    // MARK: Update layout
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // FIXME: I do not yet understand why line above is not sufficient
        // to put subviews into their frames
        for subview in self.subviews {
            subview.layoutIfNeeded()
        }
        labelFontAdj: if enforceEqualFontForLabels {
            var labelsToCheck = [UILabel]()
            for segment in segments {
                guard
                    let title = segment.title,
                    title != ""
                    else {continue}
                labelsToCheck.append(segment.label)
            }
            
            guard labelsToCheck.count > 0 else {break labelFontAdj}
            var minimumScaleFactor:CGFloat = 0.0
            var selectedFont = segmentAppearance.titleOnSelectionFont
            var nonSelectedFont = segmentAppearance.titleOffSelectionFont
            for label in labelsToCheck {
                minimumScaleFactor = max(minimumScaleFactor, label.minimumScaleFactor)
            }
            
            var selectedFound = false
            var nonSelectedFound = false
            
            for currentScaleFactor in stride(from: 1.0, to: minimumScaleFactor, by: -0.05) {
                let newSelectedFont  = selectedFont.withSize(selectedFont.pointSize * currentScaleFactor)
                let newNonSelectedFont = nonSelectedFont.withSize(nonSelectedFont.pointSize * currentScaleFactor)
                var trySelected = !selectedFound
                var tryNonSelected = !nonSelectedFound
                for label in labelsToCheck {
                    if trySelected {
                        trySelected = trySelected && label.fontFitsCurrentFrame(newSelectedFont)
                    }
                    if tryNonSelected {
                        tryNonSelected = tryNonSelected && label.fontFitsCurrentFrame(newNonSelectedFont)
                    }
                    if !(trySelected || tryNonSelected) {
                        break
                    }
                }
                
                if trySelected {
                    selectedFont = newSelectedFont
                    selectedFound = true
                }
                
                if tryNonSelected {
                    nonSelectedFont = newNonSelectedFont
                    nonSelectedFound = true
                }
                
                if selectedFound && nonSelectedFound {
                    break
                }
            }
            segmentAppearance.titleOnSelectionFont = selectedFont
            segmentAppearance.titleOffSelectionFont = nonSelectedFont
            for segment in segments {
                if segment.isSelected {
                    segment.label.font = segmentAppearance.titleOnSelectionFont
                }
                else {
                    segment.label.font = segmentAppearance.titleOffSelectionFont
                }
            }
        }
    }
    
    func updateConstraintsForSegmentInsertion(at index:Int) {
        let itemBefore:UIView
        let itemAfter:UIView
        
        let itemBeforeConstant:CGFloat
        let itemAfterConstant:CGFloat
        
        let segment = segments[index]
        
        if self.organiseMode == .horizontal {
            segment.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            segment.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
            let itemBeforeAnchor:NSLayoutXAxisAnchor
            let itemAfterAnchor:NSLayoutXAxisAnchor
            
            if index == 0 {
                itemBefore = self
                itemBeforeAnchor = self.leadingAnchor
                itemBeforeConstant = 0
            }
            else {
                itemBefore = segments[index-1]
                itemBeforeAnchor = itemBefore.trailingAnchor
                itemBeforeConstant = dividerWidth
            }
            
            if index == segments.count - 1 {
                itemAfter = self
                itemAfterAnchor = self.trailingAnchor
                itemAfterConstant = 0
            }
            else {
                itemAfter = segments[index+1]
                itemAfterAnchor = itemAfter.leadingAnchor
                itemAfterConstant = dividerWidth
            }
            
            itemAfterAnchor.constraint(equalTo: segment.trailingAnchor, constant: itemAfterConstant).isActive = true
            segment.leadingAnchor.constraint(equalTo: itemBeforeAnchor, constant: itemBeforeConstant).isActive = true
            
            if itemAfter != self {
                itemAfter.widthAnchor.constraint(equalTo: segment.widthAnchor).isActive = true
            }
            
            if itemBefore != self {
                segment.widthAnchor.constraint(equalTo: itemBefore.widthAnchor).isActive = true
            }
            
            
        }
        else {
            segment.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            segment.trailingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            
            let itemBeforeAnchor:NSLayoutYAxisAnchor
            let itemAfterAnchor:NSLayoutYAxisAnchor
            
            if index == 0 {
                itemBefore = self
                itemBeforeAnchor = self.topAnchor
                itemBeforeConstant = 0
            }
            else {
                itemBefore = segments[index-1]
                itemBeforeAnchor = itemBefore.bottomAnchor
                itemBeforeConstant = dividerWidth
            }
            
            if index == segments.count - 1 {
                itemAfter = self
                itemAfterAnchor = self.bottomAnchor
                itemAfterConstant = 0
            }
            else {
                itemAfter = segments[index+1]
                itemAfterAnchor = itemAfter.topAnchor
                itemAfterConstant = dividerWidth
            }
            
            if segments.count > index+2 {
                // we have a segment after
            }
            
            itemAfterAnchor.constraint(equalTo: segment.bottomAnchor, constant: itemAfterConstant).isActive = true
            segment.topAnchor.constraint(equalTo: itemBeforeAnchor, constant: itemBeforeConstant).isActive = true
            
            if itemAfter != self {
                itemAfter.heightAnchor.constraint(equalTo: segment.heightAnchor).isActive = true
            }
            
            if itemBefore != self {
                itemBefore.heightAnchor.constraint(equalTo: segment.heightAnchor).isActive = true
            }
        }
        
        let constraintsToRemove = self.constraints.filter({ (constraint) -> Bool in
            return (constraint.firstItem as! NSObject == itemAfter) && (constraint.secondItem as! NSObject == itemBefore)
        })
        
        for constraint in constraintsToRemove {
            constraint.isActive = false
        }
    }
    
    func updateConstraintsForSegmentRemoval(at index:Int) {
        if self.organiseMode == .horizontal {
            if index == 0 {
                // we deleted first segment
                segments[0].leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            }
            else if index == segments.count {
                // we deleted last segment
                segments[index-1].trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            }
            else {
                // there is one segment before and one segment after
                let segmentBefore = segments[index-1]
                let segmentAfter = segments[index]
                segmentAfter.leadingAnchor.constraint(equalTo: segmentBefore.trailingAnchor, constant: dividerWidth).isActive = true
                segmentBefore.widthAnchor.constraint(equalTo: segmentAfter.widthAnchor).isActive = true
            }
        }
        else {
            if index == 0 {
                // we deleted first segment
                segments[0].topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            }
            else if index == segments.count {
                // we deleted last segment
                segments[index-1].bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            }
            else {
                // there is one segment before and one segment after
                let segmentBefore = segments[index-1]
                let segmentAfter = segments[index]
                segmentAfter.topAnchor.constraint(equalTo: segmentBefore.bottomAnchor, constant: dividerWidth).isActive = true
                segmentBefore.heightAnchor.constraint(equalTo: segmentAfter.heightAnchor).isActive = true
            }
        }
    }

    // MARK: Drawing Segment Dividers
    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        let context = UIGraphicsGetCurrentContext()!
        self.drawDivider(withContext: context)
    }

    fileprivate func drawDivider(withContext context: CGContext) {

        context.saveGState()

        if self.segments.count > 1 {
            let path = CGMutablePath()

            if self.organiseMode == .horizontal {
                var originX: CGFloat = self.segments[0].frame.size.width + self.dividerWidth/2.0
                for index in 1..<self.segments.count {
                    path.move(to: CGPoint(x: originX, y: 0.0))
                    path.addLine(to: CGPoint(x: originX, y: self.frame.size.height))

                    originX += self.segments[index].frame.width + self.dividerWidth
                }
            }
            else {
                var originY: CGFloat = self.segments[0].frame.size.height + self.dividerWidth/2.0
                for index in 1..<self.segments.count {
                    path.move(to: CGPoint(x: 0.0, y: originY))
                    path.addLine(to: CGPoint(x: self.frame.size.width, y: originY))

                    originY += self.segments[index].frame.height + self.dividerWidth
                }
            }

            context.addPath(path)
            context.setStrokeColor(self.dividerColor.cgColor)
            context.setLineWidth(self.dividerWidth)
            context.drawPath(using: CGPathDrawingMode.stroke)
        }
        
        context.restoreGState()
    }
}
