// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa

class FancyImageView: NSImageView
{
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configureLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayer()
    }
    
    func configureLayer() {
        wantsLayer = true
        layer?.masksToBounds = true
        layer?.cornerRadius = 15
        layer?.borderWidth = 5
        layer?.borderColor = NSColor(named: "Image Border")?.cgColor
    }
}
