import UIKit
import TVSetKit

class MoviesSubFilterController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  static let SegueIdentifier = "Filter By Movie"
  let CellIdentifier = "MovieSubFilterCell"
  let StoryboardId = "MyHit"

  let localizer = Localizer(MyHitServiceAdapter.BundleId, bundleClass: MyHitSite.self)

#if os(tvOS)
  public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
#endif

  var adapter = MyHitServiceAdapter()
  
  public var params = Parameters()
  private var items = Items()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    setupLayout()

    #if os(tvOS)
      collectionView?.backgroundView = activityIndicatorView
      items.pageLoader.spinner = PlainSpinner(activityIndicatorView)
    #endif
    
    items.pageLoader.load = {
      let adapter = MyHitServiceAdapter()
      destination.params["requestType"] = "Movies Subfilter"

      return try adapter.load()
    }
    
    items.loadInitialData(collectionView) { result in
      for item in result {
        item.name = self.localizer.localize(item.name!)
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

  @objc func tapped(_ gesture: UITapGestureRecognizer) {
    if let destination = MediaItemsController.instantiateController(StoryboardId),
       let selectedCell = gesture.view as? MediaNameCell,
       let indexPath = collectionView?.indexPath(for: selectedCell) {
      let adapter = MyHitServiceAdapter()
      
      destination.params["requestType"] = "Movies"
      destination.params["selectedItem"] = items.getItem(for: indexPath)

      destination.configuration = adapter.getConfiguration()

      if let layout = adapter.buildLayout() {
        destination.collectionView?.collectionViewLayout = layout
      }

      self.show(destination, sender: destination)
    }
  }

}
