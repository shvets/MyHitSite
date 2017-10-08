import UIKit
import TVSetKit

class SeriesFilterController: MyHitBaseCollectionViewController {
  static let SegueIdentifier = "Filter By Series"

  override open var CellIdentifier: String { return "SerieFilterCell" }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    let layout = UICollectionViewFlowLayout()

    layout.itemSize = CGSize(width: 450, height: 150)
    layout.sectionInset = UIEdgeInsets(top: 150.0, left: 20.0, bottom: 50.0, right: 20.0)
    layout.minimumInteritemSpacing = 20.0
    layout.minimumLineSpacing = 100.0

    collectionView?.collectionViewLayout = layout

    adapter = MyHitServiceAdapter()
    adapter.params["requestType"] = "Series Filter"

    collectionView?.backgroundView = activityIndicatorView
    adapter.pageLoader.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData { result in
      for item in result {
        (item as! MediaName).name = self.localizer.localize((item as! MediaName).name!)
      }
    }
  }

  override public func tapped(_ gesture: UITapGestureRecognizer) {
    performSegue(withIdentifier: SeriesSubFilterController.SegueIdentifier, sender: gesture.view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case SeriesSubFilterController.SegueIdentifier:
        if let destination = segue.destination as? SeriesSubFilterController,
           let selectedCell = sender as? MediaNameCell {
          adapter.params["requestType"] = "Series Subfilter"
          adapter.params["selectedItem"] = getItem(for: selectedCell)

          destination.adapter = adapter
        }

      default: break
      }
    }
  }
}
