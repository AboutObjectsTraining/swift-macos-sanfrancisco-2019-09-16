// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa

class BackgroundView: NSView
{
    // override
    func XXXdraw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let path = NSBezierPath(rect: bounds)
        path.lineWidth = 10

        NSColor.systemBrown.setFill()
        dirtyRect.fill()
        path.stroke()
    }
}
