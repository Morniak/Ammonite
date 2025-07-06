//
//  WidgetsManager.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 03/07/2025.
//

import Foundation
import SwiftUI
import Combine
import Factory

@Observable
final class WidgetsRepository {
    
    // MARK: - Public members
    
    private(set) var leftBar: [Widget] = []
    private(set) var leftNotch: Widget? = nil
    private(set) var rightNotch: Widget? = nil
    private(set) var rightBar: [Widget] = []
    
    // MARK: - Computed vars
    
    var notchWidgets: [Widget] {
        ([leftNotch] + [rightNotch]).compactMap(\.self)
    }
    
    var barWidgets: [Widget] {
        (leftBar + rightBar).compactMap(\.self)
    }
    
    var allWidgets: [Widget] {
        barWidgets + notchWidgets
    }
    
    var isNotchEmpty: Bool {
        notchWidgets.isEmpty
    }
    
    // MARK: - Private members
    
    @ObservationIgnored
    @Injected(\AmmoniteContainer.commandListener) private var commandListener
    
    @ObservationIgnored
    @Injected(\AmmoniteContainer.configManager) private var configManager
    
    @ObservationIgnored
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: -
    
    init() {
        self.leftBar = configManager.config.widgets.leftBar
        self.leftNotch = configManager.config.widgets.leftNotch
        self.rightNotch = configManager.config.widgets.rightNotch
        self.rightBar = configManager.config.widgets.rightBar
        
        setupListeners()
    }
}

// MARK: - Private methods

private extension WidgetsRepository {
    
    func setupListeners() {
        commandListener.commandPublisher
            .sink { [weak self] command in
                guard case let .widget(position, widgets) = command else { return }

                switch position {
                case .leftBar:
                    self?.leftBar = widgets.filter { $0 != .none }
                case .leftNotch:
                    self?.leftNotch = widgets.first
                case .rightNotch:
                    self?.rightNotch = widgets.first
                case .rightBar:
                    self?.rightBar = widgets.filter { $0 != .none }
                }
            }
            .store(in: &cancellables)
        
        configManager.$config
            .map(\.widgets)
            .sink { config in
                self.leftBar = config.leftBar.filter { $0 != .none }
                self.leftNotch = config.leftNotch
                self.rightBar = config.rightBar.filter { $0 != .none }
                self.rightNotch = config.rightNotch
            }
            .store(in: &cancellables)
    }
}
