//
//  StorageDevicesMonitor.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 01/07/2025.
//

import Foundation
import DiskArbitration

final class StorageDevicesMonitor: ObservableObject {
    @Published var devices: [String] = []
    
    private var session: DASession?
    private var diskAppeared: DADiskAppearedCallback!
    private var diskDisappeared: DADiskDisappearedCallback!
    
    func startMonitoring() {
        stopMonitoring() // in case we start twice
        
        session = DASessionCreate(kCFAllocatorDefault)
        guard let session else { return }
        
        // Set up callbacks
        diskAppeared = { (disk, context) in
            let monitor = Unmanaged<StorageDevicesMonitor>.fromOpaque(context!).takeUnretainedValue()
            monitor.updateDevices()
        }
        
        diskDisappeared = { (disk, context) in
            let monitor = Unmanaged<StorageDevicesMonitor>.fromOpaque(context!).takeUnretainedValue()
            monitor.updateDevices()
        }
        
        // Use DispatchQueue (modern)
        DASessionSetDispatchQueue(session, DispatchQueue.main)
        
        // Register callbacks AFTER setting the queue!
        DARegisterDiskAppearedCallback(session, nil, diskAppeared, Unmanaged.passUnretained(self).toOpaque())
        DARegisterDiskDisappearedCallback(session, nil, diskDisappeared, Unmanaged.passUnretained(self).toOpaque())
        
        updateDevices()
    }
    
    func stopMonitoring() {
        if let session {
            DASessionSetDispatchQueue(session, nil)
        }
        session = nil
    }
    
    func updateDevices() {
        DispatchQueue.global(qos: .background).async {
            let volumes = self.fetchExternalVolumes()
            DispatchQueue.main.async {
                self.devices = volumes
            }
        }
    }
    
    private func fetchExternalVolumes() -> [String] {
        let keys: [URLResourceKey] = [
            .volumeNameKey,
            .volumeIsInternalKey,
            .volumeIsRemovableKey,
            .volumeIsEjectableKey,
            .volumeURLKey,
            .volumeLocalizedFormatDescriptionKey
        ]
        
        guard let mountedVolumes = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: keys, options: []) else {
            return []
        }
        
        let externalVolumes = mountedVolumes.compactMap { url -> String? in
            guard let resourceValues = try? url.resourceValues(forKeys: Set(keys)) else { return nil }
            guard url.absoluteString.starts(with: "file:///Volumes/") else { return nil }

            let volumeName = resourceValues.volumeName ?? ""

            if !volumeName.isEmpty {
                return volumeName
            } else {
                return nil
            }
        }

        return externalVolumes.sorted()
    }
}
