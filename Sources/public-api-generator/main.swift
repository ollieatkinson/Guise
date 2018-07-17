import Foundation
import SourceKittenFramework

/*-----------------------------------------------------------------------------------------
// MARK: - Extract build environment variables
-----------------------------------------------------------------------------------------*/

let env = ProcessInfo.processInfo.environment

func environmentVariable(name: String) -> String {
  
  if let environmentVariable = env[name] {
    return environmentVariable
  } else {
    fatalError("\(name) is required to be set")
  }
  
}

let CONFIGURATION_BUILD_DIR      = environmentVariable(name: "CONFIGURATION_BUILD_DIR") 
let CURRENT_ARCH                 = environmentVariable(name: "CURRENT_ARCH")
let PRODUCT_MODULE_NAME          = environmentVariable(name: "PRODUCT_MODULE_NAME")
let PROJECT_DIR                  = environmentVariable(name: "PROJECT_DIR")
let SDK_DIR                      = environmentVariable(name: "SDK_DIR")
let SWIFT_PLATFORM_TARGET_PREFIX = environmentVariable(name: "SWIFT_PLATFORM_TARGET_PREFIX")
let TOOLCHAIN_DIR                = environmentVariable(name: "TOOLCHAIN_DIR")

guard let DEPLOYMENT_TARGET = env["IPHONEOS_DEPLOYMENT_TARGET"] ?? env["MACOSX_DEPLOYMENT_TARGET"] else {
   fatalError("IPHONEOS_DEPLOYMENT_TARGET or MACOSX_DEPLOYMENT_TARGET is required to be set")
}

guard let toolchainIdentifier = NSDictionary(contentsOfFile: "\(TOOLCHAIN_DIR)/ToolchainInfo.plist")?["Identifier"] else {
    fatalError("Couldn't read Identifier from \(TOOLCHAIN_DIR)/ToolchainInfo.plist)")
}

/*-----------------------------------------------------------------------------------------
// MARK: - Request interface from SourceKittenFramework using YAML
-----------------------------------------------------------------------------------------*/

let yaml = """
key.request: source.request.editor.open.interface
key.name: "\(NSUUID().uuidString)"
key.compilerargs:
    - "-target"
    - "\(CURRENT_ARCH)-apple-\(SWIFT_PLATFORM_TARGET_PREFIX)\(DEPLOYMENT_TARGET)"
    - "-sdk"
    - "\(SDK_DIR)"
    - "-I"
    - "\(CONFIGURATION_BUILD_DIR)"
    - "-F"
    - "\(CONFIGURATION_BUILD_DIR)"
    - "-I"
    - "\(CONFIGURATION_BUILD_DIR)/include"
key.modulename: "\(PRODUCT_MODULE_NAME)"
key.toolchains: [ "\(toolchainIdentifier)" ]
key.synthesizedextensions: 1
"""

guard let source = try Request.yamlRequest(yaml: yaml).send()["key.sourcetext"] as? String else {
    fatalError("No source text in sourcekitten response")
}

/*-----------------------------------------------------------------------------------------
// MARK: - Write to file
-----------------------------------------------------------------------------------------*/

do {
    try source.write(toFile: "\(PROJECT_DIR)/API.swift", atomically: true, encoding: .utf8)
} catch {
    fatalError("Failed to write to \"\(PROJECT_DIR)/API.swift\" \(error)")
}