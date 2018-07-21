import XCTest
@testable import GuiseFramework

class RemoveCommentsTests: XCTestCase {
  
  func testStripComments() throws {
    
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
    
    XCTAssertEqual(try systemUnderTest.process(input: input), expected)
    
  }
  
  func testStripCommentsDoNotRemoveWhitespaceLines() throws {
    
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
    
    XCTAssertEqual(try systemUnderTest.process(input: input), expected)
    
  }
  
}
