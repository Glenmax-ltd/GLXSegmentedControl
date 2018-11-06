//
//  GLXSegment.swift
//  GLXSegmentedControl
//
//  Created by Si MA on 03/01/2015.
//  Copyright (c) 2015 Si Ma and Glenmax Ltd. All rights reserved.
//

import UIKit

open class GLXSegment: UIView {
    
    // UI components
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        return label
    }()
    
    
    // Title
    open var title: String? {
        didSet {
            self.label.text = self.title
        }
    }
    
    // Image
    open var onSelectionImage: UIImage?
    open var offSelectionImage: UIImage?
    
    // Appearance
    open var appearance: GLXSegmentAppearance
    
    internal var didSelectSegment: ((_ segment: GLXSegment)->())?
    
    open internal(set) var index: Int = 0
    open fileprivate(set) var isSelected: Bool = false
    
    // Init
    internal init(appearance: GLXSegmentAppearance?) {
        
        if let app = appearance {
            self.appearance = app
        }
        
        else {
            self.appearance = GLXSegmentAppearance()
        }
        
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupUIElements() {
        
        var verticalMargin: CGFloat = 0.0
        verticalMargin = appearance.contentVerticalMargin
        
        let imagePresent = (self.offSelectionImage != nil) || (self.onSelectionImage != nil)
        var titlePresent = false
        if let title = self.title {
            titlePresent = (title != "")
        }
        if imagePresent && titlePresent {
            // we have both image and title so we need to center them together
            let view = UIView(frame: CGRect.zero) // this will be used to hold the image and label inside
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(self.imageView)
            view.addSubview(self.label)
            
            self.imageView.image = self.offSelectionImage
            
            view.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.label.trailingAnchor).isActive = true
            self.label.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 3.0).isActive = true // this is used to separate image and label
            
            view.topAnchor.constraint(lessThanOrEqualTo: self.imageView.topAnchor).isActive = true
            view.topAnchor.constraint(lessThanOrEqualTo: self.label.topAnchor).isActive = true
            
            view.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: self.label.centerYAnchor).isActive = true
            
            self.addSubview(view)
            
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            self.topAnchor.constraint(lessThanOrEqualTo: view.topAnchor, constant:-verticalMargin).isActive = true
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor, constant:-appearance.contentHorizontalMargin).isActive = true
        }
        else if imagePresent {
            // only image is present
            self.addSubview(self.imageView)
            self.imageView.image = self.offSelectionImage
            self.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor).isActive = true
            self.topAnchor.constraint(lessThanOrEqualTo: self.imageView.topAnchor, constant: -verticalMargin).isActive = true
            self.leadingAnchor.constraint(lessThanOrEqualTo: self.imageView.leadingAnchor).isActive = true
        }
        else if titlePresent {
            // only label is present
            self.addSubview(self.label)
            self.centerXAnchor.constraint(equalTo: self.label.centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: self.label.centerYAnchor).isActive = true
            self.topAnchor.constraint(lessThanOrEqualTo: self.label.topAnchor, constant: -verticalMargin).isActive = true
            self.leadingAnchor.constraint(lessThanOrEqualTo: self.label.leadingAnchor, constant:-appearance.contentHorizontalMargin).isActive = true
        }
        
        self.backgroundColor = appearance.segmentOffSelectionColor
        if titlePresent {
            self.label.font = appearance.titleOffSelectionFont
            self.label.textColor = appearance.titleOffSelectionColor
        }
        
    }
    
    // MARK: Selections
    internal func setSelected(_ selected: Bool) {
        self.isSelected = selected
        if selected == true {
            self.backgroundColor = self.appearance.segmentOnSelectionColor
            self.label.textColor = self.appearance.titleOnSelectionColor
            self.label.font = self.appearance.titleOnSelectionFont
            self.imageView.image = self.onSelectionImage
        }
        else {
            self.backgroundColor = self.appearance.segmentOffSelectionColor
            self.label.textColor = self.appearance.titleOffSelectionColor
            self.label.font = self.appearance.titleOffSelectionFont
            self.imageView.image = self.offSelectionImage
        }
    }
    
    // MARK: Handle touch
    override open  func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isSelected == false {
            self.backgroundColor = self.appearance.segmentTouchDownColor
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isSelected == false{
            self.didSelectSegment?(self)
        }
    }
}
