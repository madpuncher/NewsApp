import Foundation
import CoreData

protocol SaveViewProtocol: AnyObject {
    
    func showAlert(title: String, message: String)
    
    func reloadView() 
}

protocol SavePresenterProtocol: AnyObject {
    
    var saveNews: [NewsEntity] { get set }
    
    init(view: SaveViewProtocol, networkService: NetworkServiceProtocol)
    
    func showAlert(title: String, message: String)
    
    func fetchNewsFromStorage()
        
}

final class SaveViewPresenter: SavePresenterProtocol {
    
    public var saveNews: [NewsEntity] = [] {
        didSet {
            view?.reloadView()
        }
    }
    
    private var container: NSPersistentContainer
    
    private var context: NSManagedObjectContext
    
    private let networkService: NetworkServiceProtocol
    
    private weak var view: SaveViewProtocol?
    
    required init(view: SaveViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        
        container = NSPersistentContainer(name: "NewsData")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("CORE DATA DNT WORK: \(error.localizedDescription)")
            }
        }
        context = container.viewContext
        
        fetchNewsFromStorage()
    }
    
    func fetchNewsFromStorage() {
        let request = NSFetchRequest<NewsEntity>(entityName: "NewsEntity")
        
        do {
            saveNews = try context.fetch(request)
            
        } catch {
            showAlert(title: "Ой", message: "Не получилось получить сохраненные новости")
        }
    }
    
    func showAlert(title: String, message: String) {
        view?.showAlert(title: title, message: message)
    }
   
}
