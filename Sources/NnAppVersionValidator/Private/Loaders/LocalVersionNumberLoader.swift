//
//  LocalVersionNumberLoader.swift
//  
//
//  Created by Nikolai Nobadi on 4/29/23.
//

import Foundation

internal final class LocalVersionNumberLoader {
    private let infoDictonary: [String: Any]?
    private let versionStringId = "CFBundleShortVersionString"
    
    init(infoDictionary: [String: Any]?) {
        self.infoDictonary = infoDictionary
    }
}


// MARK: - Loader
extension LocalVersionNumberLoader: VersionNumberLoader {
    func loadVersionNumber() async throws -> VersionNumber {
        guard let deviceVersionString = infoDictonary?[versionStringId] as? String else {
            throw VersionValidationError.missingDeviceVersionString
        }

        return try VersionNumberMapper.map(deviceVersionString)
    }
}
