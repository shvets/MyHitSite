import UIKit
import TVSetKit

class SeriesSubFilterTableViewController: MyHitBaseTableViewController {
  static let SegueIdentifier = "FilterBySerie"

  override open var CellIdentifier: String { return "SerieSubFilterTableCell" }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    tableView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData()
//    { result in
//      for item in result {
//        item.name = self.localizer.localize(item.name!)
//      }
//    }
  }

  // MARK: UICollectionViewDataSource

//  override func numberOfSections(in collectionView: UICollectionView) -> Int {
//    return 1
//  }
//
//  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return items.count
//  }

//  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! MediaNameCell
//
//    let item = items[indexPath.row]
//
//    let localizedName = localizer.localize(item.name!)
//
//    cell.configureCell(item: item, localizedName: localizedName, target: self)
//    CellHelper.shared.addGestureRecognizer(view: cell, target: self, action: #selector(self.tapped(_:)))
//
//    return cell
//  }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case MediaItemsController.SegueIdentifier:
        if let destination = segue.destination.getActionController() as? MediaItemsController,
           let view = sender as? MediaNameTableCell {

          let adapter = MyHitServiceAdapter()

          adapter.requestType = "SERIES"
          adapter.selectedItem = getItem(for: view)

          destination.adapter = adapter
        }

      default: break
      }
    }
  }

}
