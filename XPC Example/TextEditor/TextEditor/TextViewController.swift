// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Cocoa
import StringProcessing

class TextViewController: NSViewController
{
    let xpcConnection = NSXPCConnection(serviceName: StringProcessingServiceName)
    var xpcErrorHandler: ((Error) -> Void)?
    var stringProcessor: StringProcessing?
    
    @IBOutlet var textView: NSTextView!
    
    deinit {
        xpcConnection.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xpcConnection.remoteObjectInterface = NSXPCInterface(with: StringProcessing.self)
        xpcConnection.resume()
        
        xpcConnection.interruptionHandler = {
            // Handle interruption
        }
        xpcConnection.invalidationHandler = {
            // Handle invalidation
        }
        
        xpcErrorHandler = { error in
            OperationQueue.main.addOperation {
                let alert = NSAlert(error: error)
                alert.runModal()
            }
        }
        
        guard
            let errorHandler = xpcErrorHandler,
            let xpcService = xpcConnection.remoteObjectProxyWithErrorHandler(errorHandler) as? StringProcessing
            else {
                assertionFailure("Unable to set up XPC connection to \(xpcConnection)")
                return
        }
        
        stringProcessor = xpcService
    }
    
    @IBAction func uppercase(_ sender: Any?) {
        stringProcessor?.uppercaseString(textView.string) { [weak self] reply in
            OperationQueue.main.addOperation { self?.textView.string = reply }
        }
    }
}
