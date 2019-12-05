//
//  ResponseModel.swift
//  Food truck
//
//  Created by Dmytro Aprelenko on 22.07.2019.
//  Copyright © 2019 Dmytro Aprelenko. All rights reserved.
//

import Foundation

struct ResponseModel<T: Codable>: Codable {
    var code: Int?
    var success: Bool?
    var status: Bool?
    var data: T?
    var errors: [ErrorModel]?
    var apiToken: APIToken?
    var redirect: String?
    var tokenType: String?
    var expiresIn: Int?
    var accessToken: String?
    var refreshToken: String?
    var meta: Metadata?
    
    var isNil: Bool {
        return self.code == nil &&
            self.success == nil &&
            self.status == nil &&
            self.apiToken == nil &&
            self.data == nil &&
            self.tokenType == nil &&
            self.expiresIn == nil &&
            self.accessToken == nil &&
            self.refreshToken == nil
    }
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case success = "success"
        case status = "status"
        case data = "data"
        case errors = "errors"
        case apiToken = "api_token"
        case redirect = "redirect"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case meta = "meta"
    }
}

struct ErrorModel: Codable {
    let field: String?
    let errors: [String]?
}

// MARK: - APIToken
struct APIToken: Codable {
    let token: String?
    let expiresIn: Int?
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case expiresIn = "expires_in"
    }
}

struct Metadata: Codable {
    let currentPage: Int?
    let from: Int?
    let lastPage: Int?
    let path: String?
    let perPage: Int?
    let to: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from = "from"
        case lastPage = "last_page"
        case path = "path"
        case perPage = "per_page"
        case to = "to"
        case total = "total"
    }
}

struct SuccessOperation: Codable {
    var operation: Bool?
}
