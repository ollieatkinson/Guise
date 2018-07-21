import XCTest
@testable import GuiseFramework

class RemoveSwiftOnoneSupportTests: XCTestCase {
  
  func testRemoveIfPresent() throws {
    
    let systemUnderTest = RemoveSwiftOnoneSupport()
    
    XCTAssertEqual(try systemUnderTest.process(input: "\nimport SwiftOnoneSupport\nimport Foundation"), "\nimport Foundation", "SwiftOnoneSupport should be removed, but it was not.")
    
  }
  
  func testDoNotModifyIfNotPresent() throws {
    
    let systemUnderTest = RemoveSwiftOnoneSupport()
    
    XCTAssertEqual(try systemUnderTest.process(input: "\nimport GuiseFramework\nimport Foundation"), "\nimport GuiseFramework\nimport Foundation", "The input should not be modified, but it was.")
    
  }
    
}
