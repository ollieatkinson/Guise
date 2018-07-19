import Commandant
import Result

struct GenerateCommand: CommandProtocol {
  
  public var verb: String {
    return "generate"
  }
  
  public var function: String {
    return "Generate API.swift `public-api-generator generate --output-file path/to/API.swift` default will write to $PROJECT_DIR/API.swift"
  }
  
  struct Options: OptionsProtocol {
    
    let path: String
    
    static func create(path: String) -> Options {
      return self.init(path: path)
    }
    
    static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<APIGeneratorError>> {
      
      let defaultValue: String
      
      if let PROJECT_DIR = try? BuildArgumentsExtractor().makeBuildArguments(processInfo: .processInfo).PROJECT_DIR {
        defaultValue = "\(PROJECT_DIR)/API.swift"
      } else {
        defaultValue = "API.swift"
      }
      
      return create
        <*> mode
        <| Option(key: "output-file", defaultValue: defaultValue, usage: "the output path to the API.swift file, defaults to $PROJECT_DIR/API.swift")
    }
  }
  
  /// Runs this subcommand with the given options.
  public func run(_ options: Options) -> Result<(), APIGeneratorError> {
    
    if options.path.isEmpty {
      return .failure(.invalidArgument(description: "path must be provided"))
    }
    
    /*-----------------------------------------------------------------------------------------
     // MARK: - Extract build environment variables
     -----------------------------------------------------------------------------------------*/
    
    let buildArguments: BuildArguments
    
    do {
      buildArguments = try BuildArgumentsExtractor().makeBuildArguments(processInfo: .processInfo)
    } catch let error {
      
      if let apiGeneratorError = error as? APIGeneratorError {
        return .failure(apiGeneratorError)
      } else {
        return .failure(.unexpectedError(error: error))
      }
      
    }
    
    /*-----------------------------------------------------------------------------------------
     // MARK: - Request interface from SourceKittenFramework using YAML
     -----------------------------------------------------------------------------------------*/
    
    let source: String
    
    do {
      source = try APIGenerator(buildArguments: buildArguments).generate()
    } catch let error {
      if let apiGeneratorError = error as? APIGeneratorError {
        return .failure(apiGeneratorError)
      } else {
        return .failure(.unexpectedError(error: error))
      }
    }
    
    do {
      try source.write(toFile: options.path, atomically: true, encoding: .utf8)
    } catch {
      return .failure(.failedToWrite(path: options.path, error: error))
    }

    return .success(())
    
  }
  
}
