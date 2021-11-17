import UIKit

final class SaveViewController: UIViewController, SaveViewProtocol {

    //MARK: - Const
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: .mainViewCellIdentifier)
        return table
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "На данный момент, у вас нет сохраненных новостей"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var presenter: SavePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        addViews()
        setupUI()
        setupTableView()
        setupNavBar()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.fetchNewsFromStorage()
        
        checkNewsStorage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func checkNewsStorage() {
        if presenter.saveNews.isEmpty {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            emptyLabel.isHidden = true
        }
    }
    
    private func setupNavBar() {
                
        self.navigationItem.title = "Сохраненные новости"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
    }
    
    private func setupUI() {
        
        view.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    }
    
    private func addViews() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
        
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func reloadView() {
        tableView.reloadData()
    }
}

//MARK: DELEGATE AND DATA SOURCE TABLE VIEW
extension SaveViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.saveNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: .mainViewCellIdentifier, for: indexPath) as! MainTableViewCell
        
        let saveNews = presenter.saveNews[indexPath.row]
                
        cell.configureSave(model: saveNews)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let someNew = presenter.saveNews[indexPath.row]
        
        let webVC = WebViewController()
        
        guard let url = URL(string: someNew.url ?? "") else { return }
        
        webVC.loadView(url: url)
        
        navigationController?.pushViewController(webVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        .defaultRowHight
    }
    
}
