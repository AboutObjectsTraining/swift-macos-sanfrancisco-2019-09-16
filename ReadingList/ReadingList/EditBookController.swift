// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa
import ReadingListModel

private let nextTitle = "Next"
private let prevTitle = "Previous"
private let saveTitle = "Save"

struct ToolbarLabels {
    static let showSidebar = "Show Sidebar"
    static let hideSidebar = "Hide Sidebar"
}

class EditBookController: NSViewController
{
    @IBOutlet var dataSource: ReadingListDataSource!
    @IBOutlet weak var splitView: NSSplitView!
    @IBOutlet weak var detailView: NSView!
    @IBOutlet var tableView: NSTableView!
    @IBOutlet weak var tableScrollView: NSScrollView!
    
    lazy var book = dataSource.currentBook
    var hasNext: Bool { return dataSource.hasNext }
    var hasPrevious: Bool { return dataSource.hasPrevious }
    
    @IBOutlet var titleField: NSTextField!
    @IBOutlet var yearField: NSTextField!
    @IBOutlet var firstNameField: NSTextField!
    @IBOutlet var lastNameField: NSTextField!
    
    @IBOutlet weak var authorImageView: NSImageView!
    @IBOutlet weak var favoriteCheckbox: NSButtonCell!
    @IBOutlet weak var heartLabel: NSTextField!
    @IBOutlet weak var booksCount: NSTextField!

    @IBOutlet var nextButton: NSButton!
    @IBOutlet var prevButton: NSButton!
    @IBOutlet var saveButton: NSButton!
    
    var isSplitViewCollapsed: Bool {
        guard let window = view.window else { return false }
        return window.frame.size.width == splitViewCollapsedWidth
    }
    var splitViewCollapsedWidth: CGFloat { return detailView.frame.size.width + 1 }
    var splitViewExpandedWidth: CGFloat { return splitViewCollapsedWidth + 300 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.window?.title = dataSource.readingList.title
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(notification:)),
                                               name: NSControl.textDidChangeNotification,
                                               object: nil)
    }
    
    @objc func textDidChange(notification: Notification) {
        setEdited(true)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        populateFields()
        validateButtons()
        view.animator()
    }
    
    private func validateButtons() {
        guard let window = view.window else { return }
        saveButton.isEnabled = window.isDocumentEdited
        prevButton.isEnabled = dataSource.hasPrevious
        nextButton.isEnabled = dataSource.hasNext
    }
    
    private func populateFields() {
        titleField.stringValue = book?.title ?? ""
        yearField.stringValue  = book?.year ?? ""
        firstNameField.stringValue = book?.author?.firstName ?? ""
        lastNameField.stringValue  = book?.author?.lastName ?? ""
        
        authorImageView.image = book?.author?.image
        favoriteCheckbox.state = book?.favorite == true ? .on : .off
        
        heartLabel.wantsLayer = true
        tableView.selectRowIndexes([dataSource.index], byExtendingSelection: false)
        booksCount.stringValue = "\(dataSource.index + 1) of \(dataSource.booksCount.description)"
        
        validateButtons()
    }
    
    private func updateBook() {
        book?.title = titleField.stringValue
        book?.year = yearField.stringValue
        book?.author?.firstName = firstNameField.stringValue
        book?.author?.lastName = lastNameField.stringValue
        
        book?.favorite = favoriteCheckbox.state == .on
    }
    
    private func setEdited(_ isEdited: Bool) {
        view.window?.isDocumentEdited = isEdited
        validateButtons()
    }
    
    @IBAction func showSidebar(_ sender: NSToolbarItem) {
        sender.label = isSplitViewCollapsed ? ToolbarLabels.showSidebar : ToolbarLabels.hideSidebar
        let newWidth = isSplitViewCollapsed ? splitViewExpandedWidth : splitViewCollapsedWidth
        animateShowSidebar(duration: 1, newWidth: newWidth)
    }
    
    func animateShowSidebar(duration: TimeInterval, newWidth: CGFloat) {
        guard let window = view.window else { return }
        var newFrame = window.frame
        newFrame.size.width = newWidth
        
        NSAnimationContext.current.allowsImplicitAnimation = true
        NSAnimationContext.current.duration = 0.3
        window.setFrame(newFrame, display: true)
    }
    
    @IBAction func addRow(_ sender: Any) {
        dataSource.insertNewBook()
        tableView.insertRows(at: [0], withAnimation: .effectFade)
        populateFields()
    }
    
    @IBAction func next(_ sender: Any) {
        updateBook()
        book = dataSource.nextBook
        populateFields()
    }
    
    @IBAction func previous(_ sender: Any) {
        updateBook()
        book = dataSource.previousBook
        populateFields()
    }
    
    @IBAction func save(_ sender: Any) {
        updateBook()
        dataSource.save()
        tableView.reloadData()
        setEdited(false)
    }
    
    @IBAction func toggleFavorite(_ sender: Any) {
        setEdited(true)
        if favoriteCheckbox.state == .on { animateFavorite() }
    }
    
    func animateFavorite() {
        guard let layer = heartLabel.animator().layer else { return }
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        NSAnimationContext.current.allowsImplicitAnimation = true
        NSAnimationContext.current.duration = 3
        NSAnimationContext.current.completionHandler = {
            layer.setAffineTransform(.identity)
        }
        layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 800))
    }
}

private struct CellIdentifiers {
    static let title = NSUserInterfaceItemIdentifier("Title")
    static let author = NSUserInterfaceItemIdentifier("Author")
}

extension EditBookController: NSTableViewDelegate
{
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard
            let identifier = tableColumn?.identifier,
            let cell = tableView.makeView(withIdentifier: identifier, owner: nil) as? NSTableCellView else { return nil }
        
        let book = dataSource.book(at: row)
        let value: String?
        
        switch identifier {
        case CellIdentifiers.title:  value = book.title
        case CellIdentifiers.author: value = book.author?.fullName
        default: value = nil
        }
        
        cell.textField?.stringValue = value ?? ""
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let index = tableView.selectedRow < 0 ? 0 : tableView.selectedRow
        dataSource.index = index
        book = dataSource.currentBook
        populateFields()
        validateButtons()
    }
}

