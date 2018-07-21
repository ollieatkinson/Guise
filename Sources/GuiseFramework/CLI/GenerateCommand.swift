import Foundation
import Commandant
import Result
import SourceKittenFramework

struct GenerateCommand: CommandProtocol {
  
  public var verb: String {
    return "generate"
  }
  
  public var function: String {
    return "Generate API.swift"
  }
  
  struct Options: OptionsProtocol {
    
    let path: String
    let noDocumentation: Bool
    
    static func create(path: String) -> (_ noDocumentation: Bool) -> Options {
      return { noDocumentation in
        return self.init(path: path, noDocumentation: noDocumentation)
      }
    }
    
    static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<APIGeneratorError>> {
      
      let defaultValue: String
      
      if let projectDir = try? BuildArgumentsExtractor().makeBuildArguments().projectDir {
        defaultValue = "\(projectDir)/API.swift"
      } else {
        defaultValue = "API.swift"
      }
      
      return create
        <*> mode <| Option(key: "output-file", defaultValue: defaultValue, usage: "the output path to the API.swift file, defaults to $PROJECT_DIR/API.swift")
        <*> mode <| Option(key: "no-documentation", defaultValue: false, usage: "omit the documentation from the API.swift file")
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
      buildArguments = try BuildArgumentsExtractor().makeBuildArguments()
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
    
    var source: String
    
    do {
      source = try APIGenerator(buildArguments: buildArguments).generate()
    } catch let error {
      if let apiGeneratorError = error as? APIGeneratorError {
        return .failure(apiGeneratorError)
      } else {
        return .failure(.unexpectedError(error: error))
      }
    }
    
    
    var textProcessors: [TextProcessor] = [
      RemoveSwiftOnoneSupport()
    ]
    
    if options.noDocumentation {
      textProcessors.append(RemoveComments())
    }
    
    do {
      source = try textProcessors.reduce(source, { try $1.process(input: $0) })
    } catch {
      return .failure(.unexpectedError(error: error))
    }
    
    do {
      try source.write(toFile: options.path, atomically: true, encoding: .utf8)
    } catch {
      return .failure(.failedToWrite(path: options.path, error: error))
    }

    return .success(())
    
  }
  
}
