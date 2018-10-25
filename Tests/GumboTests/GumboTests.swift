import XCTest
@testable import Gumbo

final class GumboTests: XCTestCase {
    func testExample() {
        
        let webpageURL = URL(string: "http://www.lemonde.fr")!
        let document = try! Document(url: webpageURL)
        print(document.allURLs(relativeTo: webpageURL).compactMap({ $0.absoluteURL }))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
