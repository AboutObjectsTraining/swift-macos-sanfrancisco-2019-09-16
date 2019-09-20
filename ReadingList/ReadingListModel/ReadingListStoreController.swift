//
// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import Foundation

/// Encapsulates the storage for serialized instances of `ReadingList`, and 
/// their nested `Book` and `Author` objects. Instances of these types are
/// serialized by obtaining dictionaries of their keys and values, and writing
/// the resulting dictionaries to the file system in plist format.
open class ReadingListStoreController : NSObject
{
    /// File extension of the store file
    public let storeType = "plist"
    /// Name of the store file
    @IBInspectable public let storeName: String
    /// A `ReadingList` instance initialized with the contents of the store file
    open lazy var fetchedReadingList: ReadingList = fetch()
    /// URL of the store file in the Documents directory.
    
    public let documentUrl: URL
    /// URL of the store file in the app bundle
    lazy var bundleUrl: URL? = Bundle(for: type(of: self)).url(forResource: self.storeName, withExtension: storeType)
    /// `true` if a file exists at the path defined by `documentUrl`
    lazy var documentExists: Bool = FileManager.default.fileExists(atPath: self.documentUrl.path)
    /// URL of the store file in either the Documents directory if it exists there, or the app bundle
    lazy var url: URL? = documentExists ? documentUrl : bundleUrl
    
    lazy var unableToLoadMessage: String = "Unable to load \(storeName) with \(storeType) at URL \(String(describing: self.url))"
    lazy var missingDocumentMessage: String = "Unable to locate \(storeName) in \(documentExists ? self.documentUrl.description : "app bundle")"
    
    public override init() {
        self.storeName = "ReadingList"
        documentUrl = FileManager.fileURLForDocument(name: storeName, type: storeType)
        super.init()
    }
    
    /// Initializes a store with the provided name.
    /// - Parameter storeName: Name of the store file
    public init(_ storeName: String) {
        self.storeName = storeName
        documentUrl = FileManager.fileURLForDocument(name: storeName, type: storeType)
        super.init()
    }
    
    /// Saves the provided reading list to a file in the Documents directory.
    /// - Parameter readingList: The instance of `ReadingList` to save
    open func save(readingList: ReadingList) {
        let dict = readingList.dictionaryRepresentation() as NSDictionary
        dict.write(to: documentUrl, atomically: true)
    }
    
    /// Returns an instance of `ReadingList` initialized with the contents of
    /// a plist file. Nested objects include an array of `Book` instances, each
    /// with a nested `Author`.
    /// - Returns: A fully populated `ReadingList`
    func fetch() -> ReadingList {
        guard let url = url else { fatalError(missingDocumentMessage) }
        guard let dict = NSDictionary(contentsOf: url) as? [String: AnyObject] else { fatalError(unableToLoadMessage) }
        return ReadingList(dictionary: dict) // Initializes graph of model objects
    }
}


extension FileManager
{
    /// Returns a file URL relative to the Documents directory of a file with
    /// the given name and type. Does not check whether the file exists.
    /// - Parameters:
    ///   - name: Name of the file (minus the extension)
    ///   - type: The file's type
    /// - Returns: A file URL
    public class func fileURLForDocument(name: String, type: String) -> URL {
        let documentsUrls = self.default.urls(for: SearchPathDirectory.documentDirectory,
                                              in: SearchPathDomainMask.userDomainMask)
        guard let fileURL = documentsUrls.first else { fatalError("Documents directory must exist.") }
        return fileURL.appendingPathComponent(name).appendingPathExtension(type)
    }
}
