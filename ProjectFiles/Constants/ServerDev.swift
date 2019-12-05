//
//  ServerDev.swift
//  VeezApp
//
//  Created by Artem Boyko on 5/6/19.
//  Copyright © 2019 Artem Boyko. All rights reserved.
//

import Foundation

struct ServerConstants {
    static let serverProtocol   = Constants.application.environment == .development ? "https" : "https"
    static let serverName       = Constants.application.environment == .development ? "" : ""
    static let serverPath       = serverProtocol + "://" + serverName
    static let apiPath          = serverPath + "/api"
    static let apiVersion       = "/v1"
    static let fullApiPath      = apiPath + apiVersion
    
    static let frontServerPath  = "\(serverProtocol)://\(Constants.application.environment == .development ? "" : "")"
}
