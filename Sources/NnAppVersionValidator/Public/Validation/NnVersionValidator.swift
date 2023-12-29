//
//  NnVersionValidator.swift
//  
//
//  Created by Nikolai Nobadi on 12/29/23.
//

/// Protocol defining the behavior for validating app version updates.
///
/// This protocol provides methods to determine if an app version update is required by comparing the device's app version
/// with the version available on the App Store. It also allows fetching the device and App Store app version numbers for manual comparison.
///
/// - Methods:
///   - checkIfVersionUpdateIsRequired: Asynchronously determines if the app version on the device is lower than the version on the App Store.
///       - Returns: A Boolean value (`true` if an update is required, `false` otherwise).
///   - getAppVersionNumbers: Asynchronously retrieves the app version numbers from the device and the App Store.
///       - Returns: A tuple (`AppVersionNumberComparison`) containing the device's version number and the App Store's version number.
///
public protocol NnVersionValidator {
    typealias AppVersionNumberComparison = (deviceVersion: VersionNumber, appStoreVersion: VersionNumber)
    
    func checkIfVersionUpdateIsRequired() async throws -> Bool
    func getAppVersionNumbers() async throws -> AppVersionNumberComparison
}
