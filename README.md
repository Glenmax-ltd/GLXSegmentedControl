#GLXSegmentedControl
<p align="center"><img src ="/Screenshots/example_4.png"/></p>

## Description
- Custom segmented control for iOS 9 and above.
- Written in Swift.
- Supports both images and text.
- Supports vertically organised segments.
- If font size needs to be lowered for one segment, it can automatically adjust font in other segments.
- More customisible than UISegmentedControl and easier to expand with new style.

## Installation

### Carthage
Add 
`github "glenmax-ltd/GLXSegmentedControl"` 
to your Cartfile.

### CocoaPods
Add 
`pod 'GLXSegmentedControl'` 
to your Podfile.

### Manual
Drag `GLXSegmentedControl.swift`, `GLXSegment.swift` and `GLXSegmentAppearance.swift` into your Xcode project.

## Usage
#### Step 1
Initialise GLXSegmentedControl:
You can simply use `GLXSegmentedControl(frame:)` to initialise your segment view by using the default properties. 
But mostly, you may want to use `GLXSegmentedControl(frame:, segmentAppearance:)` to make it look more customised.
The parameter `segmentAppearance:` reads a `GLXSegmentAppearance` instance. You can find what attributes it supports in `GLXSegmentAppearance` class.

E.g.:
```swift
let appearance = GLXSegmentAppearance()
appearance.segmentOnSelectionColour = UIColor(red: 245.0/255.0, green: 174.0/255.0, blue: 63.0/255.0, alpha: 1.0)
appearance.segmentOffSelectionColour = UIColor.whiteColor()
appearance.titleOnSelectionFont = UIFont.systemFontOfSize(12.0)
appearance.titleOffSelectionFont = UIFont.systemFontOfSize(12.0)
appearance.contentVerticalMargin = 10.0

let segmentedControl = GLXSegmentView(frame: SomeFrame, dividerColour: UIColor(white: 0.95, alpha: 0.3), dividerWidth: 1.0, segmentAppearance: appearance)
```

#### Step 2
Add action for UIControlEvents.ValueChanged, and implement the action method.

E.g. `segmentedControl.addTarget(self, action: #selector(YourViewController.selectSegmentInSegmentView(_:)), forControlEvents: .ValueChanged)`

#### Step 3
Add segments to your segmented control.

E.g.:
```
segmentedControl.addSegmentWithTitle("Segment 1", onSelectionImage: UIImage(named: "target_light"), offSelectionImage: UIImage(named: "target"))
segmentedControl.addSegmentWithTitle("Segment 2", onSelectionImage: UIImage(named: "handbag_light"), offSelectionImage: UIImage(named: "handbag"))
segmentedControl.addSegmentWithTitle("Segment 3", onSelectionImage: UIImage(named: "globe_light"), offSelectionImage: UIImage(named: "globe"))
```

# Support Vertical Mode
You can organise all segments vertically by setting the `organiseMode` as `.vertical`. It is set to `.horizontal` by default.

E.g. `segmentedControl.organiseMode = .vertical`

# Screenshots
<p align="center"><img src ="/Screenshots/example_2.png"/></p>
<p align="center"><img src ="/Screenshots/example_3.png"/></p>
