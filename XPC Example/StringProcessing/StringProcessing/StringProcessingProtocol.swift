// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

public let StringProcessingServiceName = "com.aboutobjects.StringProcessing"

@objc public protocol StringProcessing {
    func uppercaseString(_ string: String, with reply: @escaping (String) -> Void)
}
