import Foundation
import AppKit

public class Mailer {
    public init() {}
    public var senderEmail: String? = nil
    public var targetEmail: String? = nil
    public var numberOfEmails: Int? = nil
    public var targetName: String? = nil
    public var subject: ((_ emailNumber: Int) -> String)? = nil
    public var subjectString: String? {
        get {
            if let subject = subject {
                return subject(0)
            }
            return nil
        }
        set {
            if let val = newValue {
                subject = { _ in val }
            } else {
                subject = nil
            }
        }
    }
    public var content: ((_ emailNumber: Int) -> String)? = nil
    public var contentString: String? {
        get {
            if let content = content {
                return content(0)
            }
            return nil
        }
        set {
            if let val = newValue {
                content = { _ in val }
            } else {
                content = nil
            }
        }
    }
    
    public func send(emails numberOfEmails: Int, to name: String, at email: String, withSubject subject: (_ emailNumber: Int) -> String, andContent content: (_ emailNumber: Int) -> String) throws {
        for i in 0..<numberOfEmails {
            let a = NSAppleScript(source: """
                set recipientName to "\(name)"
                set recipientAddress to "\(email)"
                set theSubject to "\(subject(i).replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\""))"
                set theContent to "\(content(i).replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\""))"
                
                tell application "Mail"
                set theMessage to make new outgoing message with properties {subject:theSubject, content:theContent, visible:true}
                
                tell theMessage
                make new to recipient with properties {name:recipientName, address:recipientAddress}
                send
                end tell
                end tell
                """)!
            var error: NSDictionary? = nil
            a.compileAndReturnError(&error)
            if let error = error {
                throw Error.AppleScriptCompilation(info: error)
            }
            error = nil
            a.executeAndReturnError(&error)
            if let error = error {
                throw Error.AppleScriptExecution(info: error)
            }
        }
    }
    
    public func send(emails numberOfEmails: Int? = nil, to name: String? = nil, at email: String? = nil, withSubject subject: ((_ emailNumber: Int) -> String)? = nil, andContent content: ((_ emailNumber: Int) -> String)? = nil) throws {
        guard let numberOfEmails = (numberOfEmails ?? self.numberOfEmails), let name = (name ?? self.targetName), let email = (email ?? self.targetEmail), let subject = (subject ?? self.subject), let content = (content ?? self.content) else {
            throw Error.NotConfiured
        }
        try send(emails: numberOfEmails, to: name, at: email, withSubject: subject, andContent: content)
    }
    
    enum Error: Swift.Error {
        case NotConfiured
        case AppleScriptCompilation(info: NSDictionary)
        case AppleScriptExecution(info: NSDictionary)
    }
}
