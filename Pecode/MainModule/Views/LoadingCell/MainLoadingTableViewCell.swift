import UIKit

class MainLoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        configureLayout()
    }
    
    private func configureLayout() {
        self.backgroundColor = #colorLiteral(red: 0.156837225, green: 0.1632107198, blue: 0.1931262016, alpha: 1)
    }
    
}
