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

    loadInitialData() { result in
      for item in result {
        item.name = self.localizer.localize(item.name!)
      }
    }
  }

//    if adapter.nextPageAvailable(dataCount: items.count, index: indexPath.row) {
//      loadMoreData(indexPath.row)
//    }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: MoviesSubFilterTableViewController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MoviesSubFilterTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MoviesSubFilterTableViewController,
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
