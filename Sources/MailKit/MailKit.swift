import Foundation
import AppKit

public func send(emails NUMBER_OF_EMAILS: Int, to TARGET_NAME: String, at TARGET_EMAIL: String, withSubject EMAIL_SUBJECT: String, andContent EMAIL_CONTENT: String) {
    let MAIL_WAS_RUNNING = NSWorkspace.shared.runningApplications.filter({ $0.localizedName != nil }).map({ $0.localizedName! }).contains("Mail")
    for _ in 0..<NUMBER_OF_EMAILS {
        let a = NSAppleScript(source: """
            set recipientName to "\(TARGET_NAME)"
            set recipientAddress to "\(TARGET_EMAIL)"
            set theSubject to "\(EMAIL_SUBJECT)"
            set theContent to "\(EMAIL_CONTENT)"
            
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
