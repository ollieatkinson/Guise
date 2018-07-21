import XCTest
@testable import GuiseFramework

class RemoveSwiftOnoneSupportTests: XCTestCase {
  
  func testRemoveIfPresentAtTop() throws {
    
    let systemUnderTest = RemoveSwiftOnoneSupport()
    
    XCTAssertEqual(try systemUnderTest.process(input: "import SwiftOnoneSupport\nimport Foundation"), "import Foundation", "SwiftOnoneSupport should be removed, but it was not.")
    
  }
  
  func testRemoveIfPresentInMiddle() throws {
    
    let systemUnderTest = RemoveSwiftOnoneSupport()
    
    XCTAssertEqual(try systemUnderTest.process(input: "import GuiseFramework\nimport SwiftOnoneSupport\nimport Foundation"), "import GuiseFramework\nimport Foundation", "SwiftOnoneSupport should be removed, but it was not.")
    
  }
  
  func testDoNotModifyIfNotPresent() throws {
    
    let systemUnderTest = RemoveSwiftOnoneSupport()
    
    XCTAssertEqual(try systemUnderTest.process(input: "import GuiseFramework\nimport Foundation"), "import GuiseFramework\nimport Foundation", "The input should not be modified, but it was.")
    
  }
    
}
