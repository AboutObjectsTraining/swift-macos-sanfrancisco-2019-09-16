// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa

private let defaultInset: CGFloat = 20
private var contentInsets: NSEdgeInsets { return NSEdgeInsets(top: defaultInset, left: defaultInset, bottom: defaultInset, right: defaultInset) }

extension NSRect
{
    func inset(edgeInsets: NSEdgeInsets) -> NSRect {
        return insetBy(dx: edgeInsets.left, dy: edgeInsets.top)
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300), styleMask: [.closable, .resizable, .miniaturizable, .titled], backing: .buffered, defer: true)
        
        window.setFrameOrigin(NSPoint(x: 500, y: 300))
        window.setFrameAutosaveName("My Cool Window")
        window.title = "My Cool Window"
        
        loadContentView()
        
        window.orderFront(self)
    }
    
    func loadContentView() {
        guard let frameRect = window.contentView?.frame else { return }
        let backgroundView = BackgroundView(frame: frameRect)
        window.contentView?.addSubview(backgroundView)
        
        backgroundView.autoresizingMask = [.height, .width]
        
        let box = NSBox(frame: backgroundView.bounds.inset(edgeInsets: contentInsets))
        backgroundView.addSubview(box);
        box.title = "Cool Views"
        
        let top = Int(box.bounds.size.height)
        let subview1 = CoolView(frame: NSRect(x: 20, y: top - 80, width: 180, height: 40))
        let subview2 = CoolView(frame: NSRect(x: 60, y: top - 140, width: 180, height: 40))
        box.addSubview(subview1)
        box.addSubview(subview2)
        
        subview2.color = NSColor.systemOrange
        
        let coolViewMask: NSView.AutoresizingMask = [.minYMargin]
        subview1.autoresizingMask = coolViewMask
        subview2.autoresizingMask = coolViewMask
        box.autoresizingMask = backgroundView.autoresizingMask
    }
}

