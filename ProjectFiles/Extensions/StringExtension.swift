//
//  StringExtension.swift
//  
//
//  Created by Stanislav Makushov on 11.07.17.
//  Copyright © 2017 Stanislav Makushov. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func substring(_ r: Range<Int>) -> String {
        if self.length < r.upperBound {
            return self
        }
        
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        return "\(self.substring(with: Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))))..."
    }
    
    var length: Int {
        return self.count
    }
    
    var urlencoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    func startsWith(string: String) -> Bool {
        guard let range = range(of: string, options:[.caseInsensitive]) else {
            return false
        }
        return range.lowerBound == startIndex
    }
    
    func formatPhone(shouldRemoveLastDigit: Bool = false) -> String {
            guard !self.isEmpty else { return "" }
            guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
            let r = NSString(string: self).range(of: self)
            var number = regex.stringByReplacingMatches(in: self, options: .init(rawValue: 0), range: r, withTemplate: "")
            
            if number.count > 10 {
                let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
                number = String(number[number.startIndex..<tenthDigitIndex])
            }
            
            if shouldRemoveLastDigit {
                let end = number.index(number.startIndex, offsetBy: number.count-1)
                number = String(number[number.startIndex..<end])
            }
            
            if number.count < 7 {
                let end = number.index(number.startIndex, offsetBy: number.count)
                let range = number.startIndex..<end
                number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
                
            } else {
                let end = number.index(number.startIndex, offsetBy: number.count)
                let range = number.startIndex..<end
                number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
            }
            return number
        }
    
    var withoutHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func getAttributedStringFromHTML(originalFont: Bool = false, fontSize: CGFloat = 15) -> NSAttributedString {
        if let data = self.data(using: .utf8) {
            do {
                let attributedString = try NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,NSAttributedString.DocumentReadingOptionKey.characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
                
                if originalFont == false {
                    let font: UIFont = UIFont.systemFont(ofSize: 15)
                    
                    attributedString.addAttributes([NSAttributedString.Key.font:font], range: NSRange.init(location: 0, length: attributedString.length))
                }
                
                return attributedString
            } catch {
                return NSAttributedString(string: self)
            }
        } else {
            return NSAttributedString(string: self)
        }
    }
}

// concatenate attributed strings
func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
{
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

func + (left: NSMutableAttributedString, right: NSMutableAttributedString) -> NSMutableAttributedString
{
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

extension Sequence where Iterator.Element: NSAttributedString {
    /// Returns a new attributed string by concatenating the elements of the sequence, adding the given separator between each element.
    /// - parameters:
    ///     - separator: A string to insert between each of the elements in this sequence. The default separator is an empty string.
    func joined(separator: NSAttributedString = NSAttributedString(string: "")) -> NSAttributedString {
        var isFirst = true
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if isFirst {
                isFirst = false
            } else {
                r.append(separator)
            }
            r.append(e)
            return r
        }
    }
    
    /// Returns a new attributed string by concatenating the elements of the sequence, adding the given separator between each element.
    /// - parameters:
    ///     - separator: A string to insert between each of the elements in this sequence. The default separator is an empty string.
    func joined(separator: String = "") -> NSAttributedString {
        return joined(separator: NSAttributedString(string: separator))
    }
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(.foregroundColor, value: color, range: range)
    }
    
}
