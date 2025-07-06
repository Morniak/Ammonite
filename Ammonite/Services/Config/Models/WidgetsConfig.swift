//
//  WidgetsConfig.swift
//  Ammonite
//
//  Created by Guillaume Clédat on 24/06/2025.
//

import Foundation

struct WidgetsConfig: Equatable {
    var leftBar: [Widget] = []
    var leftNotch: Widget? = nil
    var rightNotch: Widget? = nil
    var rightBar: [Widget] = []
    
    var dateTime: DateTimeWidgetConfig? = nil
    var battery: BatteryWidgetConfig = .default
    var storageDevices: StorageDevicesMonitorWidgetConfig = .default
    
    static var `default` = WidgetsConfig()
}

// MARK: - Decodable

extension WidgetsConfig: Decodable {
    private enum CodingKeys: CodingKey {
        case leftBar
        case leftNotch
        case rightNotch
        case rightBar
        case dateTime
        case battery
        case storageDevices
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<WidgetsConfig.CodingKeys> = try decoder.container(keyedBy: WidgetsConfig.CodingKeys.self)
        self.leftBar = try Self.widgets(from: container, key: .leftBar, default: Self.default.leftBar)
        self.leftNotch = try container.decodeIfPresent(Widget.self, forKey: .leftNotch) ?? Self.default.leftNotch
        self.rightNotch = try container.decodeIfPresent(Widget.self, forKey: .rightNotch) ?? Self.default.rightNotch
        self.rightBar = try Self.widgets(from: container, key: .rightBar, default: Self.default.rightBar)
        self.dateTime = try container.decodeIfPresent(DateTimeWidgetConfig.self, forKey: .dateTime)
        self.battery = try container.decodeIfPresent(BatteryWidgetConfig.self, forKey: .battery) ?? Self.default.battery
        self.storageDevices = try container.decodeIfPresent(StorageDevicesMonitorWidgetConfig.self, forKey: .storageDevices) ?? Self.default.storageDevices
        
        if leftNotch?.isAllowedInNotch == false || rightNotch?.isAllowedInNotch == false {
            print("Warning: Unsupported widget set in notch area.")
        }
    }
    
    private static func widgets(
        from container: KeyedDecodingContainer<CodingKeys>,
        key: CodingKeys,
        default: [Widget]
    ) throws -> [Widget] {
        guard let strArray = try container.decodeIfPresent([String].self, forKey: key) else {
            return `default`
        }
      
        var widgets: [Widget] = []
        
        for str in strArray {
            if let widget = Widget(rawValue: str), widget != .none {
                widgets.append(widget)
            } else {
                print("Unrecognized widget: \(str)")
            }
        }
        
        return widgets
    }
}
