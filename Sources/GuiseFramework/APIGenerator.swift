import Foundation
import SourceKittenFramework

protocol SourceKittenRequest {
  func send() throws -> [String: SourceKitRepresentable]
}

extension SourceKittenFramework.Request: SourceKittenRequest { }

struct APIGenerator {

  let buildArguments: BuildArguments
  
  init(buildArguments: BuildArguments) {
    self.buildArguments = buildArguments
  }
  
  var makeSourceKittenRequest: (_ yaml: String) -> SourceKittenRequest = { yaml in
    return Request.yamlRequest(yaml: yaml)
  }
  
  func generate() throws -> String {
    
    guard let toolchainIdentifier = NSDictionary(contentsOfFile: "\(buildArguments.toolchainDir)/ToolchainInfo.plist")?["Identifier"] as? String else {
      throw APIGeneratorError.failedToExtractToolchainIdentifier(plistPath: "\(buildArguments.toolchainDir)/ToolchainInfo.plist)")
    }
    
    let yaml = """
    key.request: source.request.editor.open.interface
    key.name: "\(NSUUID().uuidString)"
    key.compilerargs:
    - "-target"
    - "\(buildArguments.currentArch)-apple-\(buildArguments.swiftPlatformTargetPrefix)\(buildArguments.deploymentTarget)"
    - "-sdk"
    - "\(buildArguments.sdkDir)"
    - "-I"
    - "\(buildArguments.configurationBuildDir)"
    - "-F"
    - "\(buildArguments.configurationBuildDir)"
    - "-I"
    - "\(buildArguments.configurationBuildDir)/include"
    key.modulename: "\(buildArguments.productModuleName)"
    key.toolchains: [ "\(toolchainIdentifier)" ]
    key.synthesizedextensions: 1
    """
    
    guard let source = try makeSourceKittenRequest(yaml).send()["key.sourcetext"] as? String else {
      throw APIGeneratorError.noSourceTextGenerated
    }

    return source
    
  }
  
}
