import TVSetKit

open class MyHitBaseCollectionViewController: BaseCollectionViewController {
  override open func viewDidLoad() {
    super.viewDidLoad()

    localizer = Localizer(MyHitServiceAdapter.BundleId, bundleClass: MyHitSite.self)
  }
}
