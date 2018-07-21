import Foundation
import Commandant

public struct Main {
  
  public static func execute() {
    
    let registry = CommandRegistry<APIGeneratorError>()
    
    registry.register(GenerateCommand())
    registry.register(VersionCommand())
    registry.register(HelpCommand(registry: registry))
    
    registry.main(defaultVerb: "help") { error in
      fputs("\(error)\n", stderr)
    }
    
  }
  
}
