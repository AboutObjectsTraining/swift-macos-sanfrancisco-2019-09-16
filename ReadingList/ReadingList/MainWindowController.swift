// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa

private struct CloseWindowAlertText {
    static let message = NSLocalizedString("The reading list has unsaved changes. Do you want to save them now?",
                                           comment: "Close window alert message text")
    static let informative = NSLocalizedString("Values in one or more books in the reading list have been edited. You can save the changes now, or cancel to continue editing.",
                                               comment: "Close window alert informative text")
    struct ButtonTitle {
        static let save = NSLocalizedString("Save", comment: "Close window alert save button title")
        static let cancel = NSLocalizedString("Cancel", comment: "Close window alert cancel button title")
    }
}

extension NSNib.Name {
    static let mainWindow = "MainWindow"
}

class MainWindowController: NSWindowController
{
    @IBOutlet var editBookController: EditBookController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        window?.isExcludedFromWindowsMenu = true
    }
}

// MARK: - Action methods
extension MainWindowController
{
    @objc func applicationWillTerminate(_ notification: Notification) {
        guard let window = window else { return }
        let _ = windowShouldClose(window)
    }
    
    @IBAction func saveReadingList(_ sender: Any) {
        editBookController.saveButton.performClick(self)
    }
    
    @IBAction func nextBook(_ sender: Any) {
        editBookController.nextButton.performClick(self)
    }
    
    @IBAction func previousBook(_ sender: Any) {
        editBookController.prevButton.performClick(self)
    }
}

// MARK: - Validating menu items
extension MainWindowController: NSUserInterfaceValidations
{
    func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        guard let selector = item.action, let window = window else { return true }
        switch selector {
        case #selector(nextBook(_:)):        return window.isVisible && editBookController.hasNext
        case #selector(previousBook(_:)):    return window.isVisible && editBookController.hasPrevious
        case #selector(saveReadingList(_:)): return window.isVisible && window.isDocumentEdited
        default:                             return true
        }
    }
}


// MARK: - Window delegate methods
extension MainWindowController: NSWindowDelegate
{
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        OperationQueue.main.addOperation {
            NSApp.windowsMenu?.update()
        }
        
        guard let window = window, window.isDocumentEdited else {
            return true
        }
        
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = CloseWindowAlertText.message
        alert.informativeText = CloseWindowAlertText.informative
        
        alert.addButton(withTitle: CloseWindowAlertText.ButtonTitle.save)
        alert.addButton(withTitle: CloseWindowAlertText.ButtonTitle.cancel)
        
        let response = alert.runModal()
        if response != .alertFirstButtonReturn { return false }
        saveReadingList(self)
        return true
    }
}
