import UIKit
import TVSetKit

class MoviesSubFilterController: InfiniteCollectionViewController {
  static let SegueIdentifier = "FilterByMovie"
  let CellIdentifier = "MovieSubFilterCell"

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
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! MovieSubFilterCell

    if adapter.nextPageAvailable(dataCount: items.count, index: indexPath.row) {
      loadMoreData(indexPath.row)
    }

    let item = items[indexPath.row]

    let bundle = Bundle(identifier: "com.rubikon.MyHitSite")!

    let localizedName = adapter?.languageManager?.localize(item.name!, bundle: bundle) ?? "Unknown"

    cell.configureCell(item: item, localizedName: localizedName, target: self, action: #selector(self.tapped(_:)))

    return cell
  }

  func tapped(_ gesture: UITapGestureRecognizer) {
    let selectedCell = gesture.view as! MovieSubFilterCell

    let destination = MediaItemsController.instantiate()

    adapter.requestType = "MOVIES"
    adapter.selectedItem = selectedCell.item

    destination.adapter = adapter

    destination.collectionView?.collectionViewLayout = adapter.buildLayout()!

    self.show(destination, sender: destination)
  }

}
