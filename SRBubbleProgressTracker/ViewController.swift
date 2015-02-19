//
//  ViewController.swift
//  SRBubbleProgressTracker
//
//  Created by Samuel Scott Robbins on 2/9/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var lastButtonSelected = 5
    var bubbleTrackerViewIsSetup = false
    
    @IBOutlet weak var bubbleTrackerView: SRBubbleProgressTrackerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if bubbleTrackerViewIsSetup { return }
        var leftLabels = getLabelArray(7, direction: "Left")
        var rightLabels = getLabelArray(7, direction: "Right")
        
        bubbleTrackerView.setupInitialBubbleProgressTrackerView(7, dotDiameter: 60.0, allign: .Vertical, leftOrTopViews: leftLabels, rightOrBottomViews: rightLabels)
        bubbleTrackerViewIsSetup = true
    }
    
    func getLabelArray(numLabels : Int, direction : String) -> Array<UILabel> {
        var labelArray = Array<UILabel>()
        
        for i in 0..<numLabels {
            var label = UILabel()
            label.text = "\(direction) \(i)"
            label.sizeToFit()
            labelArray.append(label)
        }
        
        return labelArray
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        lastButtonSelected = lastButtonSelected+1
        bubbleTrackerView.bubbleCompleted(lastButtonSelected)
    }
}

