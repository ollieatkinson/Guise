import Foundation

struct BuildArguments: Decodable {
  
  let configurationBuildDir: String
  let currentArch: String
  let phoneOSDeploymentTarget: String?
  let macOSDeploymentTarget: String?
  let productModuleName: String
  let projectDir: String
  let sdkDir: String
  let swiftPlatformTargetPrefix: String
  let toolchainDir: String
  
  var deploymentTarget: String {
    return phoneOSDeploymentTarget ?? macOSDeploymentTarget!
  }
  
  enum CodingKeys: String, CodingKey {
    case configurationBuildDir = "CONFIGURATION_BUILD_DIR"
    case currentArch = "CURRENT_ARCH"
    case phoneOSDeploymentTarget = "IPHONEOS_DEPLOYMENT_TARGET"
    case macOSDeploymentTarget = "MACOSX_DEPLOYMENT_TARGET"
    case productModuleName = "PRODUCT_MODULE_NAME"
    case projectDir = "PROJECT_DIR"
    case sdkDir = "SDK_DIR"
    case swiftPlatformTargetPrefix = "SWIFT_PLATFORM_TARGET_PREFIX"
    case toolchainDir = "TOOLCHAIN_DIR"
  }
  
}

struct BuildArgumentsExtractor {
  
  private let environment: [String : String]
  
  init(environment: [String : String] = ProcessInfo.processInfo.environment) {
    self.environment = environment
  }

  func makeBuildArguments() throws -> BuildArguments {
    return try JSONDecoder().decode(BuildArguments.self, from: JSONEncoder().encode(environment))
  }
  
}
