import UIKit
import TVSetKit
import PageLoader

class SoundtracksTableViewController: UITableViewController {
  static let SegueIdentifier = "Soundtracks"
  let CellIdentifier =  "SoundtrackTableCell"

  let localizer = Localizer(MyHitService.BundleId, bundleClass: MyHitSite.self)

  let service = MyHitService(true)
  let pageLoader = PageLoader()
  private var items = Items()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    func load() throws -> [Any] {
      var params = Parameters()
      params["requestType"] = "Soundtracks"
      //params["pageSize"] = self.service.getConfiguration()["pageSize"] as! Int

      return try self.service.dataSource.load(params: params)
    }

    pageLoader.loadData(onLoad: load) { result in
      if let items = result as? [Item] {
        self.items.items = items

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
    performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameTableCell,
             let indexPath = tableView.indexPath(for: view) {

            destination.params["requestType"] = "Albums"
            destination.params["selectedItem"] = items.getItem(for: indexPath)

            destination.configuration = service.getConfiguration()
          }

        default: break
      }
    }
  }
}
