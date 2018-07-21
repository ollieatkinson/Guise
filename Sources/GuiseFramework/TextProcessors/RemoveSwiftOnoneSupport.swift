struct RemoveSwiftOnoneSupport: TextProcessor {
  
  func process(input: String) throws -> String {
    return input.replacingOccurrences(of: "\nimport SwiftOnoneSupport", with: "")
  }
  
}
