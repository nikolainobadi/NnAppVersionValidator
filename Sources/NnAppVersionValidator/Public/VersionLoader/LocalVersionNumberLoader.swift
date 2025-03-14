//
//  LocalVersionNumberLoader.swift
//
//
//  Created by Nikolai Nobadi on 4/29/23.
//

import Foundation

/// A class responsible for loading the app version number from the local device.
/// This loader reads version-related information from the app's `Info.plist` file,
/// typically using `Bundle.main.infoDictionary`, specifically targeting the `CFBundleShortVersionString`
/// to retrieve the current app version.
///
/// The class can optionally return both the version and build number in debug mode for
/// more detailed versioning information.
//public final class LocalVersionNumberLoader {
//    // A dictionary containing app metadata, such as version information, from the app's `Info.plist` file.
//    // This should be typically retrieved from `Bundle.main.infoDictionary`.
//    private let infoDictionary: [String: Any]?
//
//    // Identifier key for fetching the app version string from `Info.plist`.
//    private let versionStringId = "CFBundleShortVersionString"
//    
//    /// Initializes the loader with the app's version information.
//    ///
//    /// - Parameter infoDictionary: A dictionary containing metadata from the app's `Info.plist` file.
//    public init(infoDictionary: [String: Any]?) {
//        self.infoDictionary = infoDictionary
//    }
//}

public final class LocalVersionNumberLoader {
    private let versionNumber: String?
    private let buildNumber: String?
    
    public init(infoDictionary: [String: Any]?) {
        self.versionNumber = nil
        self.buildNumber = nil
    }
}


// MARK: - VersionNumberString Loader
public extension LocalVersionNumberLoader {
    /// Loads the app's version details in a human-readable format.
    ///
    /// - Returns: A string representing the app version. If the app is running in debug mode,
    ///            the string will also include the build number.
    ///
    /// - Example: "Version 1.0.0, Build: 1" (in debug mode)
    ///            "Version 1.0.0" (in release mode)
    func loadDeviceVersionDetails() -> String {
        // Attempts to retrieve the version number from the infoDictionary.
        guard let versionNumber else {
            return "" // Returns an empty string if the version number is missing.
        }
        
        let versionString = "Version \(versionNumber)"
        
        #if DEBUG
        // In debug mode, attempt to retrieve the build number and append it to the version string.
        guard let buildNumber else {
            return versionString
        }
        
        return "\(versionString), Build: \(buildNumber)"
        #else
        // In release mode, only return the version string.
        return versionString
        #endif
    }
}


// MARK: - Loader
extension LocalVersionNumberLoader: VersionNumberLoader {
    /// Asynchronously loads the app's version number from the `Info.plist` file.
    ///
    /// - Throws: `VersionValidationError.missingDeviceVersionString` if the version number cannot be found.
    ///
    /// - Returns: A `VersionNumber` struct representing the app's semantic version number.
    func loadVersionNumber() async throws -> VersionNumber {
        // Retrieve the version string from the infoDictionary, or throw an error if not found.
        guard let versionNumber else {
            throw VersionValidationError.missingDeviceVersionString
        }

        // Maps the version string to a `VersionNumber` object using the VersionNumberMapper utility.
        return try VersionNumberMapper.map(versionNumber)
    }
}
