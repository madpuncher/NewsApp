import Foundation
import UIKit
import CoreData

protocol MainViewProtocol: AnyObject {
    
    func showAlert(title: String, message: String)
    
    func reloadTableView()
}

protocol MainPresenterProtocol: AnyObject {
    
    var news: [NewsTableViewModel] { get set }
    
    var filteredNews: [NewsTableViewModel] { get set }
    
    init(view: MainViewController, networkService: NetworkServiceProtocol)
    
    func requestToGetNews(type: Int, page: Int, newType: Bool)
    
    func showAlert(title: String, message: String)
    
    func addNewsToFavorite(model: NewsTableViewModel)
    
}

final class MainViewPresenter: MainPresenterProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    private weak var view: MainViewProtocol?
    
    public var news: [NewsTableViewModel] = [] {
        didSet {
            //sorted by publishedAT (TZ)
            news.sort(by: <)
        }
    }
    
    public var filteredNews: [NewsTableViewModel] = []
    
    private var container: NSPersistentContainer
    
    var isLoading = false
    
    private var context: NSManagedObjectContext
    
    required init(view: MainViewController, networkService: NetworkServiceProtocol) {
        
        self.view = view
        self.networkService = networkService
        
        container = NSPersistentContainer(name: "NewsData")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CORE DATA DNT WORK: \(error.localizedDescription)")
            }
        }
        
        context = container.viewContext
        
        requestToGetNews(type: 0, page: 1, newType: false)
    }
    
    // MARK: CORE DATA FUNCTIONS
    public func addNewsToFavorite(model: NewsTableViewModel) {
        
        let favoriteNews = NewsEntity(context: context)
        
        favoriteNews.publishedAt = model.publishedAt
        favoriteNews.isFavorite = model.isFavorite
        favoriteNews.subtitle = model.subtitle
        favoriteNews.author = model.author
        favoriteNews.title = model.title
        favoriteNews.url = model.url?.absoluteString
        favoriteNews.name = model.name
        favoriteNews.imageURL = model.imageURL?.absoluteString
        
        saveData()
    }
    
    private func saveData() {
        
        do {
            try context.save()
        } catch {
            //just debugger
            print("Oops, save failed")
        }
    }
    
    // MARK: PUBLIC
    private func calculateIndexPathsToReload(from newModerators: [NewsTableViewModel]) -> [IndexPath] {
        let startIndex = news.count - newModerators.count
        let endIndex = startIndex + newModerators.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    
    public func showAlert(title: String, message: String) {
        view?.showAlert(title: title, message: message)
    }
    
    public func requestToGetNews(type: Int, page: Int, newType: Bool) {
        
        networkService.getNews(newsType: type, page: page) { [weak self] newsResponse in
            switch newsResponse {
                
            case .success(let response):
                //Если сегмент переключен - перезаписываем
                if newType {

                    self?.news = response.compactMap({
                        NewsTableViewModel(
                            title: $0.title,
                            subtitle: $0.description ?? "No description",
                            imageURL: URL(string: $0.urlToImage ?? ""),
                            author: $0.author,
                            publishedAt: $0.publishedAt,
                            name: $0.source.name,
                            url: URL(string: $0.url ?? "")
                        )
                    })
                    //Если нет, то добавляем пагинацию
                } else {
                    
                    self?.news.append(contentsOf: response.compactMap({
                        NewsTableViewModel(
                            title: $0.title,
                            subtitle: $0.description ?? "No description",
                            imageURL: URL(string: $0.urlToImage ?? ""),
                            author: $0.author,
                            publishedAt: $0.publishedAt,
                            name: $0.source.name,
                            url: URL(string: $0.url ?? "")
                        )
                    }))
                }
                
                DispatchQueue.main.async {
                    self?.view?.reloadTableView()
                }
                
            case .failure(let error):
                self?.showAlert(title: "Ошибка", message: error.localizedDescription)
            }
        }
    }
}
