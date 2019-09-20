// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa

class KeyButton: NSButton
{
    override var canBecomeKeyView: Bool { return true }
}
