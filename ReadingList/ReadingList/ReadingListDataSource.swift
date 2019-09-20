// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa
import ReadingListModel

private let defaultStoreFilename = "ReadingList"

class ReadingListDataSource: NSObject
{
    var storeFilename = defaultStoreFilename
    lazy var storeController: ReadingListStoreController = ReadingListStoreController(storeFilename)
    lazy var readingList: ReadingList = storeController.fetchedReadingList
    lazy var currentBook: Book? = readingList.book(at: 0)
    
    var index: Int {
        get {
            guard let currentBook = currentBook else { return 0 }
            return readingList.index(of: currentBook)
        }
        set {
            currentBook = readingList.book(at: newValue)
        }
    }
    
    var lastIndex: Int { return readingList.count - 1 }
    var nextIndex: Int { return index + (index == lastIndex ? 0 : 1) }
    var prevIndex: Int { return index - (index == 0 ? 0 : 1) }
    
    var hasNext: Bool { return index < lastIndex }
    var hasPrevious: Bool { return index > 0}
    
    var booksCount: Int { return readingList.books.count }
    
    var nextBook: Book? {
        currentBook = readingList.book(at: nextIndex)
        return currentBook
    }
    var previousBook: Book? {
        currentBook = readingList.book(at: prevIndex)
        return currentBook
    }
    
    func book(at index: Int) -> Book {
        return readingList.book(at: index)
    }
    
    func insert(book: Book, at index: Int) {
        readingList.insert(book: book, at: index)
    }
    
    @discardableResult
    func insertNewBook() -> Book {
        let newBook = Book(dictionary: [Book.Keys.author: [:]])
        insert(book: newBook, at: 0)
        currentBook = book(at: 0)
        return newBook
    }
    
    func save() {
        storeController.save(readingList: readingList)
    }
}

extension ReadingListDataSource: NSTableViewDataSource
{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return readingList.books.count
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        readingList.sortBooks(using: tableView.sortDescriptors)
        tableView.reloadData()
        tableView.selectRowIndexes([0], byExtendingSelection: false)
    }
}

extension Author
{
    var image: NSImage? {
        return NSImage(named: lastName ?? "Default")
    }
}
