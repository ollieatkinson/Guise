import Foundation
import SourceKittenFramework

struct APIGenerator {

  let buildArguments: BuildArguments
  
  func generate() throws -> String {
    
    let yaml = """
    key.request: source.request.editor.open.interface
    key.name: "\(NSUUID().uuidString)"
    key.compilerargs:
    - "-target"
    - "\(buildArguments.CURRENT_ARCH)-apple-\(buildArguments.SWIFT_PLATFORM_TARGET_PREFIX)\(buildArguments.DEPLOYMENT_TARGET)"
    - "-sdk"
    - "\(buildArguments.SDK_DIR)"
    - "-I"
    - "\(buildArguments.CONFIGURATION_BUILD_DIR)"
    - "-F"
    - "\(buildArguments.CONFIGURATION_BUILD_DIR)"
    - "-I"
    - "\(buildArguments.CONFIGURATION_BUILD_DIR)/include"
    key.modulename: "\(buildArguments.PRODUCT_MODULE_NAME)"
    key.toolchains: [ "\(buildArguments.toolchainIdentifier)" ]
    key.synthesizedextensions: 1
    """
    
    guard let source = try Request.yamlRequest(yaml: yaml).send()["key.sourcetext"] as? String else {
      throw APIGeneratorError.noSourceTextGenerated
    }

    return source
    
  }
  
}
