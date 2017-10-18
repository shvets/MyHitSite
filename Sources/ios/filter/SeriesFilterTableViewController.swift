import UIKit
import TVSetKit

class SeriesFilterTableViewController: UITableViewController {
  static let SegueIdentifier = "Filter By Series"
  let CellIdentifier = "SerieFilterTableCell"

  let localizer = Localizer(MyHitServiceAdapter.BundleId, bundleClass: MyHitSite.self)

#if os(iOS)
  public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
#endif

  private var items = Items()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    #if os(iOS)
      tableView?.backgroundView = activityIndicatorView
      items.pageLoader.spinner = PlainSpinner(activityIndicatorView)
    #endif
    
    items.pageLoader.load = {
      let adapter = MyHitServiceAdapter(mobile: true)
      adapter.params["requestType"] = "Series Filter"

      return try adapter.load()
    }

    items.loadInitialData(tableView) { result in
      for item in result {
        item.name = self.localizer.localize(item.name!)
      }
    }
  }

  // MARK: UITableViewDataSource

  override open func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as? MediaNameTableCell {
      let item = items[indexPath.row]

      cell.configureCell(item: item, localizedName: localizer.getLocalizedName(item.name))

      return cell
    }
    else {
      return UITableViewCell()
    }
  }

  override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: SeriesSubFilterTableViewController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case SeriesSubFilterTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SeriesSubFilterTableViewController,
             let view = sender as? MediaNameTableCell,
            let indexPath = tableView.indexPath(for: view) {

            destination.selectedItem = items.getItem(for: indexPath) as? MediaItem
          }

        default: break
      }
    }
  }

}
