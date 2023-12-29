//
//  VersionValidationInfo.swift
//
//
//  Created by Nikolai Nobadi on 12/29/23.
//

/// Contains information necessary for validating app version updates.
///
/// This struct is used to encapsulate the parameters required for checking app version updates. It includes the app's bundle ID,
/// a dictionary containing the app's version information, and the selected type of version number to be checked (major, minor, patch).
///
/// - Properties:
///   - bundleId: The unique identifier for the app. This is used to fetch the latest version number from the App Store.
///   - infoDictionary: A dictionary containing the local app's version information, typically obtained from the `Info.plist` file.
///   - selectedVersionNumber: Specifies the type of version update to check for (major, minor, patch).
///     The choice determines how stringently the version numbers are compared.
///
/// - Initialization:
///   - Parameters:
///     - bundleId: Optional. The bundle identifier of the app.
///     - infoDictionary: Optional. A dictionary with the app's version information.
///     - selectedVersionNumber: The type of version number to be checked. Defaults to `.major`.
///
public struct VersionValidationInfo {
    let bundleId: String?
    let infoDictionary: [String: Any]?
    let selectedVersionNumber: VersionNumberType
    
    public init(bundleId: String?, infoDictionary: [String: Any]?, selectedVersionNumber: VersionNumberType = .major) {
        self.bundleId = bundleId
        self.infoDictionary = infoDictionary
        self.selectedVersionNumber = selectedVersionNumber
    }
}
