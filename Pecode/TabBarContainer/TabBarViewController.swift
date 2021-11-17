import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        configureLayout()
    }
    
    private func configureLayout() {
        
        tabBar.tintColor = .label
        
        view.backgroundColor = .systemBackground
    }
    
    private func setupTabBar() {
        
        //SETUP BAR CONTROLLERS
        
        let mainVC = UINavigationController(rootViewController: ModelBuilder.createMainModule())
        let saveVC = UINavigationController(rootViewController: ModelBuilder.createSaveModule())
                
        mainVC.tabBarItem = UITabBarItem(title: .search,
                                         image: UIImage(systemName: .newspaper),
                                         tag: 1)
        
        saveVC.tabBarItem = UITabBarItem(title: .save,
                                         image: UIImage(systemName: .heart),
                                         tag: 2)
        
        setViewControllers([mainVC, saveVC], animated: false)
        
        mainVC.navigationBar.prefersLargeTitles = false
        
        //LAYOUT
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
        
        tabBar.standardAppearance = appearance
    }
}
