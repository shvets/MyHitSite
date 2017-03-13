import UIKit
import SwiftyJSON
import TVSetKit

open class MyHitTableViewController: MyHitBaseTableViewController {
  override open var CellIdentifier: String { return "MyHitTableCell" }

  let MainMenuItems = [
    "BOOKMARKS",
    "HISTORY",
    "ALL_MOVIES",
    "POPULAR_MOVIES",
    "ALL_SERIES",
    "POPULAR_SERIES",
    "SELECTIONS",
//    "SOUNDTRACKS",
    "FILTER_BY_MOVIES",
    "FILTER_BY_SERIES",
    "SEARCH",
    "SETTINGS"
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
      case "FILTER_BY_MOVIES":
        performSegue(withIdentifier: "FilterByMovies", sender: view)

      case "FILTER_BY_SERIES":
        performSegue(withIdentifier: "FilterBySeries", sender: view)

      case "SETTINGS":
        performSegue(withIdentifier: "Settings", sender: view)

      case "SEARCH":
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

            adapter.requestType = "SEARCH"
            adapter.parentName = localizer.localize("SEARCH_RESULTS")

            destination.adapter = adapter
          }

        default: break
      }
    }
  }
}
