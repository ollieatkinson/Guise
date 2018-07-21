import Foundation

struct RemoveComments: TextProcessor {

  func process(input: String) throws -> String {

    return input.split(separator: "\n").filter({ line in
      line.range(of: " *\\/\\/\\/", options: .regularExpression) == nil
    }).joined(separator: "\n")
    
  }
  
}
