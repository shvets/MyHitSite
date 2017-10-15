import UIKit
import TVSetKit

class MoviesSubFilterController: MyHitBaseCollectionViewController {
  static let SegueIdentifier = "Filter By Movie"

  override open var CellIdentifier: String { return "MovieSubFilterCell" }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    let layout = UICollectionViewFlowLayout()

    layout.itemSize = CGSize(width: 450, height: 150)
    layout.sectionInset = UIEdgeInsets(top: 150.0, left: 20.0, bottom: 50.0, right: 20.0)
    layout.minimumInteritemSpacing = 20.0
    layout.minimumLineSpacing = 100.0

    collectionView?.collectionViewLayout = layout

    collectionView?.backgroundView = activityIndicatorView
    adapter.pageLoader.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData { result in
      for item in result {
        item.name = self.localizer.localize(item.name!)
      }
    }
  }

  override public func tapped(_ gesture: UITapGestureRecognizer) {
    if let destination = MediaItemsController.instantiateController(adapter),
       let selectedCell = gesture.view as? MediaNameCell {
      adapter.params["requestType"] = "Movies"
      adapter.params["selectedItem"] = getItem(for: selectedCell)

      destination.adapter = adapter
      //destination.configuration = adapter.getConfiguration()

      if let layout = adapter.buildLayout() {
        destination.collectionView?.collectionViewLayout = layout
      }

      self.show(destination, sender: destination)
    }
  }

}
