import Foundation
import AppKit

public func send(emails numberOfEmails: Int, to name: String, at email: String, withSubject subject: (_ emailNumber: Int) -> String, andContent content: (_ emailNumber: Int) -> String) {
    let MAIL_WAS_RUNNING = NSWorkspace.shared.runningApplications.filter({ $0.localizedName != nil }).map({ $0.localizedName! }).contains("Mail")
    for i in 0..<numberOfEmails {
        let a = NSAppleScript(source: """
            set recipientName to "\(name)"
            set recipientAddress to "\(email)"
            set theSubject to "\(subject(i))"
            set theContent to "\(content(i))"
            
            tell application "Mail"
            set theMessage to make new outgoing message with properties {subject:theSubject, content:theContent, visible:true}
            
            tell theMessage
            make new to recipient with properties {name:recipientName, address:recipientAddress}
            send
            end tell
            end tell
            """)!
        a.compileAndReturnError(nil)
        a.executeAndReturnError(nil)
    }
    if MAIL_WAS_RUNNING {
        let a = NSAppleScript(source: "tell app \"Mail\" to quit")!
        a.compileAndReturnError(nil)
        a.executeAndReturnError(nil)
    }
}
