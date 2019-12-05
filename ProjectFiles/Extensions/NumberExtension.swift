//
//  NumberExtension.swift
//  
//
//  Created by Stanislav Makushov on 14.07.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
