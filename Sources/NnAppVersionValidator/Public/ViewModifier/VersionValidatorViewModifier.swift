//
//  VersionValidatorViewModifier.swift
//  
//
//  Created by Nikolai Nobadi on 10/4/24.
//

import SwiftUI

@available(iOS 15.0, *)
struct VersionValidatorViewModifier<UpdateView: View>: ViewModifier {
    @State private var versionUpdateRequired = false
    
    let bundle: Bundle
    let selectedVersionNumber: VersionNumberType
    let updateView: () -> UpdateView
    
    private var validator: NnVersionValidator {
        return makeVersionValidator(infoDictionary: bundle.infoDictionary, bundleId: bundle.bundleIdentifier, selectedVersionNumber: selectedVersionNumber)
    }
    
    func body(content: Content) -> some View {
        if versionUpdateRequired {
            updateView()
        } else {
            content
                .task {
                    if let updateRequired = try? await validator.checkIfVersionUpdateIsRequired() {
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
    func withVersionValidation<UpdateView: View>(mainBundle: Bundle, selectedVersionNumber: VersionNumberType = .major, @ViewBuilder updatedView: @escaping () -> UpdateView) -> some View {
        modifier(VersionValidatorViewModifier(bundle: mainBundle, selectedVersionNumber: selectedVersionNumber, updateView: updatedView))
    }
}
