import UIKit
import TVSetKit

class MoviesSubFilterTableViewController: UITableViewController {
  static let SegueIdentifier = "Filter By Movie"
  let CellIdentifier = "MovieSubFilterTableCell"

  let localizer = Localizer(MyHitServiceAdapter.BundleId, bundleClass: MyHitSite.self)

#if os(iOS)
  public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
#endif

  var selectedItem: MediaItem?

  private var items = Items()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    items.pageLoader.load = {
      let adapter = MyHitServiceAdapter(mobile: true)
      adapter.params["requestType"] = "Movies Subfilter"
      adapter.params["selectedItem"] = self.selectedItem

      return try adapter.load()
    }

    tableView?.backgroundView = activityIndicatorView
    items.pageLoader.spinner = PlainSpinner(activityIndicatorView)

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
    performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameTableCell,
             let indexPath = tableView.indexPath(for: view) {

            let adapter = MyHitServiceAdapter(mobile: true)

            destination.params["requestType"] = "Movies"
            destination.params["selectedItem"] = items.getItem(for: indexPath)

            destination.adapter = adapter
            destination.configuration = adapter.getConfiguration()
          }

        default: break
      }
    }
  }

}
