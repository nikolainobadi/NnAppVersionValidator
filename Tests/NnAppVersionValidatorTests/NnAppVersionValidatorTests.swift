import XCTest
@testable import NnAppVersionValidator

final class NnAppVersionValidatorTests: XCTestCase {
    func test_no_update_is_required_when_device_version_matches_online_version() async throws {
        let deviceVersion = makeVersionNumber()
        let onlineVersion = makeVersionNumber()
        let updateRequired = try await checkForUpdate(deviceVersion: deviceVersion, onlineVersion: onlineVersion)
        
        XCTAssertFalse(updateRequired)
    }
}


// MARK: - Checking for Major Changes
extension NnAppVersionValidatorTests {
    func test_no_update_required_when_checking_major_number_and_no_change_in_device_and_online_major_number() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersionList = [makeVersionNumber(1, 0, 1), makeVersionNumber(1, 1, 1)]
        
        for onlineVerison in onlineVersionList {
            try await assertUpdateNotRequired(deviceVersion: deviceVersion, onlineVersion: onlineVerison, versionType: .major)
        }
    }
    
    func test_update_is_required_when_major_number_increases() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersion = makeVersionNumber(2, 0, 0)
        
        try await assertUpdateRequired(deviceVersion: deviceVersion, onlineVersion: onlineVersion, versionType: .major)
    }
}

// MARK: - Checking for Minor Changes
extension NnAppVersionValidatorTests {
    func test_no_update_is_required_when_patch_number_increases_but_only_checking_for_major_and_minor_version_changes() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersion = makeVersionNumber(1, 0, 1)
        let sut = makeSUT(deviceVersion: deviceVersion, onlineVersion: onlineVersion, selectedVersionNumber: .minor)
        let updateRequired = try await sut.checkIfVersionUpdateIsRequired()
        
        XCTAssertFalse(updateRequired)
    }
    
    func test_update_is_required_when_major_or_minor_number_increments_when_checking_for_minor_version_changes() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersionList = [makeVersionNumber(1, 1, 1), makeVersionNumber(2, 0, 0)]
        
        for onlineVerison in onlineVersionList {
            try await assertUpdateRequired(deviceVersion: deviceVersion, onlineVersion: onlineVerison, versionType: .minor)
        }
    }
}


// MARK: - Checking for Patch Changes
extension NnAppVersionValidatorTests {
    func test_update_is_required_when_any_number_increments_when_checking_for_patch_version_changes() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersionList = [makeVersionNumber(1, 0, 1), makeVersionNumber(1, 1, 1), makeVersionNumber(2, 0, 0)]
        
        for onlineVersion in onlineVersionList {
            try await assertUpdateRequired(deviceVersion: deviceVersion, onlineVersion: onlineVersion, versionType: .patch)
        }
    }
}


// MARK: - Fetching VersionNumbers
extension NnAppVersionValidatorTests {
    func test_loads_device_version_and_online_version_for_comparison() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersion = makeVersionNumber(2, 0, 0)
        let sut = makeSUT(deviceVersion: deviceVersion, onlineVersion: onlineVersion, selectedVersionNumber: .minor)
        let comparison = try await sut.getAppVersionNumbers()
        
        XCTAssertEqual(comparison.deviceVersion, deviceVersion)
        XCTAssertEqual(comparison.appStoreVersion, onlineVersion)
    }
}


// MARK: - SUT
extension NnAppVersionValidatorTests {
    func makeSUT(deviceVersion: VersionNumber? = nil, onlineVersion: VersionNumber? = nil, selectedVersionNumber: VersionNumberType = .major, throwLocalError: Bool = false, throwRemoteError: Bool = false) -> VersionValidator {
        let localLoader = MockLoader(throwError: throwLocalError, versionNumber: deviceVersion ?? makeVersionNumber())
        let remoteLoader = MockLoader(throwError: throwRemoteError, versionNumber: onlineVersion ?? makeVersionNumber())
        
        return VersionValidator(local: localLoader, remote: remoteLoader, selectedVersionNumber: selectedVersionNumber)
    }
    
    func makeVersionNumber(_ major: Int = 1, _ minor: Int = 0, _ patch: Int = 0) -> VersionNumber {
        return .init(majorNum: major, minorNum: minor, patchNum: patch)
    }
}


// MARK: - Assetion Helpers
extension NnAppVersionValidatorTests {
    func checkForUpdate(deviceVersion: VersionNumber, onlineVersion: VersionNumber, versionType: VersionNumberType = .major) async throws -> Bool {
        let sut = makeSUT(deviceVersion: deviceVersion, onlineVersion: onlineVersion, selectedVersionNumber: versionType)
        
        return try await sut.checkIfVersionUpdateIsRequired()
    }
    
    func assertUpdateRequired(deviceVersion: VersionNumber, onlineVersion: VersionNumber, versionType: VersionNumberType, file: StaticString = #file, line: UInt = #line) async throws {
        let updateRequired = try await checkForUpdate(deviceVersion: deviceVersion, onlineVersion: onlineVersion, versionType: versionType)
        
        XCTAssertTrue(updateRequired, "Expected update to be required", file: file, line: line)
    }
    
    func assertUpdateNotRequired(deviceVersion: VersionNumber, onlineVersion: VersionNumber, versionType: VersionNumberType, file: StaticString = #file, line: UInt = #line) async throws {
        let updateRequired = try await checkForUpdate(deviceVersion: deviceVersion, onlineVersion: onlineVersion, versionType: versionType)
        
        XCTAssertFalse(updateRequired, "Expected update to NOT be required", file: file, line: line)
    }
}


// MARK: - Helper Classes
extension NnAppVersionValidatorTests {
    class MockLoader: VersionNumberLoader {
        private let throwError: Bool
        private let versionNumber: VersionNumber
        
        init(throwError: Bool, versionNumber: VersionNumber) {
            self.throwError = throwError
            self.versionNumber = versionNumber
        }
        
        func loadVersionNumber() async throws -> VersionNumber {
            if throwError { throw NSError(domain: "Test", code: 0) }
            
            return versionNumber
        }
    }
}
