//
//  ViewModelType.swift
//  VeezApp
//
//  Created by Artem Boyko on 5/8/19.
//  Copyright © 2019 Artem Boyko. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
