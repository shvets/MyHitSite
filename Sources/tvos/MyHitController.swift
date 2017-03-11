import UIKit
import SwiftyJSON
import TVSetKit

open class MyHitController: MyHitCollectionViewController {
  override open var CellIdentifier: String { return "MyHitCell" }

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

    localizer = Localizer("com.rubikon.MyHitSite")

    self.clearsSelectionOnViewWillAppear = false

    let layout = UICollectionViewFlowLayout()

    layout.itemSize = CGSize(width: 450, height: 150)
    layout.sectionInset = UIEdgeInsets(top: 150.0, left: 20.0, bottom: 50.0, right: 20.0)
    layout.minimumInteritemSpacing = 20.0
    layout.minimumLineSpacing = 100.0

    collectionView?.collectionViewLayout = layout

    adapter = MyHitServiceAdapter()

    self.clearsSelectionOnViewWillAppear = false

    for name in MainMenuItems {
      let item = MediaItem(name: name)

      items.append(item)
    }
  }

  override open func navigate(from view: UICollectionViewCell, playImmediately: Bool=false) {
    let mediaItem = getItem(for: view)

    switch mediaItem.name! {
      case "FILTER_BY_MOVIES":
        performSegue(withIdentifier: "FilterByMovies", sender: view)

      case "FILTER_BY_SERIES":
        performSegue(withIdentifier: "FilterBySeries", sender: view)

      case "SETTINGS":
        performSegue(withIdentifier: "Settings", sender: view)

      case "SEARCH":
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

            adapter.requestType = mediaItem.name
            adapter.parentName = localizer?.localize(mediaItem.name!)

            destination.adapter = adapter
            destination.collectionView?.collectionViewLayout = adapter.buildLayout()!
          }

        case SearchController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SearchController {

            let adapter = MyHitServiceAdapter()

            adapter.requestType = "SEARCH"
            adapter.parentName = localizer?.localize("SEARCH_RESULTS")

            destination.adapter = adapter
          }

        default: break
      }
    }
  }
}
