//
//  AerospaceModesInteractor.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 04/07/2025.
//

import Foundation
import Combine
import Factory

class AerospaceModesInteractor {
    
    @Injected(\AmmoniteContainer.commandListener) var commandListener
    @Injected(\AmmoniteContainer.aerospaceInteractor) var aerospaceInteractor
    
    private let modesSubject: CurrentValueSubject<AerospaceModesState, Never>
    private var cancellable: AnyCancellable?
    
    init(config: Config) {
        let modes = config.aerospace.modes
        let currentModeIndex = modes.firstIndex(of: config.aerospace.currentMode)
        let state = AerospaceModesState(modes: modes, current: currentModeIndex)
        
        self.modesSubject = .init(state)
        
        self.cancellable = self.commandListener.commandPublisher.sink { [weak self] command in
            guard case let .aerospaceMode(newMode) = command else { return }
            self?.onModeChanged(newMode)
        }
    }
    
    func onModeChanged(_ newMode: String) {
        guard let index = modesState.modes.firstIndex(of: newMode) else { return }
        
        var state = modesState
        state.current = index
        self.modesSubject.send(state)
    }
}

// MARK: - AerospaceModesRepository

extension AerospaceModesInteractor: AerospaceModesRepository {
    var modesState: AerospaceModesState {
        modesSubject.value
    }
    
    var modesStatePublisher: AnyPublisher<AerospaceModesState, Never> {
        modesSubject.eraseToAnyPublisher()
    }
}

// MARK: - AerospaceModeSwitcher

extension AerospaceModesInteractor: AerospaceModeSwitcher {
    func switchAerospaceMode(at index: Int) {
        guard let mode = modesState.modes[safe: index] else { return }
        switchAerospaceMode(mode)
    }
    
    func switchAerospaceMode(_ mode: String) {
        Task {
            do {
                try await aerospaceInteractor.switchToMode(mode: mode)
                onModeChanged(mode)
            } catch {
                print(error)
            }
        }
    }
}
