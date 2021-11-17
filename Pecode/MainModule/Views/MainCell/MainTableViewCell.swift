import UIKit

protocol MainTableCellDelegate {
    
    func addToFavorite(_ model: NewsTableViewModel)
}

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView! {
        didSet {
            newsImageView.contentMode = .scaleAspectFill
            newsImageView.layer.cornerRadius = 15
            newsImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton! {
        didSet {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.setTitle("", for: .normal)
        }
    }
    
    var delegate: MainTableCellDelegate!
    
    var model: NewsTableViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        configureLayout()
        
        isUserInteractionEnabled = true
    }
    
    public func configure(model: NewsTableViewModel) {
        
        self.model = model
        
        referenceLabel.text = "Источник: \(model.name)"
        authorLabel.text = model.author != nil ? "Автор: \(model.author!)" : "Автор не указан"
        newsTextLabel.text = model.title
        favoriteButton.tintColor = model.isFavorite ? .yellow : .white
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        favoriteButton.tintColor = model.isFavorite ? .yellow : .white
        
        if let url = model.imageURL {
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard
                    let data = data,
                    error == nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300
                else { return }
                
                DispatchQueue.main.async {
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                    self?.newsImageView.image = UIImage(data: data)
                }
            }
            .resume()
        }
        
    }
    
    public func configureSave(model: NewsEntity) {
        
        referenceLabel.text = "Источник: \(String(describing: model.name ?? ""))"
        authorLabel.text = model.author != nil ? "Автор: \(model.author!)" : "Автор не указан"
        newsTextLabel.text = model.title
        favoriteButton.tintColor = model.isFavorite ? .yellow : .white
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        favoriteButton.isHidden = model.isFavorite ? true : false
        
        if let url = URL(string: model.imageURL ?? "") {
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard
                    let data = data,
                    error == nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300
                else { return }
                
                DispatchQueue.main.async {
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                    self?.newsImageView.image = UIImage(data: data)
                }
            }
            .resume()
        }
    }
    
    private func configureLayout() {
        self.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsImageView.image = nil
        referenceLabel.text = nil
        authorLabel.text = nil
        newsTextLabel.text = nil
    }
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        model.isFavorite = true
        favoriteButton.tintColor = .yellow
        delegate.addToFavorite(model)
    }
    
}
