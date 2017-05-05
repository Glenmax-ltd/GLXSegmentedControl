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
    
    fileprivate var trailingConstraint: NSLayoutConstraint? // this is used as the last contraint for segment


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
    open func addSegmentWithTitle(_ title: String?, onSelectionImage: UIImage?, offSelectionImage: UIImage?) {
        self.insertSegmentWithTitle(title, onSelectionImage: onSelectionImage, offSelectionImage: offSelectionImage, index: self.segments.count)
    }

    open func insertSegmentWithTitle(_ title: String?, onSelectionImage: UIImage?, offSelectionImage: UIImage?, index: Int) {

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
        
        self.resetSegmentIndicesWithIndex(index, by: 1)
        self.segments.insert(segment, at: index)

        self.addSubview(segment)
        
        // now we setup constraints for segment
        
        if self.organiseMode == .horizontal {
            segment.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            segment.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
            if segments.count == 1 {
                // this is first segment so we set constraint to leading anchor
                segment.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            }
            else {
                // trailing contraint was set before so now we remove it
                // because we need to set it to new segment
                trailingConstraint?.isActive = false
                let previousSegment = segments[segments.count - 2]
                segment.leadingAnchor.constraint(equalTo: previousSegment.trailingAnchor, constant: self.dividerWidth).isActive = true
                segment.widthAnchor.constraint(equalTo: previousSegment.widthAnchor).isActive = true
                trailingConstraint = segment.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                trailingConstraint?.isActive = true
            }
        }
        else {
            segment.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            segment.trailingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            
            if segments.count == 1 {
                // this is first segment so we set constraint to leading anchor
                segment.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            }
            else {
                // trailing contraint was set before so now we remove it
                // because we need to set it to new segment
                trailingConstraint?.isActive = false
                let previousSegment = segments[segments.count - 2]
                segment.topAnchor.constraint(equalTo: previousSegment.bottomAnchor, constant: self.dividerWidth).isActive = true
                segment.heightAnchor.constraint(equalTo: previousSegment.heightAnchor).isActive = true
                trailingConstraint = segment.bottomAnchor.constraint(equalTo: self.bottomAnchor)
                trailingConstraint?.isActive = true
            }
        }
    }
    
    // MARK: Remove Segment
    open func removeSegmentAtIndex(_ index: Int) {
        assert(index >= 0 && index < self.segments.count, "Index (\(index)) is out of range")
        
        if index == self.selectedSegmentIndex {
            self.selectedSegmentIndex = UISegmentedControlNoSegment
        }
        self.resetSegmentIndicesWithIndex(index, by: -1)
        let segment = self.segments.remove(at: index)
        segment.removeFromSuperview()
        
        // FIXME: update autolayout constraints
        // otherwise this function does not perform well!
    }
    
    fileprivate func resetSegmentIndicesWithIndex(_ index: Int, by: Int) {
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

    // MARK: Drawing Segment Dividers
    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        let context = UIGraphicsGetCurrentContext()!
        self.drawDividerWithContext(context)
    }

    fileprivate func drawDividerWithContext(_ context: CGContext) {

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
