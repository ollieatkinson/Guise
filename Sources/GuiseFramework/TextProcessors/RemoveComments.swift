import Foundation
import Result

struct RemoveComments: TextProcessor {

  func process(input: String) -> Result<String, APIGeneratorError> {

    return .success(
      input.split(separator: "\n", omittingEmptySubsequences: false)
           .filter { $0.range(of: " *\\/{3}", options: .regularExpression) == nil }
           .joined(separator: "\n")
    )
    
  }
  
}
