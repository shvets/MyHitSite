import UIKit
import TVSetKit

class SeriesFilterController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  static let SegueIdentifier = "Filter By Series"
  let CellIdentifier = "SerieFilterCell"

  let localizer = Localizer(MyHitServiceAdapter.BundleId, bundleClass: MyHitSite.self)

#if os(tvOS)
  public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
#endif

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
      adapter.params["requestType"] = "Series Filter"

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

          let adapter = MyHitServiceAdapter()

          destination.params["requestType"] = "Series Subfilter"
          destination.params["selectedItem"] = items.getItem(for: indexPath)

          destination.adapter = adapter
        }

      default: break
      }
    }
  }
}
