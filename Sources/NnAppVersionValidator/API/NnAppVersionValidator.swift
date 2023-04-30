import Foundation

/// Method will return bool based on whether App Version on Device is lower than App Version on AppStore
public protocol NnVersionValidator {
    typealias AppVersionNumberComparison = (deviceVersion: VersionNumber, appStoreVersion: VersionNumber)
    
    func checkIfVersionUpateIsRequired() async throws -> Bool
    func getAppVersionNumbers() async throws -> AppVersionNumberComparison
}

/// Composer method to create NnVersionValidator object
/// infoDictionary is used to parse app version number on device
/// bundleId is used to make network request to Apple to fetch AppStore version number
/// selectedVersionNumber allows you to choose which type of update to check
///  - example Version number: 2.3.4
///     - .major: returns true if first number in VersionNumber has changed
///     - .minor: returns true if first OR second number in VersionNumber has changed
///     - .patch: returns true if any number in the VersionNumber has changed
public func makeVersionValidator(infoDictionary: [String: Any]?, bundleId: String?, selectedVersionNumber: VersionNumberType = .major) -> NnVersionValidator {
    let localLoader = LocalVersionNumberLoader(infoDictionary: infoDictionary)
    let remoteLoader = RemoteVersionNumberLoader(bundleId: bundleId)
    
    return VersionValidator(local: localLoader, remote: remoteLoader, selectedVersionNumber: selectedVersionNumber)
}
