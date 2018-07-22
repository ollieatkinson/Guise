import Commandant
import Result

struct VersionCommand: CommandProtocol {

  public var verb: String {
    return "version"
  }

  public var function: String {
    return "Display the current version of guise"
  }
  
  /// Runs this subcommand with the given options.
  public func run(_ options: NoOptions<APIGeneratorError>) -> Result<(), APIGeneratorError> {
    print(Version)
    return .success(())
  }
  
}
