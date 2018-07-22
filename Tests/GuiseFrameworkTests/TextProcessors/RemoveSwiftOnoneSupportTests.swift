import XCTest
import Result

@testable import GuiseFramework

class RemoveSwiftOnoneSupportTests: XCTestCase {
  
  func testRemoveIfPresentAtTop() {
    
    let systemUnderTest = RemoveSwiftOnoneSupport()
    
    let result = systemUnderTest.process(input: "import SwiftOnoneSupport\nimport Foundation")
    
    XCTAssertEqual(result.value, "import Foundation", "SwiftOnoneSupport should be removed, but it was not.")
    
  }
  
  func testRemoveIfPresentInMiddle() {
    
    let systemUnderTest = RemoveSwiftOnoneSupport()
    
    let result = systemUnderTest.process(input: "import GuiseFramework\nimport SwiftOnoneSupport\nimport Foundation")

    XCTAssertEqual(result.value, "import GuiseFramework\nimport Foundation", "SwiftOnoneSupport should be removed, but it was not.")

  }
  
  func testDoNotModifyIfNotPresent() {
    
    let systemUnderTest = RemoveSwiftOnoneSupport()
    
    let result = systemUnderTest.process(input: "import GuiseFramework\nimport Foundation")

    XCTAssertEqual(result.value, "import GuiseFramework\nimport Foundation", "The input should not be modified, but it was.")

  }
    
}
