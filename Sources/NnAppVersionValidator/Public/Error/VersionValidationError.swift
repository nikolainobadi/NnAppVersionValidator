//
//  VersionValidationError.swift
//  
//
//  Created by Nikolai Nobadi on 4/29/23.
//

import Foundation

/// Enumerates errors that can occur during the version validation process.
///
/// This enum provides a set of possible errors that can be encountered when validating app versions,
/// such as issues with the version number, bundle ID, or network errors while fetching information from the App Store.
///
/// - Cases:
///   - missingNumber: Indicates a missing component in the version number. This typically occurs due to a decoding error.
///   - invalidBundleId: Signifies that the bundle ID is invalid or was not provided.
///   - missingDeviceVersionString: Occurs when the app's version number cannot be decoded, either from the device or from Apple's App Store.
///   - unableToFetchVersionFromAppStore: Represents a network error that occurred while attempting to fetch the version number from Apple's App Store.
///
public enum VersionValidationError: Error {
    case missingURL
    case missingNumber
    case invalidBundleId
    case invalidVersionInfo(URL)
    case missingDeviceVersionString
    case unableToFetchVersionFromAppStore
}

public extension VersionValidationError {
    /// Provides a user-friendly description of the version validation error.
    ///
    /// This computed property returns a string message detailing the nature of the error encountered.
    /// The message aids in understanding the error for debugging or user feedback purposes.
    ///
    /// - Returns: A string describing the error.
    var message: String {
        switch self {
        case .missingURL:
            return "No custom URL was found"
        case .missingNumber:
            return "A number is missing from the version number, most likely due to a decoding error"
        case .invalidBundleId:
            return "The bundleId is not valid or was not provided"
        case .invalidVersionInfo(let url):
            return "Unable to decode version info at url path: \(url.path)"
        case .missingDeviceVersionString:
            return "The version number was unable to be decoded, either from the device or from Apple"
        case .unableToFetchVersionFromAppStore:
            return "A network error occured while attempting to fetch the version number from Apple"
        }
    }
}
