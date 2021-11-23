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
