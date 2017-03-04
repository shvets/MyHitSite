import UIKit
import SwiftyJSON
import TVSetKit

open class MyHitController: BaseCollectionViewController {
  let CellIdentifier = "MyHitCell"

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

  var localizer = Localizer("com.rubikon.MyHitSite")

  static public func instantiate() -> Self {
    let bundle = Bundle(identifier: "com.rubikon.MyHitSite")!

    return AppStoryboard.instantiateController("MyHit", bundle: bundle, viewControllerClass: self)
  }

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

    for name in MainMenuItems {
      let item = MediaItem(name: name)

      items.append(item)
    }
  }

  // MARK: UICollectionViewDataSource
  
  override open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! MediaNameCell

    let item = items[indexPath.row]

    let localizedName = localizer.localize(item.name!)

    cell.configureCell(item: item, localizedName: localizedName, target: self)
    CellHelper.shared.addGestureRecognizer(view: cell, target: self, action: #selector(self.tapped(_:)))

    return cell
  }
  
  func tapped(_ gesture: UITapGestureRecognizer) {
    let selectedCell = gesture.view as! MediaNameCell

    let requestType = getItem(for: selectedCell).name

    if requestType == "FILTER_BY_MOVIES" {
      performSegue(withIdentifier: "FilterByMovies", sender: gesture.view)
    }
    else if requestType == "FILTER_BY_SERIES" {
      performSegue(withIdentifier: "FilterBySeries", sender: gesture.view)
    }
    else if requestType == "SETTINGS" {
      performSegue(withIdentifier: "Settings", sender: gesture.view)
    }
    else if requestType == "SEARCH" {
      let destination = SearchController.instantiate()

      adapter.requestType = "SEARCH"
      adapter.parentName = "SEARCH"

      destination.adapter = adapter

      self.present(destination, animated: false, completion: nil)
    }
    else {
      let controller = MediaItemsController.instantiate(adapter).getActionController()
      let destination = controller as! MediaItemsController

      adapter.clear()
      adapter.requestType = requestType
      adapter.parentName = localizer.localize(requestType!)

      destination.adapter = adapter

      destination.collectionView?.collectionViewLayout = adapter.buildLayout()!

      self.show(controller!, sender: destination)
    }
  }

}
