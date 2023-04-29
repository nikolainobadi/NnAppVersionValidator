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
