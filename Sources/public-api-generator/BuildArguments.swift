import Foundation

struct BuildArguments {
  
  let CONFIGURATION_BUILD_DIR: String
  let CURRENT_ARCH: String
  let DEPLOYMENT_TARGET: String
  let PRODUCT_MODULE_NAME: String
  let PROJECT_DIR: String
  let SDK_DIR: String
  let SWIFT_PLATFORM_TARGET_PREFIX: String
  
  let toolchainIdentifier: String
  
}

struct BuildArgumentsExtractor {

  func makeBuildArguments(processInfo: ProcessInfo) throws -> BuildArguments {
    
    let env = processInfo.environment
    
    func environmentVariable(name: String) throws -> String {
      
      if let environmentVariable = env[name] {
        return environmentVariable
      } else {
        throw APIGeneratorError.buildArgumentRequired(name: name)
      }
      
    }
    
    let CONFIGURATION_BUILD_DIR      = try environmentVariable(name: "CONFIGURATION_BUILD_DIR")
    let CURRENT_ARCH                 = try environmentVariable(name: "CURRENT_ARCH")
    let PRODUCT_MODULE_NAME          = try environmentVariable(name: "PRODUCT_MODULE_NAME")
    let PROJECT_DIR                  = try environmentVariable(name: "PROJECT_DIR")
    let SDK_DIR                      = try environmentVariable(name: "SDK_DIR")
    let SWIFT_PLATFORM_TARGET_PREFIX = try environmentVariable(name: "SWIFT_PLATFORM_TARGET_PREFIX")
    let TOOLCHAIN_DIR                = try environmentVariable(name: "TOOLCHAIN_DIR")
    
    guard let DEPLOYMENT_TARGET = env["IPHONEOS_DEPLOYMENT_TARGET"] ?? env["MACOSX_DEPLOYMENT_TARGET"] else {
      throw APIGeneratorError.buildArgumentRequired(name: "IPHONEOS_DEPLOYMENT_TARGET or MACOSX_DEPLOYMENT_TARGET")
    }
    
    guard let toolchainIdentifier = NSDictionary(contentsOfFile: "\(TOOLCHAIN_DIR)/ToolchainInfo.plist")?["Identifier"] as? String else {
      throw APIGeneratorError.failedToExtractToolchainIdentifier(plistPath: "\(TOOLCHAIN_DIR)/ToolchainInfo.plist)")
    }
    
    return BuildArguments(
      CONFIGURATION_BUILD_DIR: CONFIGURATION_BUILD_DIR,
      CURRENT_ARCH: CURRENT_ARCH,
      DEPLOYMENT_TARGET: DEPLOYMENT_TARGET,
      PRODUCT_MODULE_NAME: PRODUCT_MODULE_NAME,
      PROJECT_DIR: PROJECT_DIR,
      SDK_DIR: SDK_DIR,
      SWIFT_PLATFORM_TARGET_PREFIX: SWIFT_PLATFORM_TARGET_PREFIX,
      toolchainIdentifier: toolchainIdentifier
    )
    
  }
  
}
