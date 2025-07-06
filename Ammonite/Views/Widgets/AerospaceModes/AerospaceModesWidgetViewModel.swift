//
//  AerospaceModesWidgetViewModel.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 04/07/2025.
//

import Foundation
import Factory
import Combine

@MainActor
@Observable
final class AerospaceModesWidgetViewModel {
    @ObservationIgnored @Injected(\AmmoniteContainer.configManager) private var configManager
    @ObservationIgnored @Injected(\AmmoniteContainer.aerospaceModeSwitcher) private var modeSwitcher
    @ObservationIgnored @Injected(\AmmoniteContainer.aerospaceModesRepository) private var repository
    
    var currentIndex: Int = 0
    var modes: [String] = []
    
    var current: String {
        modes[safe: currentIndex] ?? "?"
    }
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = repository.modesStatePublisher.sink { [weak self] state in
            guard let self else { return }
            self.modes = state.modes
            self.currentIndex = state.current ?? 0
        }
    }
    
    func switchMode(_ modeIndex: Int) {
        modeSwitcher.switchAerospaceMode(at: modeIndex)
    }
    
    func isModeSelected(_ modeIndex: Int) -> Bool {
        currentIndex == modeIndex
    }
    
    
}
