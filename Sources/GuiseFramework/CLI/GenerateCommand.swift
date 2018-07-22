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
    
    let noDocumentation: Bool
    
    static func create(noDocumentation: Bool) -> Options {
      return .init(noDocumentation: noDocumentation)
    }
    
    static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<APIGeneratorError>> {

      return create
        <*> mode <| Option(key: "no-documentation", defaultValue: false, usage: "omit the documentation from the API.swift file")
    }
  }
  
  /// Runs this subcommand with the given options.
  public func run(_ options: Options) -> Result<(), APIGeneratorError> {

    return extractBuildArguments()
      .flatMap(generateAPI)
      .flatMap(postGenerationTextProcessing(options: options))
      .flatMap(printToStdout)
    
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
      return textProcessors.reduce(.success(source)) { result, textProcessor in
        return result.flatMap(textProcessor.process(input:))
      }
    }
    
  }
  
  func printToStdout(source: String) -> Result<Void, APIGeneratorError> {
    if fputs(source, stdout) == EOF {
      return .failure(.failedToPrint)
    } else {
      return .success(())
    }
  }
  
}
