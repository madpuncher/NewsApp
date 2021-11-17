import Foundation

// MARK: IMAGES
extension String {
    
    //Tab Bar Icons
    static let newspaper = "newspaper"
    static let heart = "heart"
}

// MARK: TITLES
extension String {
    
    //Tab Bar titles
    static let search = "Search"
    static let save = "Save"
}

// MARK: IDENTIFIERS
extension String {
    
    static let mainViewCellIdentifier = "newsCell"
    static let mainViewLoadingCellIdentifier = "loadingCell"
}

// MARK: DATE FORMATTER
extension String {
    
    static func returnFormattedDay() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "EEE, d MMMM"
        return dateFormatter.string(from: date)
    }
}
