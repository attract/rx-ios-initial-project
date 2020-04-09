import UIKit

struct DeepLinkURLConstants {
    static let Task = "task"
    static let SignUp = "signUp"
}

enum DeepLinkOption {
    case task(taskId: String?)
    case signUp
    
    static func build(with userActivity: NSUserActivity) -> DeepLinkOption? {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let _ = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            //TODO: extract string and match with DeepLinkURLConstants
        }
        return nil
    }
    
    static func build(with dict: [String : AnyObject]?) -> DeepLinkOption? {
        guard let id = dict?["launch_id"] as? String else { return nil }
        
        let taskID = dict?["item_id"] as? String
        
        switch id {
        case DeepLinkURLConstants.SignUp: return .signUp
        case DeepLinkURLConstants.Task: return .task(taskId: taskID)
        default: return nil
        }
    }
}
