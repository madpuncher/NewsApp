import UIKit

final class MainViewController: UIViewController, MainViewProtocol, MainTableCellDelegate {
    
    //MARK: - Const
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: .mainViewCellIdentifier)
        table.register(UINib(nibName: "MainLoadingTableViewCell", bundle: nil), forCellReuseIdentifier: .mainViewLoadingCellIdentifier)
        return table
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = .returnFormattedDay()
        dateLabel.textColor = .secondaryLabel
        return dateLabel
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Свежие новости"
        titleLabel.font = UIFont(name: "Avenir-Black", size: 20)
        return titleLabel
    }()
    
    public let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let segmentControl = UISegmentedControl(items: ["Все", "Спорт", "Здоровье", "Бизнес"])
    
    private var timer: Timer?
    
    private var page = 1
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return true }
        return text.isEmpty
    }
    
    public var presenter: MainPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchController()
        configureRefresher()
        addViews()
        setupUI()
        addTargets()
        setupNavBar()
    }
    
    private func setupSearchController() {
        //Setup search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите источник"
        navigationItem.searchController = searchController
    }
    
    public func addToFavorite(_ model: NewsTableViewModel) {
        presenter.addNewsToFavorite(model: model)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    private func addTargets() {
        segmentControl.addTarget(self,
                                 action: #selector(segmentedValueChanged),
                                 for: .valueChanged)
    }
    
    private func addViews() {
        view.addSubview(tableView)
    }
    
    private func setupNavBar() {
        
        self.navigationItem.title = "PECODE THE BEST"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.searchController = searchController
    }
    
    private func setupUI() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        tableView.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .gray
        
        createHeader()
    }
    
    private func createHeader() {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 120))
        tableView.tableHeaderView = headerView
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel,titleLabel])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        
        segmentControl.selectedSegmentIndex = 0
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(segmentControl)
        headerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            segmentControl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            segmentControl.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10)
        ])
        
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
    }
    
    private func getNews(type: Int, page: Int, newType: Bool) {
        presenter.requestToGetNews(type: type, page: 1, newType: newType)
    }
    
    private func configureRefresher() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    //MARK: TARGET ACTIONS
    @objc private func segmentedValueChanged() {
        
        let segmentIndex = segmentControl.selectedSegmentIndex
        getNews(type: segmentIndex, page: 1, newType: true)
    }
    
    @objc private func refresh() {
        presenter.requestToGetNews(type: segmentControl.selectedSegmentIndex, page: 1, newType: true)
        refreshControl.endRefreshing()
    }
    
    
    // MARK: PUBLIC
    
    public func reloadTableView() {
        tableView.reloadData()
    }
    
    public func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: DELEGATE AND DATA SOURCE TABLE VIEW
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if !searchBarIsEmpty {
                return presenter.filteredNews.count
            }
            return presenter.news.count
        } else {
            //Return the Loading cell
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2 //news and indicator in pagination cell
    }
    
    // MARK: PAGINATION
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == presenter.news.count - 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoadingIndexPath(indexPath) else { return }
        
        page += 1
        presenter.requestToGetNews(type: segmentControl.selectedSegmentIndex, page: page, newType: false)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: .mainViewCellIdentifier, for: indexPath) as! MainTableViewCell
            
            let currentNew = searchBarIsEmpty ? presenter.news[indexPath.row] : presenter.filteredNews[indexPath.row]
            
            cell.delegate = self
            
            cell.configure(model: currentNew)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: .mainViewLoadingCellIdentifier, for: indexPath) as! MainLoadingTableViewCell
            
            cell.activityIndicator.startAnimating()
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let someNew = searchBarIsEmpty ? presenter.news[indexPath.row] : presenter.filteredNews[indexPath.row]
        
        let webVC = WebViewController()
        webVC.loadView(url: someNew.url)
        
        navigationController?.pushViewController(webVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return .defaultRowHight
        } else {
            
            return .defaultRowLoadingHight
        }
        
    }
    
}

// MARK: SEARCH ACTIONS
extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchController.searchBar.text ?? "")
    }
    
    func filterContent(_ searchText: String) {
        presenter.filteredNews = presenter.news.filter { $0.name.contains(searchText) }
        tableView.reloadData()
    }
}
