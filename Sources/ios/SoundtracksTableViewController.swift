import UIKit
import TVSetKit

class SoundtracksTableViewController: MyHitBaseTableViewController {
  static let SegueIdentifier = "Soundtracks"

  override open var CellIdentifier: String { return "SoundtrackTableCell" }
  override open var BundleId: String { return MyHitServiceAdapter.BundleId }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    loadInitialData()
  }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameTableCell {

            let adapter = MyHitServiceAdapter(mobile: true)

            adapter.params["requestType"] = "Albums"
            adapter.params["selectedItem"] = getItem(for: view)

            destination.adapter = adapter
            destination.configuration = adapter.getConfiguration()
          }

        default: break
      }
    }
  }
}
