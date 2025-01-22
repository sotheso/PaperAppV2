//
//  extension.swift
//  PaperAppV2
//
//  Created by Sothesom on 03/11/1403.
//

import Foundation


extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMM d")
        return dateFormatter.string(from: self)
    }
}
