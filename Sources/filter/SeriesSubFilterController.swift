import UIKit
import TVSetKit

class SeriesSubFilterController: InfiniteCollectionViewController {
  static let SegueIdentifier = "FilterBySerie"
  let CellIdentifier = "SerieSubFilterCell"

  var localizer = Localizer("com.rubikon.MyHitSite")

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

    loadInitialData() { result in
      for item in result {
        item.name = self.localizer.localize(item.name!)
      }
    }
  }

  // MARK: UICollectionViewDataSource

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! MediaNameCell

    let item = items[indexPath.row]

    let localizedName = localizer.localize(item.name!)

    cell.configureCell(item: item, localizedName: localizedName, target: self)
    CellHelper.shared.addGestureRecognizer(view: cell, target: self, action: #selector(self.tapped(_:)))

    return cell
  }

  func tapped(_ gesture: UITapGestureRecognizer) {
    let selectedCell = gesture.view as! MediaNameCell

    let controller = MediaItemsController.instantiate().getActionController()
    let destination = controller as! MediaItemsController

    adapter.requestType = "SERIES"
    adapter.selectedItem = getItem(for: selectedCell)

    destination.adapter = adapter

    destination.collectionView?.collectionViewLayout = adapter.buildLayout()!

    self.show(controller!, sender: destination)
  }

}
