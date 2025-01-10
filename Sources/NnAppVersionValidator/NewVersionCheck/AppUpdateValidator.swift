//
//  AppUpdateValidator.swift
//  
//
//  Created by Nikolai Nobadi on 1/9/25.
//

import Foundation

final class AppUpdateValidator {
    private let url: URL?
    private let localLoader: VersionNumberLoader
    private let infoLoader: AppUpdateInfoProvider
    private let selectedVersionNumber: VersionNumberType
    
    init(url: URL?, localLoader: VersionNumberLoader, infoLoader: AppUpdateInfoProvider, selectedVersionNumber: VersionNumberType) {
        self.url = url
        self.localLoader = localLoader
        self.infoLoader = infoLoader
        self.selectedVersionNumber = selectedVersionNumber
    }
}


// MARK: - AppUpdateValidationService
extension AppUpdateValidator: AppUpdateValidationService {
    func fetchAvailableUpdate() async throws -> AppUpdateInfo? {
        let deviceVersion = try await localLoader.loadVersionNumber()
        let versionInfo = try await infoLoader.loadVersionInfo(url: url)
        
        guard VersionComparisonHandler.updateRequired(deviceVersion: deviceVersion, onlineVersion: versionInfo.version, selectedVersionNumber: selectedVersionNumber) else {
            return nil
        }
        
        return versionInfo
    }
}


// MARK: - Dependencies
protocol AppUpdateInfoProvider {
    func loadVersionInfo(url: URL?) async throws -> AppUpdateInfo
}
