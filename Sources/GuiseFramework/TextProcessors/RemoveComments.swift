import Foundation

struct RemoveComments: TextProcessor {

  func process(input: String) throws -> String {

    return input
      .split(separator: "\n", omittingEmptySubsequences: false)
      .filter { $0.range(of: " *\\/{3}", options: .regularExpression) == nil }
      .joined(separator: "\n")
    
  }
  
}
