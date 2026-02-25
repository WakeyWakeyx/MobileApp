//
//  AlarmErrors.swift
//  somnianalytics
//
//  Created by Hayden Barogh on 2/24/26.
//

import Foundation

/**
    Current Alarm Errors these will be used to handle the alarm errors and either retry, or show ui updates based on the error type 
 */
enum AlarmErrors: Error {
    case alarmSchedulingError
    case requestAuthorizationError
}

extension AlarmErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .alarmSchedulingError:
                    return NSLocalizedString("An error occured when scheduling the alarm", comment: "Alarm Scheduling Error")
            case .requestAuthorizationError :
                    return NSLocalizedString("An error occured when requesting alarm access", comment: "Alarm Authorization Error")
        }
    }
}
