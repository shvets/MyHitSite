import UIKit
import SwiftyJSON
import TVSetKit

open class MyHitController: MyHitBaseCollectionViewController {
  override open var CellIdentifier: String { return "MyHitCell" }

 override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    let layout = UICollectionViewFlowLayout()

    layout.itemSize = CGSize(width: 450, height: 150)
    layout.sectionInset = UIEdgeInsets(top: 150.0, left: 20.0, bottom: 50.0, right: 20.0)
    layout.minimumInteritemSpacing = 20.0
    layout.minimumLineSpacing = 100.0

    collectionView?.collectionViewLayout = layout

    adapter = MyHitServiceAdapter()

    self.clearsSelectionOnViewWillAppear = false

//    for name in MainMenuItems {
//      let item = MediaItem(name: name)
//
//      items.append(item)
//    }
    loadData()
  }

  func loadData() {
    items.append(MediaItem(name: "Bookmarks", imageName: "Star"))
    items.append(MediaItem(name: "History", imageName: "Bookmark"))
    items.append(MediaItem(name: "All Movies", imageName: "Retro TV"))
    items.append(MediaItem(name: "Popular Movies", imageName: "Retro TV Filled"))
    items.append(MediaItem(name: "All Series", imageName: "Retro TV"))
    items.append(MediaItem(name: "Popular Series", imageName: "Retro TV Filled"))
    items.append(MediaItem(name: "Selections", imageName: "Chisel Tip Marker"))
    items.append(MediaItem(name: "Filters By Movies", imageName: "Filter"))
    items.append(MediaItem(name: "Filters By Series", imageName: "Filter"))
    items.append(MediaItem(name: "Settings", imageName: "Engineering"))
    items.append(MediaItem(name: "Search", imageName: "Search"))
  }

  override open func navigate(from view: UICollectionViewCell, playImmediately: Bool=false) {
    let mediaItem = getItem(for: view)

    switch mediaItem.name! {
      case "Filters By Movies":
        performSegue(withIdentifier: "Filter By Movies", sender: view)

      case "Filters By Series":
        performSegue(withIdentifier: "Filter By Series", sender: view)

      case "Settings":
        performSegue(withIdentifier: "Settings", sender: view)

      case "Search":
        performSegue(withIdentifier: SearchController.SegueIdentifier, sender: view)

      default:
        performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
    }
  }

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameCell {

            let mediaItem = getItem(for: view)

            let adapter = MyHitServiceAdapter()

            adapter.params.requestType = mediaItem.name
            adapter.params.parentName = localizer.localize(mediaItem.name!)

            destination.adapter = adapter
            destination.collectionView?.collectionViewLayout = adapter.buildLayout()!
          }

        case SearchController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SearchController {

            let adapter = MyHitServiceAdapter()

            adapter.params.requestType = "Search"
            adapter.params.parentName = localizer.localize("Search Results")

            destination.adapter = adapter
          }

        default: break
      }
    }
  }
}
