enum APIGeneratorError: Error, CustomStringConvertible {
  
  case noSourceTextGenerated
  case buildArgumentRequired(name: String)
  case failedToExtractToolchainIdentifier(plistPath: String)
  case invalidArgument(description: String)
  case failedToWrite(path: String, error: Error)
  case unexpectedError(error: Error)
  
  var description: String {
    
    switch self {
    case .noSourceTextGenerated:
      return "No source text in sourcekitten response"
    case .buildArgumentRequired(name: let name):
      return "\(name) is required to be set"
    case .failedToExtractToolchainIdentifier(plistPath: let plistPath):
      return "Couldn't read Identifier from \(plistPath)"
    case .unexpectedError(error: let error):
      return "Unexpected error \(error)"
    case .failedToWrite(path: let path, error: let error):
      return "Failed to write to \"\(path)\" \(error)"
    case .invalidArgument(let description):
      return description
    }
    
  }
  
}
