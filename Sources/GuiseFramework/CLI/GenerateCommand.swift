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

    return extractBuildArguments()
      .flatMap(generateAPI)
      .flatMap(postGenerationTextProcessing(options: options))
      .flatMap(writeToFile(options: options))
    
  }
  
}

private extension GenerateCommand {
  
  func extractBuildArguments() -> Result<BuildArguments, APIGeneratorError> {
    return Result(try BuildArgumentsExtractor().makeBuildArguments()).mapError(APIGeneratorError.init(error:))
  }
  
  func generateAPI(_ buildArguments: BuildArguments) -> Result<String, APIGeneratorError> {
    return Result(try APIGenerator(buildArguments: buildArguments).generate()).mapError(APIGeneratorError.init(error:))
  }
  
  func postGenerationTextProcessing(options: Options) -> (_ source: String) -> Result<String, APIGeneratorError> {
    
    var textProcessors: [TextProcessor] = [
      RemoveSwiftOnoneSupport()
    ]
    
    if options.noDocumentation {
      textProcessors.append(RemoveComments())
    }
    
    return { source in
      Result(attempt: { try textProcessors.reduce(source, { try $1.process(input: $0) }) }).mapError({ .failedToWrite(path: options.path, error: $0) })
    }
  }
  
  func writeToFile(options: Options) -> (_ source: String) -> Result<Void, APIGeneratorError> {
    return { source in
      Result(attempt: { try source.write(toFile: options.path, atomically: true, encoding: .utf8) }).mapError({ .failedToWrite(path: options.path, error: $0) })
    }
  }
  
}
