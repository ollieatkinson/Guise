struct RemoveSwiftOnoneSupport: TextProcessor {
  
  func process(input: String) throws -> String {
    return input
      .replacingOccurrences(of: "\nimport SwiftOnoneSupport", with: "")
      .replacingOccurrences(of: "import SwiftOnoneSupport\n", with: "")
  }
  
}
