// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa

class AddRemoveView: NSView
{
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        configureLayer()
    }
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        wantsLayer = true
        configureLayer()
    }
    
    private func configureLayer() {
        layer?.addSublayer(gradientLayer)
        layer?.borderWidth = 1
        layer?.borderColor = NSColor(named: "Gradient Border")?.cgColor
        gradientLayer.frame = bounds
        gradientLayer.frame.size.width += 1000
        gradientLayer.locations = [0, 0.5, 1]
    }
    
    override func updateLayer() {
        NSLog("In \(#function)")
        guard let endColor = NSColor(named: "Gradient End")?.cgColor,
            let midColor = NSColor(named: "Gradient Mid")?.cgColor,
            let startColor = NSColor(named: "Gradient Start")?.cgColor
            else { return }
        gradientLayer.colors = [endColor, midColor, startColor]
    }
}
