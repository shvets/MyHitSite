import UIKit
import TVSetKit

class MoviesFilterController: MyHitBaseCollectionViewController {
  static let SegueIdentifier = "Filter By Movies"

  override open var CellIdentifier: String { return "MovieFilterCell" }

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
    adapter.requestType = "Movies Filter"

    collectionView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData() { result in
      for item in result {
        item.name = self.localizer.localize(item.name!)
      }
    }
  }

  override public func tapped(_ gesture: UITapGestureRecognizer) {
    performSegue(withIdentifier: MoviesSubFilterController.SegueIdentifier, sender: gesture.view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MoviesSubFilterController.SegueIdentifier:
          if let destination = segue.destination as? MoviesSubFilterController,
             let selectedCell = sender as? MediaNameCell {
            adapter.clear()
            adapter.requestType = "Movies Subfilter"
            adapter.selectedItem = getItem(for: selectedCell)

            destination.adapter = adapter
          }

        default: break
      }
    }
  }
}
