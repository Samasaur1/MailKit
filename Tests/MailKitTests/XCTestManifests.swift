import XCTest

extension MailKitTests {
    static let __allTests = [
        ("testExample", testExample),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MailKitTests.__allTests),
    ]
}
#endif
