import UIKit

//Можно было добавить Coordinator или Router, но в силу небольшого флоу, решил не добавлять

protocol Builder {
    
    static func createMainModule() -> UIViewController
    static func createSaveModule() -> UIViewController
}

final class ModelBuilder: Builder {
    
    static func createMainModule () -> UIViewController {
        let view = MainViewController()
        let networkService = NetworkService()
        let presenter = MainViewPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
    
    static func createSaveModule() -> UIViewController {
        let view = SaveViewController()
        let networkService = NetworkService()
        let presenter = SaveViewPresenter(view: view, networkService: networkService)
        view.presenter = presenter
        return view
    }
}
