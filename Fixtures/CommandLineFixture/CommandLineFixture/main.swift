import Foundation

public struct PublicStruct {
  /// Some docs
  public   let publicProperty: String
  /// Some docs
  internal let internalProperty: String
  /// Some docs
  private  let privateProperty: String
  
  /// Some docs
  public func publicFunc() {}
  /// Some docs
  internal func internalFunc() {}
  /// Some docs
  private func privateFunc() {}
}

internal struct InternalStruct {
  internal let internalProperty: String
  private  let privateProperty: String
  
  internal func internalFunc() {}
  private func privateFunc() {}
}

private struct PrivateStruct {
  private  let privateProperty: String
  
  private func privateFunc() {}
}
