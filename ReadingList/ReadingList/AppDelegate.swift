// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    @IBOutlet var mainWindowController: MainWindowController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Bundle.main.loadNibNamed("MainWindow", owner: self, topLevelObjects: nil)
        mainWindowController.showWindow(nil)
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        guard let window = mainWindowController.window, window.isDocumentEdited else { return .terminateNow }
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "There are unsaved changes. Really quit?"
        
        alert.addButton(withTitle: "Save and Quit")
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Quit")
        
        let response: NSApplication.ModalResponse = alert.runModal()
        switch response {
        case .alertFirstButtonReturn:
            mainWindowController.saveReadingList(self)
            return .terminateNow
        case .alertSecondButtonReturn:
            return .terminateCancel
        default:
            return .terminateNow
        }
    }
    
    @IBAction func showMainWindow(_ sender: Any) {
        mainWindowController.showWindow(nil)
    }
}

extension AppDelegate: NSUserInterfaceValidations
{
    func validateUserInterfaceItem(_ item: NSValidatedUserInterfaceItem) -> Bool {
        guard let selector = item.action, let window = mainWindowController.window else { return true }
        switch selector {
        case #selector(showMainWindow(_:)): return !window.isVisible
        default: return true
        }
    }
}
