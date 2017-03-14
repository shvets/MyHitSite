import TVSetKit

open class MyHitBaseCollectionViewController: InfiniteCollectionViewController {
  override open func viewDidLoad() {
    super.viewDidLoad()

    localizer = Localizer(MyHitServiceAdapter.BundleId)
  }
}