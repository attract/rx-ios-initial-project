//
//  ClientToken.swift
//  Hologo
//
//  Created by Dmytro Aprelenko on 17.09.2019.
//  Copyright © 2019 Stanislav. All rights reserved.
//

import Foundation

struct ClientToken: Codable {
    let token_type: String?
    let expires_in: Int?
    let access_token: String?
}
