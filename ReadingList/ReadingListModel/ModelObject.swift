//
// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import Foundation

public typealias JsonDictionary = [String: Any]

open class ModelObject: NSObject
{
    open class var keys: [String] { return [] }
    
    public required init(dictionary: JsonDictionary) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
    
    open func dictionaryRepresentation() -> JsonDictionary {
        return self.dictionaryWithValues(forKeys: type(of: self).keys) as [String : Any]
    }
}
