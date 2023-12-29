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
        
        return updateRequired(deviceVersion: deviceVersion, onlineVersion: onlineVersion)
    }
    
    func getAppVersionNumbers() async throws -> AppVersionNumberComparison {
        let deviceVersion = try await local.loadVersionNumber()
        let onlineVersion = try await remote.loadVersionNumber()
        
        return (deviceVersion, onlineVersion)
    }
}


// MARK: - Private
private extension VersionValidator {
    func updateRequired(deviceVersion: VersionNumber, onlineVersion: VersionNumber) -> Bool {
        let majorUpdate = deviceVersion.majorNum < onlineVersion.majorNum
        let minorUpdate = deviceVersion.minorNum < onlineVersion.minorNum
        let patchUpdate = deviceVersion.patchNum < onlineVersion.patchNum
        
        switch selectedVersionNumber {
        case .major: return majorUpdate
        case .minor: return majorUpdate || minorUpdate
        case .patch: return majorUpdate || minorUpdate || patchUpdate
        }
    }
}


// MARK: - Dependencies
internal protocol VersionNumberLoader {
    func loadVersionNumber() async throws -> VersionNumber
}
