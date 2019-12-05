//
//  FileManagerExtension.swift
//  Beehives
//
//  Created by Mac on 8/16/18.
//  Copyright © 2018 Stanislav Makushov. All rights reserved.
//

import Foundation

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}

