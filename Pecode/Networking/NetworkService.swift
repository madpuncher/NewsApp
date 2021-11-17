import Foundation

protocol NetworkServiceProtocol {
    func getNews(newsType: Int, page: Int, completion: @escaping (Result<[Article],Error>) -> Void)
    func downloadImage(url: URL?, completion: @escaping (Data) -> Void)
}


final class NetworkService: NetworkServiceProtocol {
    
    struct Constants {
        static let key = "c71779d29e1644c2938183bed30389fe"
    }
    
    func getNews(newsType: Int, page: Int, completion: @escaping (Result<[Article],Error>) -> Void) {
        
        var urlString = "https://newsapi.org/v2/top-headlines?country=ru&category=business&pageSize=50&apiKey=\(Constants.key)"
        
        switch newsType {
        case 0:
            urlString = "https://newsapi.org/v2/top-headlines?country=ru&pageSize=10&page=\(page)&apiKey=\(Constants.key)"
        case 1:
            urlString = "https://newsapi.org/v2/top-headlines?country=ru&category=sport&pageSize=10&page=\(page)&apiKey=\(Constants.key)"
        case 2:
            urlString = "https://newsapi.org/v2/top-headlines?country=ru&category=health&pageSize=10&page=\(page)&apiKey=\(Constants.key)"
        case 3:
            urlString = "https://newsapi.org/v2/top-headlines?country=ru&category=business&pageSize=10&page=\(page)&apiKey=\(Constants.key)"
        default:
            urlString = "https://newsapi.org/v2/top-headlines?country=ru&pageSize=10&page=\(page)&apiKey=\(Constants.key)"
        }

        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                    return
                }
            
            do {
                let news = try JSONDecoder().decode(News.self, from: data)
                completion(.success(news.articles))
                
            } catch {
                completion(.failure(ErrorTypes.failedGetData))
            }
        }
        .resume()
    }
    
    func downloadImage(url: URL?, completion: @escaping (Data) -> Void) {
        
        guard let finalURL = url else { return }
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300
            else { return }
            
            completion(data)
        }
        .resume()
    }
}

