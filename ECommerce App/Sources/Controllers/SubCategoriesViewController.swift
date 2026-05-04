import UIKit
import SDWebImage

class SubCategoriesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - ViewModel
    private var viewModel = SubcategoryViewModel()
    private var subcategories = [Subcategories]()
    var category: Categories?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewDidLoad()
    }
    
    func setupViewDidLoad() {
        self.title = category?.name ?? ""
        
        showLoader()
        viewModel.fetchSubcategories(category?.category_id ?? "")
        
        bindViewModel()
    }
    
    // MARK: - Bind ViewModel Callbacks
    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] response in
            self?.hideLoader()
            self?.subcategories = response.data ?? []
            self?.collectionView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.hideLoader()
            AlertHelper.showAlert(on: self ?? UIViewController(), title: AlertTitle.error, message: errorMessage)
        }
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension SubCategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subcategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.SubCategoriesCell, for: indexPath) as! SubCategoriesCell
        
        let subcategory = subcategories[indexPath.row]
        
        if let imageUrl = URL(string: "\(API.baseURL)\(subcategory.sub_category_image ?? "")") {
            cell.subcategoryImage.sd_setImage(with: imageUrl)
        }
        
        cell.titleLabel.text = subcategory.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 8, height: 236)
    }
}
