import UIKit
import TVSetKit

class SettingsController: BaseCollectionViewController {
  override open var CellIdentifier: String { return "SettingCell" }

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

    loadSettingsMenu()
  }

  func loadSettingsMenu() {
    let resetHistory = MediaItem(name: "RESET_HISTORY")
    let resetQueue = MediaItem(name: "RESET_BOOKMARKS")

    items = [
      resetHistory, resetQueue
    ]
  }

  override public func tapped(_ gesture: UITapGestureRecognizer) {
    let selectedCell = gesture.view as! MediaNameCell

    let settingsMode = getItem(for: selectedCell).name

    if settingsMode == "RESET_HISTORY" {
      self.present(buildResetHistoryController(), animated: false, completion: nil)
    }
    else if settingsMode == "RESET_BOOKMARKS" {
      self.present(buildResetQueueController(), animated: false, completion: nil)
    }
  }

  func buildResetHistoryController() -> UIAlertController {
    let title = localizer?.localize("HISTORY_WILL_BE_RESET")
    let message = localizer?.localize("CONFIRM_YOUR_CHOICE")

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
      let history = (self.adapter as! MyHitServiceAdapter).history

      history.clear()
      history.save()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    alertController.addAction(cancelAction)
    alertController.addAction(okAction)

    return alertController
  }

  func buildResetQueueController() -> UIAlertController {
    let title = localizer?.localize("BOOKMARKS_WILL_BE_RESET")
    let message = localizer?.localize("CONFIRM_YOUR_CHOICE")

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
      let bookmarks = (self.adapter as! MyHitServiceAdapter).bookmarks

      bookmarks.clear()
      bookmarks.save()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    alertController.addAction(cancelAction)
    alertController.addAction(okAction)

    return alertController
  }

}
