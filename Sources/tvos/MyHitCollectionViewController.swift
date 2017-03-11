import TVSetKit

open class MyHitCollectionViewController: InfiniteCollectionViewController {
  override open func viewDidLoad() {
    super.viewDidLoad()

    localizer = Localizer("com.rubikon.MyHitSite")
  }
}