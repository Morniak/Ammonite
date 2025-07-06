//
//  StoragesWidgetViewModel.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 06/07/2025.
//

import Foundation
import SwiftUI
import Factory
import Combine

@MainActor
@Observable
final class StoragesWidgetViewModel {
    @ObservationIgnored
    @Injected(\AmmoniteContainer.configManager) private var configManager: ConfigManager
    
    @ObservationIgnored
    @Injected(\AmmoniteContainer.storageDevicesMonitor) private var storageDevicesMonitor
    
    private(set) var devices: [String] = []
    private(set) var selectedDevice: String?
    
    @ObservationIgnored
    private var cancellable: AnyCancellable?

    func onAppear() {
        storageDevicesMonitor.startMonitoring()
        cancellable = storageDevicesMonitor.$devices
            .assign(to: \.devices, on: self)
    }
    
    func isDeviceSelected(_ index: Int) -> Bool {
        guard let selected = devices[safe: index] else { return false }
        return selectedDevice == selected
    }
    
    func onDeviceSelected(_ index: Int) {
//        guard let selected = devices[safe: index] else { return }
//        
//        withAnimation(.easeIn(duration: 0.3)) {
//            self.selectedDevice = selected == self.selectedDevice ? nil : selected
//        }
    }
    
    func ejectSelectedDevice() {
//        guard let selectedDevice else { return }
//        self.selectedDevice = nil
//        self.storageDevicesMonitor.ejectDisk(bsdName: selectedDevice)
//        self.devices = devices.filter { $0 != selectedDevice }
    }
}
