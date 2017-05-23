import UIKit
import TVSetKit

class SettingsTableController: MyHitBaseTableViewController {
  override open var CellIdentifier: String { return "SettingTableCell" }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    adapter = MyHitServiceAdapter(mobile: true)

    loadSettingsMenu()
  }

  func loadSettingsMenu() {
    let resetHistory = MediaItem(name: "Reset History")
    let resetQueue = MediaItem(name: "Reset Bookmarks")

    items = [
      resetHistory, resetQueue
    ]
  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    let settingsMode = mediaItem.name

    if settingsMode == "Reset History" {
      self.present(buildResetHistoryController(), animated: false, completion: nil)
    }
    else if settingsMode == "Reset Bookmarks" {
      self.present(buildResetQueueController(), animated: false, completion: nil)
    }
  }

  func buildResetHistoryController() -> UIAlertController {
    let title = localizer.localize("History Will Be Reset")
    let message = localizer.localize("Please Confirm Your Choice")

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default) {
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
    let title = localizer.localize("Bookmarks Will Be Reset")
    let message = localizer.localize("Please Confirm Your Choice")

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default) {
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
