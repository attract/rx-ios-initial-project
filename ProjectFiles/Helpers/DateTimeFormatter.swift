//
//  DateTimeFormatter.swift
//  
//
//  Created by Stanislav Makushov on 31.07.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation

class DateTimeFormatter {
    static let timeFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    static let amPmTimeFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }
    
    static let dateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }
    
    static let dateTimeFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy | HH:mm"
        return formatter
    }
    
    static let notifDateTimeFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy HH:mm"
        return formatter
    }
    
    static let serverFilterFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    static let dayMonthFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }
    
    class func timeString(from date: Date) -> String {
        return timeFormatter().string(from: date)
    }
    
    class func amPmTimeString(from date: Date) -> String {
        return amPmTimeFormatter().string(from: date)
    }

    class func string(from date: Date, withTime: Bool = false) -> String {
        return withTime == true ? dateTimeFormatter().string(from: date) : dateFormatter().string(from: date)
    }
    
    class func notifDateString(from date: Date) -> String {
        return notifDateTimeFormatter().string(from: date)
    }
    
    class func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        
        return calendar.date(from: mergedComponments)
    }
}

extension Date {
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}
