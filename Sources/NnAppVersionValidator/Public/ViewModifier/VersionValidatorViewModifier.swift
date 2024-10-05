//
//  VersionValidatorViewModifier.swift
//
//
//  Created by Nikolai Nobadi on 10/4/24.
//

import SwiftUI

/// A custom `ViewModifier` that checks whether a version update is required based on the app's current version and a remote version.
/// If an update is required, the specified `updateView` will be displayed; otherwise, the main content will be shown.
///
/// This modifier runs a version validation check asynchronously and updates the view based on the result.
///
/// - Parameters:
///   - UpdateView: A SwiftUI `View` that will be displayed if an update is required.
///   - bundle: The `Bundle` from which the app's version information will be retrieved (typically `Bundle.main`).
///   - selectedVersionNumber: The type of version change to check for (major, minor, patch).
///   - updateView: A closure that returns the view to display if an update is required.
///
@available(iOS 15.0, *)
struct VersionValidatorViewModifier<UpdateView: View>: ViewModifier {
    // State variable to track whether a version update is required.
    @State private var versionUpdateRequired = false
    
    // The app bundle, typically `Bundle.main`, used to retrieve version information from the app's `Info.plist`.
    let bundle: Bundle
    
    // The type of version change to check for (major, minor, patch).
    let selectedVersionNumber: VersionNumberType
    
    // A closure that provides the view to display when an update is required.
    let updateView: () -> UpdateView
    
    // The version validator that checks if the app needs to be updated.
    // It is created using the version information from the provided `bundle`.
    private var validator: NnVersionValidator {
        return makeVersionValidator(infoDictionary: bundle.infoDictionary, bundleId: bundle.bundleIdentifier, selectedVersionNumber: selectedVersionNumber)
    }
    
    /// The body of the view modifier.
    /// Displays the `updateView` if an update is required; otherwise, it displays the original content.
    ///
    /// The version check is performed asynchronously when the content is first displayed.
    func body(content: Content) -> some View {
        if versionUpdateRequired {
            updateView() // Show the update view if an update is required.
        } else {
            content
                .task {
                    // Check asynchronously if an update is required.
                    if let updateRequired = try? await validator.checkIfVersionUpdateIsRequired() {
                        // Update the state on the main thread.
                        await MainActor.run {
                            versionUpdateRequired = updateRequired
                        }
                    }
                }
        }
    }
}

@available(iOS 15.0, *)
public extension View {
    /// A view extension that applies the `VersionValidatorViewModifier` to a SwiftUI view.
    ///
    /// This modifier checks if an app version update is required and displays the `updatedView` if necessary.
    ///
    /// - Parameters:
    ///   - mainBundle: The main app bundle (typically `Bundle.main`) containing the app's version information.
    ///   - selectedVersionNumber: The type of version change to check for (major, minor, patch). Defaults to `.major`.
    ///   - updatedView: A closure that returns the view to display if an update is required.
    ///
    /// - Returns: A modified view that shows either the original content or the `updatedView` based on the version check.
    func withVersionValidation<UpdateView: View>(mainBundle: Bundle, selectedVersionNumber: VersionNumberType = .major, @ViewBuilder updatedView: @escaping () -> UpdateView) -> some View {
        modifier(VersionValidatorViewModifier(bundle: mainBundle, selectedVersionNumber: selectedVersionNumber, updateView: updatedView))
    }
}
