import UIKit
import SwiftyJSON
import TVSetKit
import PageLoader

open class MyHitTableViewController: UITableViewController {
  let CellIdentifier = "MyHitTableCell"

  let localizer = Localizer(MyHitService.BundleId, bundleClass: MyHitSite.self)

  let service = MyHitService(true)
  let pageLoader = PageLoader()
  private var items = Items()

  override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("MyHit")

    title = localizer.localize("Archive")

    pageLoader.load = {
      return self.loadData()
    }

    pageLoader.loadData { result in
      if let items = result as? [Item] {
        self.items.items = items

        self.tableView?.reloadData()
      }
    }
  }

  func loadData() -> [Item] {
    var items = [Item]()

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

    return items
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
    if let view = tableView.cellForRow(at: indexPath),
       let indexPath = tableView.indexPath(for: view) {
      let mediaItem = items.getItem(for: indexPath)

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
  }

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameTableCell,
             let indexPath = tableView.indexPath(for: view) {

            let mediaItem = items.getItem(for: indexPath)

//            adapter.pageLoader.pageSize = 25
//            adapter.pageLoader.rowSize = 1

            destination.params["requestType"] = mediaItem.name
            destination.params["parentName"] = localizer.localize(mediaItem.name!)

            destination.configuration = service.getConfiguration()
          }

        case SearchTableController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SearchTableController {
            destination.params["requestType"] = "Search"
            destination.params["parentName"] = localizer.localize("Search Results")

            destination.configuration = service.getConfiguration()
          }

        default: break
      }
    }
  }
}
