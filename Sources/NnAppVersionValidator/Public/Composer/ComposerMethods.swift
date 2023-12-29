//
//  NnVersionValidator.swift
//
//
//  Created by Nikolai Nobadi on 12/29/23.
//

/// Creates an instance of `NnVersionValidator`.
///
/// This method initializes a version validator to compare the local app version with the version available on the App Store.
/// It uses both local and remote sources to determine if a new app version is available based on the selected update type (major, minor, or patch).
///
/// - Parameters:
///   - infoDictionary: A dictionary containing the local app's version information, typically from the `Info.plist` file.
///   - bundleId: The unique identifier for the app, used to fetch the latest version number from the App Store.
///   - selectedVersionNumber: The type of version update to check for. It determines how the version numbers are compared.
///     - `.major`: Checks for updates in the major version number (e.g., 1.x.x to 2.x.x).
///     - `.minor`: Checks for updates in the major or minor version number (e.g., 1.1.x to 1.2.x or 2.x.x).
///     - `.patch`: Checks for updates in any part of the version number (e.g., 1.1.1 to 1.1.2).
///
/// - Returns: An instance of `NnVersionValidator` configured with the specified parameters.
///
public func makeVersionValidator(infoDictionary: [String: Any]?, bundleId: String?, selectedVersionNumber: VersionNumberType = .major) -> NnVersionValidator {
    let localLoader = LocalVersionNumberLoader(infoDictionary: infoDictionary)
    let remoteLoader = RemoteVersionNumberLoader(bundleId: bundleId)
    
    return VersionValidator(local: localLoader, remote: remoteLoader, selectedVersionNumber: selectedVersionNumber)
}

/// Creates an instance of `NnVersionValidator` using a `VersionValidationInfo` struct.
///
/// This method offers a convenient way to initialize a version validator by passing a `VersionValidationInfo` struct.
/// It delegates the creation of the `NnVersionValidator` to the first `makeVersionValidator` method by extracting
/// the necessary parameters from the `VersionValidationInfo` struct.
///
/// The method simplifies the process of validator creation, especially when the parameters required for version validation
/// are already grouped together in the `VersionValidationInfo` struct.
///
/// - Parameter info: A `VersionValidationInfo` struct containing the necessary information for version validation.
///   - `infoDictionary`: A dictionary containing the local app's version information.
///   - `bundleId`: The unique identifier for the app.
///   - `selectedVersionNumber`: The type of version update to check for.
///
/// - Returns: An instance of `NnVersionValidator` configured with the parameters provided in the `VersionValidationInfo` struct.
///
public func makeVersionValidator(info: VersionValidationInfo) -> NnVersionValidator {
    return makeVersionValidator(infoDictionary: info.infoDictionary, bundleId: info.bundleId, selectedVersionNumber: info.selectedVersionNumber)
}

