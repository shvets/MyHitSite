import TVSetKit

open class MyHitBaseTableViewController: BaseTableViewController {
  override open func viewDidLoad() {
    super.viewDidLoad()

    localizer = Localizer(MyHitServiceAdapter.BundleId)
  }
}