// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa

private let textInsets = NSEdgeInsets(top: 7, left: 12, bottom: 8, right: 12)
private let textOrigin = NSPoint(x: 12, y: 8)

@IBDesignable
class CoolView: NSView
{
    @IBInspectable var color: NSColor = NSColor.systemPurple
    @IBInspectable var text: String = "" {
        didSet {
            sizeToFit()
            setNeedsDisplay(bounds)
        }
    }
    
    
    class var textAttributes: [NSAttributedString.Key: Any] {
        return [.font: NSFont.boldSystemFont(ofSize: 20),
                .foregroundColor: NSColor.white]
    }
    
//    override var wantsUpdateLayer: Bool { return true }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configure()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        configure()
    }
    
    private func configure() {
        wantsLayer = true
        updateLayer()
        let recognizer = NSClickGestureRecognizer(target: self, action: #selector(bounce(_:)))
        recognizer.numberOfClicksRequired = 2
        addGestureRecognizer(recognizer)
    }
    
    @objc private func bounce(_ sender: Any) {
        NSLog("In \(#function)")
        NSAnimationContext.current.allowsImplicitAnimation = true
        NSAnimationContext.current.duration = 1
        frame = frame.offsetBy(dx: 100, dy: -100)
        frameRotation += -90
    }
    
    private func sizeToFit() {
        var newSize = (text as NSString).size(withAttributes: type(of: self).textAttributes)
        newSize.width += textInsets.left + textInsets.right
        newSize.height += textInsets.top + textInsets.bottom
        setFrameSize(newSize)
    }
    
    override func updateLayer() {
        layer?.borderWidth = 3
        layer?.borderColor = NSColor.white.cgColor
        layer?.cornerRadius = 10
    }
    
    override func prepareForInterfaceBuilder() {
        updateLayer()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        color.setFill()
        dirtyRect.fill()
        (text as NSString).draw(at: textOrigin, withAttributes: type(of: self).textAttributes)
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
