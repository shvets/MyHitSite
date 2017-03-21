import TVSetKit

open class MyHitBaseTableViewController: InfiniteTableViewController {
  override open func viewDidLoad() {
    super.viewDidLoad()

    localizer = Localizer(MyHitServiceAdapter.BundleId)
  }
}