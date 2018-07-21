import Foundation
import SourceKittenFramework

struct APIGenerator {

  let buildArguments: BuildArguments
  
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
    
    guard let source = try Request.yamlRequest(yaml: yaml).send()["key.sourcetext"] as? String else {
      throw APIGeneratorError.noSourceTextGenerated
    }

    return source
    
  }
  
}
