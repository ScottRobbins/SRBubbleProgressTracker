# SRBubbleProgressTracker
A view to display progress throughout a series of functions in your app. Animates bubbles filling in with your designated colors at the ease of a few lines of code. (Written in Swift)

![Bubble Progress Tracker in action](/SRBubbleProgressTracker/SRBubbleProgressTracker.gif?raw=true "Bubble Progress Tracker in action")

##Install Easiest with CocoaPods
Put this in your 'podfile' in the root directory:
<pre>
    platform :ios, '8.0'
    pod 'SRBubbleProgressTracker', :git => 'https://github.com/ssrobbi/SRBubbleProgressTracker.git'
</pre>

Then run:
<pre>
    $pod install
</pre>
___________________________
##Add View to Storyboard
Start Out by adding a view to your Storyboard/Nib (the view can also be instantiated in code), and setting it to the custom "SRBubbleProgressTracker.swift" class.
![Add Custom Class](/SRBubbleProgressTracker/SetCustomClass.png?raw=true "Add Custom Class")

##Import the Module
Inside of the file you want to use the SRBubbleProgressTrackerView you will have to import the module:
<pre>
    import SRBubbleProgressTracker
</pre>

##Set an outlet to that view
<pre>
    @IBOutlet weak var bubbleTrackerView: SRBubbleProgressTrackerView!
</pre>

##Setup the view
setup the view passing in the Number of Dots, Dot Diameter, To allign Vertical or Horizontal, (Optional)An array of views to display to the left or top, (optional) an array of views to display to the right or bottom.
This should be placed AFTER auto-layout has layed out all of the subviews, because size is calculated by the view's frame. 

<pre>
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if bubbleTrackerViewIsSetup { return } // Needed so when called again for animation it doesn't redraw
        var leftLabels = getLabelArray(5, direction: "Left") // returns UILabels
        var rightLabels = getLabelArray(5, direction: "Right")
        
        // Will place bubbles in the center of the view
        bubbleTrackerView.setupInitialBubbleProgressTrackerView(5, dotDiameter: 75.0, allign: .Vertical, leftOrTopViews: leftLabels, rightOrBottomViews: rightLabels)
        bubbleTrackerViewIsSetup = true
    }
</pre>

##Animate Bubbles to Completed
To animate to your desired bubble, pass the integer for the bubble selected (index starting at 1) I have a lastButtonSelected variable that holds the last bubble I have selected so that I could easily move to the next.
<pre>
  @IBAction func nextButtonPressed(sender: UIButton) {
        lastButtonSelected++ 
        bubbleTrackerView.bubbleCompleted(lastButtonSelected) // lastButtonSelected is int of bubble to fill with completed color
    }
</pre>

_______________
#Customization

##Manipulate Colors
To manipulate colors, change the properties of the colors before calling OR Changing them in interface builder <code>setupInitialBubbleProgressTrackerView(...)</code>

You can manipulate:
<pre>
    var lineColorForNotCompleted : UIColor                  = .grayColor()
    var lineColorForCompleted : UIColor                     = .greenColor()
    var bubbleBackgroundColorForNotCompleted : UIColor      = .grayColor()
    var bubbleBackgroundColorForCompleted : UIColor         = .greenColor()
    var bubbleBackgroundColorForNextToComplete : UIColor    = .orangeColor()
    var bubbleTextColorForNotCompleted : UIColor            = .whiteColor()
    var bubbleTextColorForCompleted : UIColor               = .whiteColor()
    var bubbleTextColorForNextToComplete : UIColor          = .whiteColor()
</pre>
