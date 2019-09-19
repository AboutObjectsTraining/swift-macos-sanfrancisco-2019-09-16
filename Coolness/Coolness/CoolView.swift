// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa

class CoolView: NSView
{
    var color: NSColor = NSColor.systemPurple
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        color.setFill()
        dirtyRect.fill()
    }
    
    override func mouseDragged(with event: NSEvent) {
        frame = frame.offsetBy(dx: event.deltaX, dy: -event.deltaY)
    }
    
    override func mouseDown(with event: NSEvent) {
        alphaValue = 0.5
    }
    
    override func mouseUp(with event: NSEvent) {
        alphaValue = 1
    }
}
