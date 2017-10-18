import UIKit
import TVSetKit

open class MyHitController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  let CellIdentifier = "MyHitCell"

  let localizer = Localizer(MyHitServiceAdapter.BundleId, bundleClass: MyHitSite.self)

  private var items = Items()

  override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    setupLayout()

    items.pageLoader.load = {
      return self.loadData()
    }

    items.loadInitialData(collectionView)
  }

  func setupLayout() {
    let layout = UICollectionViewFlowLayout()

    layout.itemSize = CGSize(width: 450, height: 150)
    layout.sectionInset = UIEdgeInsets(top: 150.0, left: 20.0, bottom: 50.0, right: 20.0)
    layout.minimumInteritemSpacing = 20.0
    layout.minimumLineSpacing = 100.0

    collectionView?.collectionViewLayout = layout
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
    items.append(MediaName(name: "Filters By Movies", imageName: "Filter"))
    items.append(MediaName(name: "Filters By Series", imageName: "Filter"))
    items.append(MediaName(name: "Settings", imageName: "Engineering"))
    items.append(MediaName(name: "Search", imageName: "Search"))
  
    return items
  }
  
  // MARK: UICollectionViewDataSource

  override open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as? MediaNameCell {
      if let item = items[indexPath.row] as? MediaName {
         cell.configureCell(item: item, localizedName: localizer.getLocalizedName(item.name), target: self)
      }

      CellHelper.shared.addTapGestureRecognizer(view: cell, target: self, action: #selector(self.tapped(_:)))

      return cell
    }
    else {
      return UICollectionViewCell()
    }
  }

  @objc func tapped(_ gesture: UITapGestureRecognizer) {
    if let location = gesture.view as? UICollectionViewCell {
      navigate(from: location)
    }
  }

  func navigate(from view: UICollectionViewCell, playImmediately: Bool=false) {
    if let indexPath = collectionView?.indexPath(for: view) {
      let mediaItem = items.getItem(for: indexPath)

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
  }

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameCell,
             let indexPath = collectionView?.indexPath(for: view) {

            let mediaItem = items.getItem(for: indexPath)
            let adapter = MyHitServiceAdapter()

            destination.params["requestType"] = mediaItem.name
            destination.params["parentName"] = localizer.localize(mediaItem.name!)

            destination.adapter = adapter
            destination.configuration = adapter.getConfiguration()
            destination.collectionView?.collectionViewLayout = adapter.buildLayout()!
          }

        case SearchController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SearchController {
            destination.params["requestType"] = "Search"
            destination.params["parentName"] = localizer.localize("Search Results")
          }

        default: break
      }
    }
  }
}
