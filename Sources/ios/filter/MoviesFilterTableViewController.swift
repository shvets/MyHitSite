import UIKit
import TVSetKit

class MoviesFilterTableViewController: MyHitBaseTableViewController {
  static let SegueIdentifier = "FilterByMovies"

  override open var CellIdentifier: String { return "MovieFilterTableCell" }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    adapter = MyHitServiceAdapter()
    adapter.requestType = "MOVIES_FILTER"

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
//
//  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! MediaNameCell
//
//    if adapter.nextPageAvailable(dataCount: items.count, index: indexPath.row) {
//      loadMoreData(indexPath.row)
//    }
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
    performSegue(withIdentifier: MoviesSubFilterController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MoviesSubFilterController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MoviesSubFilterController,
             let view = sender as? MediaNameTableCell {

            let adapter = MyHitServiceAdapter()

            adapter.requestType = "MOVIES_SUB_FILTER"
            adapter.selectedItem = getItem(for: view)

            destination.adapter = adapter
          }

        default: break
      }
    }
  }

}
