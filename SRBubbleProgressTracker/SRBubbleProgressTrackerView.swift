//
//  SRBubbleProgressTrackerView.swift
//  SRBubbleProgressTracker
//
//  Created by Samuel Scott Robbins on 2/9/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit

public enum BubbleAllignment {
    case Vertical
    case Horizontal
}

public class SRBubbleProgressTrackerView : UIView {

    // MARK: Initializations
    private var lastBubbleCompleted = 0
    private var bubbleArray = [UIView]()
    private var connectLineArray = [UIView]()
    private var bubbleAllignment = BubbleAllignment.Vertical
    private var animateToBubbleQueue = [Int]()
    
    // MARK: Color Defaults
    @IBInspectable
    var lineColorForNotCompleted : UIColor = .grayColor()
    @IBInspectable
    var lineColorForCompleted : UIColor = .greenColor()
    @IBInspectable
    var bubbleBackgroundColorForNotCompleted : UIColor = .grayColor()
    @IBInspectable
    var bubbleBackgroundColorForCompleted : UIColor = .greenColor()
    @IBInspectable
    var bubbleBackgroundColorForNextToComplete : UIColor = .orangeColor()
    @IBInspectable
    var bubbleTextColorForNotCompleted : UIColor = .whiteColor()
    @IBInspectable
    var bubbleTextColorForCompleted : UIColor = .whiteColor()
    @IBInspectable
    var bubbleTextColorForNextToComplete : UIColor = .whiteColor()
    
    // MARK: Setup View
    public func setupInitialBubbleProgressTrackerView(numBubbles : Int, dotDiameter : CGFloat, allign : BubbleAllignment) {
        bubbleAllignment = allign
        for line in connectLineArray { line.removeFromSuperview() }
        connectLineArray.removeAll(keepCapacity: false)
        
        for bubble in bubbleArray { removeFromSuperview() }
        bubbleArray.removeAll(keepCapacity: false)
        lastBubbleCompleted = 0
        
        // Add the lines into the view
        let lineStartDown = dotDiameter / 2.0
        let lineWidth = dotDiameter * 0.2
        let length = (bubbleAllignment == .Vertical) ? self.frame.size.height : self.frame.size.width
        let width = (bubbleAllignment == .Vertical) ? self.frame.size.width : self.frame.size.height
        var lineStartMiddle = (width / 2.0) - (lineWidth / 2.0)
        let lineHeight = (length - lineStartDown * 2.0) / CGFloat(numBubbles - 1)
        
        addLinesIntoView(lineStartDown, lineStartMiddle: lineStartMiddle, lineHeight: lineHeight, lineWidth: lineWidth, numLines: numBubbles - 1)
        lineStartMiddle = (width / 2.0) - (dotDiameter / 2.0)
        
        // Add bubbles into the view
        for i in 0..<numBubbles {
            addBubbleIntoView(lineStartMiddle, lineHeight: lineHeight, lineWidth: lineWidth, dotDiameter: dotDiameter, bubbleNumber: i)
        }
    }
    
    public func setupInitialBubbleProgressTrackerView(numBubbles : Int, dotDiameter : CGFloat, allign : BubbleAllignment, leftOrTopViews : [UIView], rightOrBottomViews : [UIView]) {
        
        let spaceLeftOrTopOfBubbles : CGFloat = 20.0
        bubbleAllignment = allign
        connectLineArray.removeAll(keepCapacity: false)
        bubbleArray.removeAll(keepCapacity: false)
        lastBubbleCompleted = 0
        
        // Add the lines into the view
        let lineStartDown = dotDiameter / 2.0
        let lineWidth = dotDiameter * 0.2
        let length = (bubbleAllignment == .Vertical) ? self.frame.size.height : self.frame.size.width
        let width = (bubbleAllignment == .Vertical) ? self.frame.size.width : self.frame.size.height
        var startMiddle = (width / 2.0) - (lineWidth / 2.0)
        let lineHeight = (length - lineStartDown * 2.0) / CGFloat(numBubbles - 1)
        
        addLinesIntoView(lineStartDown, lineStartMiddle: startMiddle, lineHeight: lineHeight, lineWidth: lineWidth, numLines: numBubbles - 1)
        startMiddle = (width / 2.0) - (dotDiameter / 2.0)
        
        // Add bubbles into the view
        for i in 0..<numBubbles {
            let bubbleFrame = addBubbleIntoView(startMiddle, lineHeight: lineHeight, lineWidth: lineWidth, dotDiameter: dotDiameter, bubbleNumber: i)
            
            if i < leftOrTopViews.count {
                if bubbleAllignment == .Vertical {
                    let pointYCenter : CGFloat = bubbleFrame.origin.y + bubbleFrame.size.height / 2.0
                    let pointY : CGFloat = pointYCenter - (leftOrTopViews[i].frame.size.height / 2.0)
                    let pointX : CGFloat = bubbleFrame.origin.x - spaceLeftOrTopOfBubbles - leftOrTopViews[i].frame.size.width
                    leftOrTopViews[i].frame.origin = CGPointMake(pointX, pointY)
                } else {
                    let pointXCenter : CGFloat = bubbleFrame.origin.x + bubbleFrame.size.width / 2.0
                    let pointX : CGFloat = pointXCenter - (leftOrTopViews[i].frame.size.width / 2.0)
                    let pointY : CGFloat = bubbleFrame.origin.y - spaceLeftOrTopOfBubbles - leftOrTopViews[i].frame.size.height
                    leftOrTopViews[i].frame.origin = CGPointMake(pointX, pointY)
                }
                
                self.addSubview(leftOrTopViews[i])
            }
            
            if i < rightOrBottomViews.count {
                if bubbleAllignment == .Vertical {
                    let pointYCenter : CGFloat = bubbleFrame.origin.y + bubbleFrame.size.height / 2.0
                    let pointY : CGFloat = pointYCenter - (rightOrBottomViews[i].frame.size.height / 2.0)
                    let pointX : CGFloat = bubbleFrame.origin.x + bubbleFrame.size.width + spaceLeftOrTopOfBubbles
                    rightOrBottomViews[i].frame.origin = CGPointMake(pointX, pointY)
                } else {
                    let pointXCenter : CGFloat = bubbleFrame.origin.x + bubbleFrame.size.width / 2.0
                    let pointX : CGFloat = pointXCenter - (rightOrBottomViews[i].frame.size.width / 2.0)
                    let pointY : CGFloat = bubbleFrame.origin.y + bubbleFrame.size.height + spaceLeftOrTopOfBubbles
                    rightOrBottomViews[i].frame.origin = CGPointMake(pointX, pointY)
                }
                self.addSubview(rightOrBottomViews[i])
            }
        }
        
    }
    
    private func addLinesIntoView(lineStartDown : CGFloat, lineStartMiddle : CGFloat, lineHeight : CGFloat, lineWidth : CGFloat, numLines : Int) {
        // Add lines into view
        for i in 0..<numLines {
            var lineView = UIView()
            
            if bubbleAllignment == .Vertical {
                lineView.frame = CGRectMake(lineStartMiddle, lineStartDown + lineHeight * CGFloat(i), lineWidth, lineHeight)
            } else {
                lineView.frame = CGRectMake(lineStartDown + lineHeight * CGFloat(i), lineStartMiddle, lineHeight, lineWidth)
            }
            
            lineView.backgroundColor = lineColorForNotCompleted
            connectLineArray.append(lineView)
            self.addSubview(lineView)
        }

    }
    
    private func addBubbleIntoView(bubbleStartMiddle : CGFloat, lineHeight : CGFloat, lineWidth : CGFloat, dotDiameter : CGFloat, bubbleNumber : Int) -> CGRect {
        var bubbleViewFrame = CGRect()
        
        if bubbleAllignment == .Vertical {
            bubbleViewFrame = CGRectMake(bubbleStartMiddle, lineHeight * CGFloat(bubbleNumber), dotDiameter, dotDiameter)
        } else {
            bubbleViewFrame = CGRectMake(lineHeight * CGFloat(bubbleNumber), bubbleStartMiddle, dotDiameter, dotDiameter)
        }
        
        var bubbleView = getBubbleView(bubbleViewFrame, number: bubbleNumber+1)
        bubbleArray.append(bubbleView)
        self.addSubview(bubbleView)
        
        return bubbleView.frame
    }
    
    private func getBubbleView(frame : CGRect, number : Int) -> UIView {
        var bubbleView = UIView(frame: frame)
        
        var numberLabel = UILabel()
        numberLabel.frame = CGRectMake(0, 0, bubbleView.frame.size.width, bubbleView.frame.size.height)
        numberLabel.text = "\(number)"
        numberLabel.textAlignment = NSTextAlignment.Center
        numberLabel.textColor = (number == 1) ? bubbleTextColorForNextToComplete : bubbleTextColorForNotCompleted
        numberLabel.font = UIFont.systemFontOfSize(30.0)
        bubbleView.addSubview(numberLabel)
        
        bubbleView.backgroundColor = (number == 1) ? bubbleBackgroundColorForNextToComplete : bubbleBackgroundColorForNotCompleted
        bubbleView.layer.cornerRadius = bubbleView.frame.size.width / 2.0
        
        return bubbleView
    }
    
    // MARK: Magic
    public func bubbleCompleted(numBubbleCompleted : Int) {
        if animateToBubbleQueue.isEmpty {
            if let startBubble = getStartBubble(numBubbleCompleted) {
                animateToBubbleQueue.append(startBubble)
                checkBubbleCompleted(startBubble, start: lastBubbleCompleted++)
            }
        } else {
            for num in animateToBubbleQueue {
                if num >= numBubbleCompleted { return }
            }
            animateToBubbleQueue.append(numBubbleCompleted)
        }
    }
    
    private func removeAnimatedBubbleFromQueueAndContinue() {
        if !animateToBubbleQueue.isEmpty {
            animateToBubbleQueue.removeAtIndex(0)
            
            if !animateToBubbleQueue.isEmpty {
                if let startBubble = getStartBubble(animateToBubbleQueue[0]) {
                    checkBubbleCompleted(startBubble, start: lastBubbleCompleted++)
                }
            }
        }
    }
    
    private func getStartBubble(numBubbleCompleted : Int) -> Int? {
        var startBubble = Int()
        if numBubbleCompleted >= bubbleArray.count {
            if lastBubbleCompleted == bubbleArray.count { return nil }
            startBubble = bubbleArray.count
        } else {
            if lastBubbleCompleted >= numBubbleCompleted { return nil }
            startBubble = numBubbleCompleted
        }
        
        return startBubble
    }
    
    private func checkBubbleCompleted(numBubbleCompleted : Int, start : Int) {
        var frame = bubbleArray[start].frame
        var newFrame = CGRectMake(frame.size.width / 2.0, frame.size.height / 2.0, 0, 0)
        var temporaryBubble = getBubbleView(frame, number: start+1)
        var labelView = temporaryBubble.subviews[0] as UILabel
        labelView.textColor = bubbleTextColorForCompleted
        var tempBubbleCornerRadius = temporaryBubble.layer.cornerRadius
        
        temporaryBubble.layer.cornerRadius = 0.0 // so we can animate the corner radius
        labelView.removeFromSuperview() // so we can add it overtop teh new filling bubble
        temporaryBubble.frame = newFrame
        temporaryBubble.backgroundColor = bubbleBackgroundColorForCompleted
        bubbleArray[start].addSubview(temporaryBubble)
        bubbleArray[start].addSubview(labelView)
        
        // Animate the first bubble filling iwth its new color
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            temporaryBubble.frame = CGRectMake(0, 0, self.bubbleArray[start].frame.size.width, self.bubbleArray[start].frame.size.height)
            temporaryBubble.layer.cornerRadius = tempBubbleCornerRadius
            }, completion: { (finished) -> Void in
                // Change the original bubble color and then remove the covering ones
                self.bubbleArray[start].backgroundColor = self.bubbleBackgroundColorForCompleted
                temporaryBubble.removeFromSuperview()
                labelView.removeFromSuperview()
                
                if start < numBubbleCompleted && start+1 < self.bubbleArray.count {
                    var newLine : UIView = UIView()
                    newLine.backgroundColor = self.lineColorForCompleted
                    newLine.frame = self.connectLineArray[start].frame
                    
                    // create the line with a frame collapsed in height to reach the edge of the bubble
                    if (self.bubbleAllignment == BubbleAllignment.Vertical) {
                        newLine.frame.size = CGSizeMake(newLine.frame.size.width, self.bubbleArray[start].frame.size.width / 2.0)
                    } else {
                        newLine.frame.size = CGSizeMake(self.bubbleArray[start].frame.size.width / 2.0, newLine.frame.size.height)
                    }
                    
                    newLine.frame.origin = CGPointMake(0, 0)
                    self.connectLineArray[start].addSubview(newLine)
                    
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        newLine.frame.size = self.connectLineArray[start].frame.size
                        }, completion: { (finished) -> Void in
                            // change the original line's color and then remove the covering one
                            self.connectLineArray[start].backgroundColor = self.lineColorForCompleted
                            newLine.removeFromSuperview()
                    })
                    
                    
                    // Do the same thing as we did for the other bubble
                    temporaryBubble = self.getBubbleView(frame, number: start + 2)
                    labelView = temporaryBubble.subviews[0] as UILabel
                    labelView.removeFromSuperview() // remove it so we can add it overtop of the new filling bubble
                    temporaryBubble.frame = newFrame
                    temporaryBubble.backgroundColor = self.bubbleBackgroundColorForNextToComplete
                    tempBubbleCornerRadius = temporaryBubble.layer.cornerRadius
                    temporaryBubble.layer.cornerRadius = 0.0
                    
                    self.bubbleArray[start+1].addSubview(temporaryBubble)
                    self.bubbleArray[start+1].addSubview(labelView)
                    
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        temporaryBubble.frame = CGRectMake(0, 0, self.bubbleArray[start+1].frame.size.width, self.bubbleArray[start+1].frame.size.height)
                        temporaryBubble.layer.cornerRadius = tempBubbleCornerRadius
                        }, completion: { (finished) -> Void in
                            self.bubbleArray[start+1].backgroundColor = self.bubbleBackgroundColorForNextToComplete
                            temporaryBubble.removeFromSuperview()
                            labelView.removeFromSuperview()
                            
                            if (start+1 < numBubbleCompleted) {
                                self.checkBubbleCompleted(numBubbleCompleted, start: self.lastBubbleCompleted++)
                            } else {
                                self.removeAnimatedBubbleFromQueueAndContinue()
                            }
                    })
                } else {
                    self.removeAnimatedBubbleFromQueueAndContinue()
                }
        })
        
    }

}
