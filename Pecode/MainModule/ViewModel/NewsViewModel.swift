import Foundation

final class NewsTableViewModel: Comparable {
    
    static func == (lhs: NewsTableViewModel, rhs: NewsTableViewModel) -> Bool {
        return lhs.publishedAt == rhs.publishedAt
    }
    
    static func <(lhs: NewsTableViewModel, rhs: NewsTableViewModel) -> Bool {
        return lhs.publishedAt < rhs.publishedAt
    }
    
    let title: String
    let author: String?
    let subtitle: String
    let imageURL: URL?
    let url: URL?
    var publishedAt: String
    var name: String
    
    //Custom
    var isFavorite: Bool = false
    
    init(title: String, subtitle: String, imageURL: URL?,
         author: String?, publishedAt: String, name: String, url: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.author = author
        self.publishedAt = publishedAt
        self.name = name
        self.url = url
    }
    
}
