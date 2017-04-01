import UIKit
import SwiftyJSON
import TVSetKit

open class MyHitTableViewController: MyHitBaseTableViewController {
  override open var CellIdentifier: String { return "MyHitTableCell" }

  let MainMenuItems = [
    "Bookmarks",
    "History",
    "All Movies",
    "Popular Movies",
    "All Series",
    "Popular Series",
    "Selections",
//    "Soundtracks",
    "Filters By Movies",
    "Filters By Series",
    "Settings",
    "Search"
  ]

  override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("MyHit")

    adapter = MyHitServiceAdapter(mobile: true)

    self.clearsSelectionOnViewWillAppear = false

    for name in MainMenuItems {
      let item = MediaItem(name: name)

      items.append(item)
    }
  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    switch mediaItem.name! {
      case "Filters By Movies":
        performSegue(withIdentifier: "Filter By Movies", sender: view)

      case "Filters By Series":
        performSegue(withIdentifier: "Filter By Series", sender: view)

      case "Settings":
        performSegue(withIdentifier: "Settings", sender: view)

      case "Search":
        performSegue(withIdentifier: SearchTableController.SegueIdentifier, sender: view)

      default:
        performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
    }
  }

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameTableCell {

            let mediaItem = getItem(for: view)

            let adapter = MyHitServiceAdapter(mobile: true)

            adapter.requestType = mediaItem.name
            adapter.parentName = localizer.localize(mediaItem.name!)

            destination.adapter = adapter
          }

        case SearchTableController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SearchTableController {

            let adapter = MyHitServiceAdapter(mobile: true)

            adapter.requestType = "Search"
            adapter.parentName = localizer.localize("Search Results")

            destination.adapter = adapter
          }

        default: break
      }
    }
  }
}
