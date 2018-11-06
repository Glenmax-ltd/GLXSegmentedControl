//
//  GLXSegmentedControlController
//
//  Created by Si Ma on 05/01/2015.
//  Copyright (c) 2015 Si Ma and Glenmax Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var segmentedControl: GLXSegmentedControl!
    var margin: CGFloat = 10.0
    
    var segmentCount = 0
    
    var segmentTitles = ["Clip", "Blub", "Cloud"]
    
    @IBOutlet var insertButton:UIButton!
    @IBOutlet var removeButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

        /*
          Use GLXSegmentAppearance to set segment related UI properties.
          Each property has its own default value, so you only need to specify the ones you are interested.
        */
        
        let appearance = GLXSegmentAppearance()
        appearance.segmentOnSelectionColor = UIColor(red: 245.0/255.0, green: 174.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        appearance.segmentOffSelectionColor = UIColor.white
        appearance.titleOnSelectionFont = UIFont.systemFont(ofSize: 40.0)
        appearance.titleOffSelectionFont = UIFont.systemFont(ofSize: 40.0)
        appearance.contentVerticalMargin = 10.0
        appearance.dividerColor =  UIColor(white: 0.95, alpha: 0.3)
        
        /*
          Init GLXSegmentedControl
          Set divider Color and width here if there is a need
         */
        let segmentFrame = CGRect(x: self.margin, y: 120.0, width: self.view.frame.size.width - self.margin*2, height: 40.0)
        self.segmentedControl = GLXSegmentedControl(frame: segmentFrame, segmentAppearance: appearance)
        self.segmentedControl.backgroundColor = UIColor.clear
        
        self.segmentedControl.layer.cornerRadius = 5.0
        self.segmentedControl.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        self.segmentedControl.layer.borderWidth = 1.0

        // Add segments
        self.segmentedControl.addSegment(withTitle:"Clip", onSelectionImage: UIImage(named: "clip_light"), offSelectionImage: UIImage(named: "clip"))
        self.segmentedControl.addSegment(withTitle:"Blub", onSelectionImage: UIImage(named: "bulb_light"), offSelectionImage: UIImage(named: "bulb"))
        self.segmentedControl.addSegment(withTitle:"Cloud", onSelectionImage: UIImage(named: "cloud_light"), offSelectionImage: UIImage(named: "cloud"))
        
        segmentCount = 3
        self.segmentedControl.addTarget(self, action: #selector(selectSegmentInsegmentedControl(segmentedControl:)), for: .valueChanged)
        
        // Set segment with index 0 as selected by default
        self.segmentedControl.selectedSegmentIndex = 0
        self.view.addSubview(self.segmentedControl)
    }
    
    // GLXSegment selector for .ValueChanged
    @objc func selectSegmentInsegmentedControl(segmentedControl: GLXSegmentedControl) {
        /*
        Replace the following line to implement what you want the app to do after the segment gets tapped.
        */
        print("Select segment at index: \(segmentedControl.selectedSegmentIndex)")
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        /*
        MARK: Replace the following line to your own frame setting for segmentedControl.
        */
        if toInterfaceOrientation == UIInterfaceOrientation.landscapeLeft || toInterfaceOrientation == UIInterfaceOrientation.landscapeRight {
            
            self.segmentedControl.organiseMode = .vertical
            self.segmentedControl.segmentAppearance.contentVerticalMargin = 25.0
            self.segmentedControl.frame = CGRect(x: self.view.frame.size.width/2 - 40.0, y: 100.0, width: 80.0, height: 220.0)
        }
        else {
            
            self.segmentedControl.organiseMode = .horizontal
            self.segmentedControl.segmentAppearance.contentVerticalMargin = 10.0
            self.segmentedControl.frame = CGRect(x: self.margin, y: 120.0, width: self.view.frame.size.width - self.margin*2, height: 40.0)
            
        }
    }
    
    @IBAction func removeSegment(_ sender:UIButton) {
        let index = Int(arc4random()) % segmentCount
        self.segmentedControl.removeSegment(at:index, animated: true)
        segmentTitles.remove(at: index)
        
        insertButton.isEnabled = segmentTitles.count < 3
        removeButton.isEnabled = segmentTitles.count > 1
    }
    
    @IBAction func addSegment(_ sender:UIButton) {
        
        let allSegments = ["Clip", "Blub", "Cloud"]
        var possibleInsertions = [String]()
        for title in allSegments {
            if segmentTitles.contains(title) {
                continue
            }
            possibleInsertions.append(title)
        }
        
        let titleToInsert = possibleInsertions[Int(arc4random()) % possibleInsertions.count]
        
        let index = Int(arc4random()) % (segmentTitles.count+1)
        
        if titleToInsert == "Clip" {
            self.segmentedControl.insertSegment(withTitle:"Clip", onSelectionImage: UIImage(named: "clip_light"), offSelectionImage: UIImage(named: "clip"), index: index, animated: true)
        }
        else if titleToInsert == "Blub" {
            self.segmentedControl.insertSegment(withTitle:"Blub", onSelectionImage: UIImage(named: "bulb_light"), offSelectionImage: UIImage(named: "bulb"), index: index, animated: true)
        }
        else {
            self.segmentedControl.insertSegment(withTitle:"Cloud", onSelectionImage: UIImage(named: "cloud_light"), offSelectionImage: UIImage(named: "cloud"), index: index, animated: true)
        }
        segmentTitles.insert(titleToInsert, at: index)
        insertButton.isEnabled = segmentTitles.count < 3
        removeButton.isEnabled = segmentTitles.count > 1
    }
}

