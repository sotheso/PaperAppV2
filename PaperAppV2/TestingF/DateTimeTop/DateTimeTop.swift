//
//  DateTimeTop.swift
//  PaperAppV2
//
//  Created by Sothesom on 03/11/1403.
//
// https://developer.apple.com/documentation/foundation/dateformatter
 

import SwiftUI

struct DateTimeTop: View {

// Api date
    var stringDate = "2025-02-01T09:45:00.000+02:00"
    
    var body: some View {
        Text("\(Date().formatDate())")
// Api date
        Text("\(formatStringDate(date: stringDate))")
    }
    
    
    func formatStringDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let newDate = dateFormatter.date(from: date)
        return newDate!.formatDate()
        
    }
}

#Preview {
    DateTimeTop()
}
