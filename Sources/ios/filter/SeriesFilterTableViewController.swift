import UIKit
import TVSetKit

class SeriesFilterTableViewController: MyHitBaseTableViewController {
  static let SegueIdentifier = "FilterBySeries"

  override open var CellIdentifier: String { return "SerieFilterTableCell" }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    adapter = MyHitServiceAdapter()
    adapter.requestType = "SERIES_FILTER"

    tableView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData() { result in
      for item in result {
        item.name = self.localizer.localize(item.name!)
      }
    }
  }

//    if adapter.nextPageAvailable(dataCount: items.count, index: indexPath.row) {
//      loadMoreData(indexPath.row)
//    }
//

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: SeriesSubFilterTableViewController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case SeriesSubFilterTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SeriesSubFilterTableViewController,
             let view = sender as? MediaNameTableCell {

            let adapter = MyHitServiceAdapter()

            adapter.requestType = "SERIES_SUB_FILTER"
            adapter.selectedItem = getItem(for: view)

            destination.adapter = adapter
          }

        default: break
      }
    }
  }

}
