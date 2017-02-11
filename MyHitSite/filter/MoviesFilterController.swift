import UIKit
import TVSetKit

class MoviesFilterController: InfiniteCollectionViewController {
  static let SEGUE_IDENTIFIER = "FilterByMovies"
  let CELL_IDENTIFIER = "MovieFilterCell"

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    let layout = UICollectionViewFlowLayout()

    layout.itemSize = CGSize(width: 450, height: 150)
    layout.sectionInset = UIEdgeInsets(top: 150.0, left: 20.0, bottom: 50.0, right: 20.0)
    layout.minimumInteritemSpacing = 30.0
    layout.minimumLineSpacing = 100.0

    collectionView?.collectionViewLayout = layout

    adapter = MyHitServiceAdapter()
    adapter.requestType = "MOVIES_FILTER"

    collectionView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData()
  }

  // MARK: UICollectionViewDataSource

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER, for: indexPath) as! MovieFilterCell

    if adapter.nextPageAvailable(dataCount: items.count, index: indexPath.row) {
      loadMoreData(indexPath.row)
    }

    let item = items[indexPath.row]

    let localizedName = adapter?.languageManager?.localize(item.name!) ?? "Unknown"

    cell.configureCell(item: item, localizedName: localizedName, target: self, action: #selector(self.tapped(_:)))

    return cell
  }

  func tapped(_ gesture: UITapGestureRecognizer) {
    performSegue(withIdentifier: MoviesSubFilterController.SEGUE_IDENTIFIER, sender: gesture.view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MoviesSubFilterController.SEGUE_IDENTIFIER:
          if let destination = segue.destination as? MoviesSubFilterController,
             let selectedCell = sender as? MovieFilterCell {
            adapter.clear()
            adapter.requestType = "MOVIES_SUB_FILTER"
            adapter.selectedItem = selectedCell.item

            destination.adapter = adapter
          }

        default: break
      }
    }
  }
}
