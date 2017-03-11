import UIKit
import TVSetKit

class SettingsTableController: MyHitBaseTableViewController {
  override open var CellIdentifier: String { return "SettingTableCell" }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

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

//  override public func tapped(_ gesture: UITapGestureRecognizer) {
//    let selectedCell = gesture.view as! MediaNameCell
//
//    let settingsMode = getItem(for: selectedCell).name
//
//    if settingsMode == "RESET_HISTORY" {
//      self.present(buildResetHistoryController(), animated: false, completion: nil)
//    }
//    else if settingsMode == "RESET_BOOKMARKS" {
//      self.present(buildResetQueueController(), animated: false, completion: nil)
//    }
//  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    let settingsMode = mediaItem.name

    if settingsMode == "RESET_HISTORY" {
      self.present(buildResetHistoryController(), animated: false, completion: nil)
    }
    else if settingsMode == "RESET_BOOKMARKS" {
      self.present(buildResetQueueController(), animated: false, completion: nil)
    }
  }

  func buildResetHistoryController() -> UIAlertController {
    let title = localizer.localize("HISTORY_WILL_BE_RESET")
    let message = localizer.localize("CONFIRM_YOUR_CHOICE")

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
    let title = localizer.localize("BOOKMARKS_WILL_BE_RESET")
    let message = localizer.localize("CONFIRM_YOUR_CHOICE")

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
