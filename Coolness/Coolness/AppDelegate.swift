// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300), styleMask: [.closable, .resizable, .miniaturizable, .titled], backing: .buffered, defer: true)
        
        window.setFrameOrigin(NSPoint(x: 500, y: 300))
        window.setFrameAutosaveName("My Cool Window")
        
        window.backgroundColor = NSColor.systemGray
        window.alphaValue = 0.98
        window.title = "My Cool Window"
        
        window.orderFront(self)
    }
}

