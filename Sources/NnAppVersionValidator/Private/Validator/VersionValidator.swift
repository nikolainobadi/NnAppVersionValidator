//
//  VersionValidator.swift
//  
//
//  Created by Nikolai Nobadi on 4/29/23.
//

import Foundation

internal final class VersionValidator {
    private let local: VersionNumberLoader
    private let remote: VersionNumberLoader
    private let selectedVersionNumber: VersionNumberType
    
    init(local: VersionNumberLoader, remote: VersionNumberLoader, selectedVersionNumber: VersionNumberType) {
        self.local = local
        self.remote = remote
        self.selectedVersionNumber = selectedVersionNumber
    }
}


// MARK: - Validator
extension VersionValidator: NnVersionValidator {
    func checkIfVersionUpdateIsRequired() async throws -> Bool {
        let deviceVersion = try await local.loadVersionNumber()
        let onlineVersion = try await remote.loadVersionNumber()
        
        return VersionComparisonHandler.updateRequired(deviceVersion: deviceVersion, onlineVersion: onlineVersion, selectedVersionNumber: selectedVersionNumber)
    }
    
    func getAppVersionNumbers() async throws -> AppVersionNumberComparison {
        let deviceVersion = try await local.loadVersionNumber()
        let onlineVersion = try await remote.loadVersionNumber()
        
        return (deviceVersion, onlineVersion)
    }
}


// MARK: - Dependencies
internal protocol VersionNumberLoader {
    func loadVersionNumber() async throws -> VersionNumber
}
