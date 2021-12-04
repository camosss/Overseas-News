//
//  Date+Extension.swift
//  OverseasNews
//
//  Created by 강호성 on 2021/11/24.
//

import Foundation

extension DateFormatter {
    static var currentFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

extension Date {
    func toString(dateValue: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: dateValue)
    }
}

extension String {
    func toDate(stringValue: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: stringValue)
    }
}
