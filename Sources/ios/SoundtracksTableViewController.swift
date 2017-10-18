import UIKit
import TVSetKit

class SoundtracksTableViewController: UITableViewController {
  static let SegueIdentifier = "Soundtracks"
  let CellIdentifier =  "SoundtrackTableCell"
  //override open var BundleId: String { return MyHitServiceAdapter.BundleId }

  let localizer = Localizer(MyHitServiceAdapter.BundleId, bundleClass: MyHitSite.self)

  private var items = Items()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    items.pageLoader.load = {
      let adapter = MyHitServiceAdapter(mobile: true)

      return try adapter.load()
    }

    items.loadInitialData(tableView)
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

            destination.params["requestType"] = "Albums"
            destination.params["selectedItem"] = items.getItem(for: indexPath)

            destination.adapter = adapter
            destination.configuration = adapter.getConfiguration()
          }

        default: break
      }
    }
  }
}
