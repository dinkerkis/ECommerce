import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    // MARK: - Outlets (View)
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - ViewModel
    private var viewModel = HomeViewModel()
    private var categories = [Categories]()
    private var timer: Timer?
    private var currentIndex = 0
    private var colors = [UIColor.red, UIColor.blue, UIColor.green]
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        
        showLoader()
        viewModel.fetchCategories()
        
        bindViewModel()
        startAutoScroll()
    }

    // MARK: - Bind ViewModel Callbacks
    private func bindViewModel() {
        viewModel.onSuccess = { [weak self] response in
            self?.hideLoader()
            self?.categories = response.data ?? []
            self?.collectionView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.hideLoader()
            AlertHelper.showAlert(on: self ?? UIViewController(), title: AlertTitle.error, message: errorMessage)
        }
    }
    
    // MARK: - COLLECTION VIEW LAYOUT
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(180))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                
                // Collection view footer
                let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize( widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                
                section.boundarySupplementaryItems = [footer]
                
                // Handle page control
                section.visibleItemsInvalidationHandler = { [weak self] visibleItems, offset, environment in
                    guard let self = self else { return }
                    
                    let pageWidth = environment.container.contentSize.width
                    if pageWidth == 0 { return }
                    
                    let page = Int(round(offset.x / pageWidth))
                    
                    self.currentIndex = page
                    
                    DispatchQueue.main.async {
                        self.updatePageControl(page: page)
                    }
                }
                
                return section
            }
            else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(180))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(180)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            }
        }
    }
    
    func updatePageControl(page: Int) {
        let indexPath = IndexPath(item: 0, section: 0)
        
        if let footer = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: indexPath) as? HomeFooterView {
            
            footer.pageControl.currentPage = page
        }
    }
    
    func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            self?.scrollToNext()
        }
    }
    
    func collectionViewScrollToItem() {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        updatePageControl(page: currentIndex)
    }
    
    func scrollToNext() {
        if currentIndex < colors.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        
        collectionViewScrollToItem()
    }
    
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        currentIndex = sender.currentPage
        collectionViewScrollToItem()
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return colors.count
        }
        else {
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.HomeHeaderCell, for: indexPath) as! HomeHeaderCell
            
            cell.headerImage.backgroundColor = colors[indexPath.row]
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.HomeCategoriesCell, for: indexPath) as! HomeCategoriesCell
            
            let category = categories[indexPath.row]
            
            if let imageUrl = URL(string: "\(API.baseURL)\(category.category_image ?? "")") {
                cell.categoryImage.sd_setImage(with: imageUrl)
            }
            
            cell.titleLabel.text = category.name
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter, indexPath.section == 0 {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellIds.HomeFooterView, for: indexPath) as! HomeFooterView
            
            footer.pageControl.numberOfPages = colors.count
            footer.pageControl.currentPage = currentIndex
            footer.pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
            
            return footer
        }
        
        return UICollectionReusableView()
    }
}
