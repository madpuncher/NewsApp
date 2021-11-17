import Foundation

enum ErrorTypes: Error {
    case failedGetData
}

extension ErrorTypes: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .failedGetData:
            return "Мы не смогли загрузить данные с сервера. Попробуйте вернуться позднее"
        }
    }
}
