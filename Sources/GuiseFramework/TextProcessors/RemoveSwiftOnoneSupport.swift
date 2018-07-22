import Result

struct RemoveSwiftOnoneSupport: TextProcessor {
  
  func process(input: String) -> Result<String, APIGeneratorError> {
    return .success(
      input.replacingOccurrences(of: "\nimport SwiftOnoneSupport", with: "")
           .replacingOccurrences(of: "import SwiftOnoneSupport\n", with: "")
    )
  }
  
}
