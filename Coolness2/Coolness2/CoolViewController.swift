// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa

class CoolViewController: NSViewController
{
    @IBOutlet var textField: NSTextField!
    @IBOutlet weak var box: NSBox!
    
    @IBOutlet weak var colorWell: NSColorWell!
    
    
    @IBAction func addCell(_ sender: NSButton) {
        NSLog("In \(#function)")
        let newCoolView = CoolView()
        
        newCoolView.text = textField.stringValue
        newCoolView.autoresizingMask = [.minYMargin]
        newCoolView.color = colorWell.color
        
        newCoolView.center = box.center
        
        box.addSubview(newCoolView)
    }
}


extension NSView
{
    var center: NSPoint {
        get {
            let x = frame.size.height / 2
            let y = frame.size.width / 2
            return NSPoint(x: x, y: y)
        }
        set {
            let x = newValue.x - center.x
            let y = newValue.y - center.y
            frame.origin = NSPoint(x: x, y: y)
        }
    }
}
