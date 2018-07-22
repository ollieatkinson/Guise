import XCTest
import Result

@testable import GuiseFramework

class RemoveCommentsTests: XCTestCase {
  
  func testStripComments() {
    
    let input = """
/// This is a doc comment for my structure
struct MyStructure {
  /// This is a doc comment for my property
  let property: String
}
"""
    
    let expected = """
struct MyStructure {
  let property: String
}
"""
    
    let systemUnderTest = RemoveComments()

    XCTAssertEqual(systemUnderTest.process(input: input).value, expected)
    
  }
  
  func testStripCommentsDoNotRemoveWhitespaceLines() {
    
    let input = """
/// This is a doc comment for my structure
struct MyStructure {

  /// This is a doc comment for my property
  let property: String

}
"""
    
    let expected = """
struct MyStructure {

  let property: String

}
"""
    
    let systemUnderTest = RemoveComments()
    
    XCTAssertEqual(systemUnderTest.process(input: input).value, expected)
    
  }
  
}
