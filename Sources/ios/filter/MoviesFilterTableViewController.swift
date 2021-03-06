import UIKit
import TVSetKit
import PageLoader

class MoviesFilterTableViewController: UITableViewController {
  static let SegueIdentifier = "Filter By Movies"
  let CellIdentifier = "MovieFilterTableCell"

  let localizer = Localizer(MyHitService.BundleId, bundleClass: MyHitSite.self)

  #if os(iOS)
  public let activityIndicatorView = UIActivityIndicatorView(style: .gray)
  #endif
  
  let service = MyHitService(true)

  let pageLoader = PageLoader()
  
  private var items = Items()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    #if os(iOS)
      tableView?.backgroundView = activityIndicatorView
      pageLoader.spinner = PlainSpinner(activityIndicatorView)
    #endif
    
    func load() throws -> [Any] {
      var params = Parameters()
      params["requestType"] = "Movies Filter"
      //params["pageSize"] = self.service.getConfiguration()["pageSize"] as! Int

      return try self.service.dataSource.loadAndWait(params: params)
    }

    pageLoader.loadData(onLoad: load) { result in
      if let items = result as? [Item] {
        self.items.items = items

        for item in items {
          item.name = self.localizer.localize(item.name!)
        }

        self.tableView?.reloadData()
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
    performSegue(withIdentifier: MoviesSubFilterTableViewController.SegueIdentifier, sender: view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MoviesSubFilterTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MoviesSubFilterTableViewController,
             let view = sender as? MediaNameTableCell,
             let indexPath = tableView.indexPath(for: view) {

            destination.selectedItem = items.getItem(for: indexPath) as? MediaItem
          }

        default: break
      }
    }
  }

}
