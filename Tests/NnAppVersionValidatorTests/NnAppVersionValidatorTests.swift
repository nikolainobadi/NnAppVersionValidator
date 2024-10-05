import XCTest
@testable import NnAppVersionValidator

final class NnAppVersionValidatorTests: XCTestCase {
    func test_checkIfVersionUpateIsRequired_noUpdateRequired() async throws {
        let updateRequired = try await makeSUT().checkIfVersionUpdateIsRequired()
        
        XCTAssertFalse(updateRequired)
    }
}


// MARK: - Checking for Major Changes
extension NnAppVersionValidatorTests {
    func test_checkIfVersionUpateIsRequired_checkingForMajor_patchChanged_noUpdateRequired() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersion = makeVersionNumber(1, 0, 1)
        let updateRequired = try await makeSUT(deviceVersion: deviceVersion, onlineVersion: onlineVersion).checkIfVersionUpdateIsRequired()
        
        XCTAssertFalse(updateRequired)
    }
    
    func test_checkIfVersionUpateIsRequired_checkingForMajor_minorChanged_noUpdateRequired() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersion = makeVersionNumber(1, 1, 1)
        let updateRequired = try await makeSUT(deviceVersion: deviceVersion, onlineVersion: onlineVersion).checkIfVersionUpdateIsRequired()
        
        XCTAssertFalse(updateRequired)
    }
    
    func test_checkIfVersionUpateIsRequired_checkingForMajor_majorChanged_updateRequired() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersion = makeVersionNumber(2, 0, 0)
        let updateRequired = try await makeSUT(deviceVersion: deviceVersion, onlineVersion: onlineVersion).checkIfVersionUpdateIsRequired()
        
        XCTAssertTrue(updateRequired)
    }
}

// MARK: - Checking for Minor Changes
extension NnAppVersionValidatorTests {
    func test_checkIfVersionUpateIsRequired_checkingForMinor_patchChanged_noUpdateRequired() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersion = makeVersionNumber(1, 0, 1)
        let sut = makeSUT(deviceVersion: deviceVersion, onlineVersion: onlineVersion, selectedVersionNumber: .minor)
        let updateRequired = try await sut.checkIfVersionUpdateIsRequired()
        
        XCTAssertFalse(updateRequired)
    }
    
    func test_checkIfVersionUpateIsRequired_checkingForMinor_minorChanged_noUpdateRequired() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersion = makeVersionNumber(1, 1, 1)
        let sut = makeSUT(deviceVersion: deviceVersion, onlineVersion: onlineVersion, selectedVersionNumber: .minor)
        let updateRequired = try await sut.checkIfVersionUpdateIsRequired()
        
        XCTAssertTrue(updateRequired)
    }
    
    func test_checkIfVersionUpateIsRequired_checkingForMinor_majorChanged_updateRequired() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersion = makeVersionNumber(2, 0, 0)
        let sut = makeSUT(deviceVersion: deviceVersion, onlineVersion: onlineVersion, selectedVersionNumber: .minor)
        let updateRequired = try await sut.checkIfVersionUpdateIsRequired()
        
        XCTAssertTrue(updateRequired)
    }
}


// MARK: - Checking for Patch Changes
extension NnAppVersionValidatorTests {
    func test_checkIfVersionUpateIsRequired_checkingForPatch_patchChanged_noUpdateRequired() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersion = makeVersionNumber(1, 0, 1)
        let sut = makeSUT(deviceVersion: deviceVersion, onlineVersion: onlineVersion, selectedVersionNumber: .patch)
        let updateRequired = try await sut.checkIfVersionUpdateIsRequired()
        
        XCTAssertTrue(updateRequired)
    }
    
    func test_checkIfVersionUpateIsRequired_checkingForPatch_minorChanged_noUpdateRequired() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersion = makeVersionNumber(1, 1, 1)
        let sut = makeSUT(deviceVersion: deviceVersion, onlineVersion: onlineVersion, selectedVersionNumber: .patch)
        let updateRequired = try await sut.checkIfVersionUpdateIsRequired()
        
        XCTAssertTrue(updateRequired)
    }
    
    func test_checkIfVersionUpateIsRequired_checkingForPatch_majorChanged_updateRequired() async throws {
        let deviceVersion = makeVersionNumber(1, 0, 0)
        let onlineVersion = makeVersionNumber(2, 0, 0)
        let sut = makeSUT(deviceVersion: deviceVersion, onlineVersion: onlineVersion, selectedVersionNumber: .minor)
        let updateRequired = try await sut.checkIfVersionUpdateIsRequired()
        
        XCTAssertTrue(updateRequired)
    }
}


// MARK: - Fetching VersionNumbers
extension NnAppVersionValidatorTests {
    func test_getAppVersionNumbers() async throws {
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


// MARK: - Helpers
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
