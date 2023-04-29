import Foundation

public func makeVersionValidator(infoDictionary: [String: Any]?, bundleId: String?, selectedVersionNumber: VersionNumberType = .major) -> NnVersionValidator {
    
    let localLoader = LocalVersionNumberLoader(infoDictionary: infoDictionary)
    let remoteLoader = RemoteVersionNumberLoader(bundleId: bundleId)
    
    return VersionValidator(local: localLoader, remote: remoteLoader, selectedVersionNumber: selectedVersionNumber)
}



public protocol NnVersionValidator {
    func checkIfVersionUpateIsRequired() async throws -> Bool
}







public enum VersionNumberType: Int {
    case major, minor, patch
}

enum VersionValidationError: Error {
    case missingNumber
    case invalidBundleId
    case missingDeviceVersionString
    case unableToFetchVersionFromAppStore
}
