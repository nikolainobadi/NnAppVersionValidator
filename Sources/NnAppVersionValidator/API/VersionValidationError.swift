//
//  VersionValidationError.swift
//  
//
//  Created by Nikolai Nobadi on 4/29/23.
//

import Foundation

public enum VersionValidationError: Error {
    case missingNumber
    case invalidBundleId
    case missingDeviceVersionString
    case unableToFetchVersionFromAppStore
}

public extension VersionValidationError {
    var message: String {
        switch self {
        case .missingNumber: return "A number is missing from the version number, most likely due to a decoding error"
        case .invalidBundleId: return "The bundleId is not valid or was not provided"
        case .missingDeviceVersionString: return "The version number was unable to be decoded, either from the device or from Apple"
        case .unableToFetchVersionFromAppStore: return "A network error occured while attempting to fetch the version number from Apple"
        }
    }
}
