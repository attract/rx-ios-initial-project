//
//  Error.swift
//  Hologo
//
//  Created by Dmytro Aprelenko on 13.09.2019.
//  Copyright © 2019 Stanislav. All rights reserved.
//

import Foundation

enum AppError: Error {
    case ValidationError(text: String)
    case NetworkConnectionError(text: String)
    case RegularError(message: String)
    case OtherNSError(nsError: NSError)
    case APIError(apiError: APIError)
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .ValidationError(text: let errorText):
            return errorText
        case .NetworkConnectionError(text: let errorText):
            return errorText
        case .APIError(apiError: let apiError):
            return apiError.localizedDescription
        default:
            return self.localizedDescription
        }
    }
}

final class APIError: Error {
    var title: String?
    var subtitle: String?
    var type: String?
    var statusCode: Int?
    var validationErrors: [APIError]?
}

extension APIError: LocalizedError {
    var localizedDescription: String {
        return title ?? "Api Error"
    }
}
