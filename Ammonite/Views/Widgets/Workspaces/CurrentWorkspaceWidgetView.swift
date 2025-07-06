//
//  AerospaceSpaceNumericWidget.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 20/06/2025.
//

import Foundation
import SwiftUI
import Factory
import Combine

@MainActor
@Observable
final class CurrentWorkspaceWidgetViewModel {
    
    @ObservationIgnored
    @Injected(\AmmoniteContainer.workspacesRepository)
    private var workspacesRepository
    
    var text: String = ""
    let showIndex: Bool
    
    @ObservationIgnored
    private var cancellable: AnyCancellable?
    
    init(showIndex: Bool) {
        self.showIndex = showIndex
        observeWorkspaces()
    }
    
    private func observeWorkspaces() {
        cancellable = workspacesRepository.workspacesStatePublisher
            .sink { [weak self] state in
                self?.updateText(with: state)
            }
    }
    
    private func updateText(with state: WorkspacesState) {
        if showIndex {
            let index = (state.current ?? 0) + 1
            text = "\(index)"
        } else if let currentIndex = state.current,
                  let current = state.workspaces[safe: currentIndex] {
            let name = workspacesRepository.displayName(for: current)
            text = name.isNumber ? name : name.prefix(1).uppercased()
        } else {
            text = "?"
        }
    }
}

struct CurrentWorkspaceWidgetView: View {
    
    @State private var viewModel: CurrentWorkspaceWidgetViewModel
    @EnvironmentObject var configManager: ConfigManager
    
    init(showIndex: Bool) {
        self.viewModel = CurrentWorkspaceWidgetViewModel(showIndex: showIndex)
    }
    
    var appearance: AppearanceConfig {
        configManager.config.appearance
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .foregroundStyle(appearance.primaryColor)
            
            Text(viewModel.text)
                .contentTransition(.numericText())
                .font(appearance.font.resized(by: 1))
                .frame(alignment: .center)
                .blendMode(.destinationOut)

        }
        .compositingGroup()
        .animation(.default, value: viewModel.text)
        .aspectRatio(1, contentMode: .fit)
    }
}
