import UIKit
import TVSetKit

class SeriesFilterController: MyHitCollectionViewController {
  static let SegueIdentifier = "FilterBySeries"

  override open var CellIdentifier: String { return "SerieFilterCell" }

  override func viewDidLoad() {
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
    adapter.requestType = "SERIES_FILTER"

    collectionView?.backgroundView = activityIndicatorView
    adapter.spinner = PlainSpinner(activityIndicatorView)

    loadInitialData() { result in
      for item in result {
        item.name = self.localizer?.localize(item.name!)
      }
    }
  }

  // MARK: UICollectionViewDataSource

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! MediaNameCell

    if adapter.nextPageAvailable(dataCount: items.count, index: indexPath.row) {
      loadMoreData(indexPath.row)
    }

    let item = items[indexPath.row]

    let localizedName = localizer?.localize(item.name!)

    cell.configureCell(item: item, localizedName: localizedName!, target: self)
    CellHelper.shared.addGestureRecognizer(view: cell, target: self, action: #selector(self.tapped(_:)))

    return cell
  }

  override public func tapped(_ gesture: UITapGestureRecognizer) {
    performSegue(withIdentifier: SeriesSubFilterController.SegueIdentifier, sender: gesture.view)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case SeriesSubFilterController.SegueIdentifier:
        if let destination = segue.destination as? SeriesSubFilterController,
           let selectedCell = sender as? MediaNameCell {
          adapter.requestType = "SERIES_SUB_FILTER"
          adapter.selectedItem = getItem(for: selectedCell)

          destination.adapter = adapter
        }

      default: break
      }
    }
  }
}