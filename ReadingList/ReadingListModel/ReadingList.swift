//
// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import Foundation

open class ReadingList: ModelObject
{
    public struct Keys {
        public static let title = #selector(getter: ReadingList.title).description
        public static let books = #selector(getter: ReadingList.books).description
        static var all: [String] { return [title, books] }
    }
    
    @objc open var title = ""
    @objc open var books = [Book]()
    
    open override var description: String {
        var s = "Title: \(title)\nCount: \(books.count)\nBooks:\n------\n"
        for (index, book) in books.enumerated() {
            s += "\(index + 1). \(book)\n"
        }
        return s
    }
    
    open override class var keys: [String] {
        return Keys.all
    }
    
    open override func setValue(_ value: Any?, forKey key: String) {
        var books: [Book]?
        if key == Keys.books, let dicts = value as? [JsonDictionary] {
            books = dicts.map { Book(dictionary: $0) }
        }
        super.setValue(books ?? value, forKey: key)
    }
    
    open override func dictionaryRepresentation() -> JsonDictionary {
        var dict = super.dictionaryRepresentation()
        if let books = dict[Keys.books] as? [ModelObject] {
            dict[Keys.books] = books.map { $0.dictionaryRepresentation() }
        }
        return dict
    }
}

// MARK: - Books array accessors

extension ReadingList
{
    open var count: Int { return books.count }
    open func index(of book: Book) -> Int { return books.firstIndex(of: book) ?? 0 }
    open func book(at index: Int) -> Book { return books[index] }
    open func insert(book: Book, at index: Int) { books.insert(book, at: index) }
    open func removeBook(at index: Int) { books.remove(at: index) }
    
    open func sortBooks(using descriptors:[NSSortDescriptor]) {
        guard let sortedBooks = (books as NSArray).sortedArray(using: descriptors) as? [Book] else {
            return
        }
        books = sortedBooks
    }
}
