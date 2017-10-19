import UIKit
import TVSetKit

class SeriesSubFilterController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  static let SegueIdentifier = "Filter By Serie"
  let CellIdentifier = "SerieSubFilterCell"
  let StoryboardId = "MyHit"
  
  let localizer = Localizer(MyHitService.BundleId, bundleClass: MyHitSite.self)

  let service = MyHitService()

#if os(tvOS)
  public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
#endif

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
      var params = Parameters()
      params["requestType"] = "Series Subfilter"
      //params["selectedItem"] = self.selectedItem
      //params["pageSize"] = self.service.getConfiguration()["pageSize"] as! Int

      return try self.service.dataSource.load(params: params)
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

  @objc  func tapped(_ gesture: UITapGestureRecognizer) {
    if let destination = MediaItemsController.instantiateController(StoryboardId),
       let selectedCell = gesture.view as? MediaNameCell,
       let indexPath = collectionView?.indexPath(for: selectedCell) {

      destination.params["requestType"] = "Series"
      destination.params["selectedItem"] = items.getItem(for: indexPath)

      destination.configuration = service.getConfiguration()

      if let layout = service.buildLayout() {
        destination.collectionView?.collectionViewLayout = layout
      }

      self.show(destination, sender: destination)
    }
  }

}
