import XCTest
@testable import GuiseFramework

final class BuildArgumentTests: XCTestCase {

  let environment = [
    "CONFIGURATION_BUILD_DIR": "1",
    "CURRENT_ARCH": "2",
    "PRODUCT_MODULE_NAME": "3",
    "PROJECT_DIR": "4",
    "SDK_DIR": "5",
    "SWIFT_PLATFORM_TARGET_PREFIX": "6",
    "IPHONEOS_DEPLOYMENT_TARGET": "7",
    "MACOSX_DEPLOYMENT_TARGET": "8",
    "TOOLCHAIN_DIR": "9",
  ]
  
  func testDecodeSuccess() throws {

    let extractor = BuildArgumentsExtractor(environment: environment)
    
    let buildArguments = try extractor.makeBuildArguments()
    
    XCTAssertEqual(buildArguments.configurationBuildDir, "1")
    XCTAssertEqual(buildArguments.currentArch, "2")
    XCTAssertEqual(buildArguments.productModuleName, "3")
    XCTAssertEqual(buildArguments.projectDir, "4")
    XCTAssertEqual(buildArguments.sdkDir, "5")
    XCTAssertEqual(buildArguments.swiftPlatformTargetPrefix, "6")
    XCTAssertEqual(buildArguments.phoneOSDeploymentTarget, "7")
    XCTAssertEqual(buildArguments.macOSDeploymentTarget, "8")
    XCTAssertEqual(buildArguments.toolchainDir, "9")
    
  }
  
  func testDecodeDefaultPhoneDeployment() throws {
    
    let extractor = BuildArgumentsExtractor(environment: environment)
    
    let buildArguments = try extractor.makeBuildArguments()
    
    XCTAssertEqual(buildArguments.deploymentTarget, "7")
    
  }
  
  func testDecodeNoPhoneDeploymentFallbackToMacOS() throws {
    
    var environmentWithNoPhoneDeploymentTarget = environment
    environmentWithNoPhoneDeploymentTarget.removeValue(forKey: "IPHONEOS_DEPLOYMENT_TARGET")
    
    let extractor = BuildArgumentsExtractor(environment: environmentWithNoPhoneDeploymentTarget)
    
    let buildArguments = try extractor.makeBuildArguments()
    
    XCTAssertEqual(buildArguments.deploymentTarget, "8")
    
  }
  
  func testDecodeThrowsBuildArgumentRequired() throws {
    
    var environmentWithNoConfigurationBuildDir = environment
    environmentWithNoConfigurationBuildDir.removeValue(forKey: "CONFIGURATION_BUILD_DIR")
    
    let extractor = BuildArgumentsExtractor(environment: environmentWithNoConfigurationBuildDir)
    
    XCTAssertThrowsError(try extractor.makeBuildArguments()) { error in
      guard case .buildArgumentRequired(name: let missingArgument)? = error as? APIGeneratorError else {
        return XCTFail("Expecting APIGenerator.buildArgumentRequired(name:) error.")
      }
      
      XCTAssertEqual(missingArgument, "CONFIGURATION_BUILD_DIR")
    }
    
  }
  
  func testDecodeThrowsBuildArgumentRequiredForMissingDeploymentTarget() throws {
    
    var environmentWithNoDeploymentTarget = environment
    environmentWithNoDeploymentTarget.removeValue(forKey: "IPHONEOS_DEPLOYMENT_TARGET")
    environmentWithNoDeploymentTarget.removeValue(forKey: "MACOSX_DEPLOYMENT_TARGET")
    
    let extractor = BuildArgumentsExtractor(environment: environmentWithNoDeploymentTarget)
    
    XCTAssertThrowsError(try extractor.makeBuildArguments()) { error in
      guard case .buildArgumentRequired(name: let missingArgument)? = error as? APIGeneratorError else {
        return XCTFail("Expecting APIGenerator.buildArgumentRequired(name:) error.")
      }
      
      XCTAssertEqual(missingArgument, "IPHONEOS_DEPLOYMENT_TARGET or MACOSX_DEPLOYMENT_TARGET")
    }
    
  }

}
