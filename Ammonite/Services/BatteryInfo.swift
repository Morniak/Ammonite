//
//  BatteryInfo.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 26/06/2025.
//

import Foundation
import IOKit.ps
import IOKit

class BatteryInfo: ObservableObject {
    @Published var level: CGFloat = 1.0
    @Published var isCharging: Bool = false
    
    private var powerSourceRunLoopSource: Unmanaged<CFRunLoopSource>?
    
    init() {
        updateBatteryInfo()
        registerForPowerNotifications()
    }
    
    deinit {
        if let source = powerSourceRunLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source.takeUnretainedValue(), .defaultMode)
        }
    }
    
    private func updateBatteryInfo() {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef],
              let source = sources.first,
              let description = IOPSGetPowerSourceDescription(snapshot, source)?.takeUnretainedValue() as? [String: Any]
        else { return }
        
        if let currentCapacity = description[kIOPSCurrentCapacityKey as String] as? Int,
           let maxCapacity = description[kIOPSMaxCapacityKey as String] as? Int {
            DispatchQueue.main.async {
                self.level = CGFloat(currentCapacity) / CGFloat(maxCapacity)
                self.isCharging = (description[kIOPSIsChargingKey as String] as? Bool) ?? false
            }
        }
    }
    
    private func registerForPowerNotifications() {
        let callback: IOPowerSourceCallbackType = { context in
            let mySelf = Unmanaged<BatteryInfo>.fromOpaque(context!).takeUnretainedValue()
            mySelf.updateBatteryInfo()
        }
        
        powerSourceRunLoopSource = IOPSNotificationCreateRunLoopSource(callback, Unmanaged.passUnretained(self).toOpaque())
        if let source = powerSourceRunLoopSource?.takeRetainedValue() {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .defaultMode)
        }
    }
}
