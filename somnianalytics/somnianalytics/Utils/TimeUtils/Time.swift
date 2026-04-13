//
//  Time.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 3/31/26.
//
import Foundation

public func formattedTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm"
    return formatter.string(from: date)
}

public func amPM(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "a"
    return formatter.string(from: date)
}
