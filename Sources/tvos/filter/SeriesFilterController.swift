import UIKit
import TVSetKit
import PageLoader

class SeriesFilterController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  static let SegueIdentifier = "Filter By Series"
  let CellIdentifier = "SerieFilterCell"

  let localizer = Localizer(MyHitService.BundleId, bundleClass: MyHitSite.self)

  #if os(tvOS)
    public let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
  #endif
  
  let service = MyHitService()

  let pageLoader = PageLoader()
  
  private var items = Items()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    setupLayout()

    #if os(tvOS)
      collectionView?.backgroundView = activityIndicatorView
      //items.pageLoader.spinner = PlainSpinner(activityIndicatorView)
    #endif
    
    func load() throws -> [Any] {
      var params = Parameters()
      params["requestType"] = "Series Filter"
      //params["pageSize"] = self.service.getConfiguration()["pageSize"] as! Int

      return try self.service.dataSource.loadAndWait(params: params)
    }

    pageLoader.loadData(onLoad: load) { result in
      if let items = result as? [Item] {
        self.items.items = items

        for item in items {
          item.name = self.localizer.localize(item.name!)
        }

        self.collectionView?.reloadData()
      }
    }
  }

  func setupLayout() {
    let layout = UICollectionViewFlowLayout()

    layout.itemSize = CGSize(width: 450, height: 150)
    layout.sectionInset = UIEdgeInsets(top: 150.0, left: 20.0, bottom: 50.0, right: 20.0)
    layout.minimumInteritemSpacing = 20.0
    layout.minimumLineSpacing = 100.0

    collectionView?.collectionViewLayout = layout
  }

  // MARK: UICollectionViewDataSource

  override open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as? MediaNameCell {
      if let item = items[indexPath.row] as? MediaName {
         cell.configureCell(item: item, localizedName: localizer.getLocalizedName(item.name), target: self)
      }

      CellHelper.shared.addTapGestureRecognizer(view: cell, target: self, action: #selector(self.tapped(_:)))

      return cell
    }
    else {
      return UICollectionViewCell()
    }
  }

  @objc  func tapped(_ gesture: UITapGestureRecognizer) {
    performSegue(withIdentifier: SeriesSubFilterController.SegueIdentifier, sender: gesture.view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case SeriesSubFilterController.SegueIdentifier:
        if let destination = segue.destination as? SeriesSubFilterController,
           let selectedCell = sender as? MediaNameCell,
           let indexPath = collectionView?.indexPath(for: selectedCell) {

          destination.params["selectedItem"] = items.getItem(for: indexPath)
        }

      default: break
      }
    }
  }
}
