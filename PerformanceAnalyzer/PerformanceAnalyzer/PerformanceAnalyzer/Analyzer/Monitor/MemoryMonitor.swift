//
//  MemoryMonitor.swift
//  PerformanceAnalyzer
//
//  Created by He,Junqiu on 2018/3/8.
//  Copyright © 2018年 hejunqiu. All rights reserved.
//

import Foundation

class MemoryMonitor: Monitor {
    var delegate: MonitorDataSourceDelegate?
    private var updater: Timer!
    var isMonitoring: Bool { return updater != nil }
    var type: MonitorType { return .memory }

    func start() {
        updater = Timer(timeInterval: 1, target: self, selector: #selector(onUpdater(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(updater, forMode: .defaultRunLoopMode)
        RunLoop.main.add(updater, forMode: .UITrackingRunLoopMode)
        updater.fire()
    }

    func stop() {
        if updater?.isValid == true {
            updater.invalidate()
        }
        updater = nil
    }

    @objc private func onUpdater(_ timer: Timer) {
        delegate?.monitor(self, occurs: .int(GetCurrentMallocAllocSize()), at: currentTime())
    }
}

extension MemoryMonitor: MonitorShared {
    static let shared = MemoryMonitor()
}