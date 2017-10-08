import UIKit
import SwiftyJSON
import TVSetKit

open class MyHitTableViewController: MyHitBaseTableViewController {
  override open var CellIdentifier: String { return "MyHitTableCell" }

  override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("MyHit")

    adapter = MyHitServiceAdapter(mobile: true)

    self.clearsSelectionOnViewWillAppear = false

    loadData()
  }

  func loadData() {
    items.append(MediaName(name: "Bookmarks", imageName: "Star"))
    items.append(MediaName(name: "History", imageName: "Bookmark"))
    items.append(MediaName(name: "All Movies", imageName: "Retro TV"))
    items.append(MediaName(name: "Popular Movies", imageName: "Retro TV Filled"))
    items.append(MediaName(name: "All Series", imageName: "Retro TV"))
    items.append(MediaName(name: "Popular Series", imageName: "Retro TV Filled"))
    items.append(MediaName(name: "Selections", imageName: "Chisel Tip Marker"))
    items.append(MediaName(name: "Soundtracks", imageName: "Chisel Tip Marker"))
    items.append(MediaName(name: "Filters By Movies", imageName: "Filter"))
    items.append(MediaName(name: "Filters By Series", imageName: "Filter"))
    items.append(MediaName(name: "Settings", imageName: "Engineering"))
    items.append(MediaName(name: "Search", imageName: "Search"))
  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    switch mediaItem.name! {
      case "Filters By Movies":
        performSegue(withIdentifier: "Filter By Movies", sender: view)

      case "Filters By Series":
        performSegue(withIdentifier: "Filter By Series", sender: view)

//      case "Soundtracks":
//        performSegue(withIdentifier: "Soundtracks", sender: view)

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
            adapter.pageLoader.pageSize = 25
            adapter.pageLoader.rowSize = 1

            adapter.params["requestType"] = mediaItem.name
            adapter.params["parentName"] = localizer.localize(mediaItem.name!)

            destination.adapter = adapter
          }

        case SearchTableController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SearchTableController {

            let adapter = MyHitServiceAdapter(mobile: true)

            adapter.params["requestType"] = "Search"
            adapter.params["parentName"] = localizer.localize("Search Results")

            destination.adapter = adapter
          }

        default: break
      }
    }
  }
}
