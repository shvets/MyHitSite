import UIKit
import SwiftyJSON
import WebAPI
import TVSetKit

class MyHitServiceAdapter: ServiceAdapter {
  let service = MyHitService.shared

  static let bookmarksFileName = NSHomeDirectory() + "/Library/Caches/myhit-bookmarks.json"
  static let historyFileName = NSHomeDirectory() + "/Library/Caches/myhit-history.json"

  override open class var StoryboardId: String { return "MyHit" }
  override open class var BundleId: String { return "com.rubikon.MyHitSite" }

    lazy var bookmarks = Bookmarks(MyHitServiceAdapter.bookmarksFileName)
    lazy var history = History(MyHitServiceAdapter.historyFileName)

  var episodes: [JSON]?
  var tracks: [JSON]?

  public init(mobile: Bool=false) {
    super.init(dataSource: MyHitDataSource(), mobile: mobile)

    bookmarks.load()
    history.load()

    if params["requestType"] as? String == "Soundtracks" || params["requestType"] as? String == "Search" {
      if mobile {
        pageLoader.pageSize = 25
        pageLoader.rowSize = 1
      }
      else {
        pageLoader.pageSize = 25
        pageLoader.rowSize = 5
      }
    }
    else {
      if mobile {
        pageLoader.pageSize = 24
        pageLoader.rowSize = 1
      }
      else {
        pageLoader.pageSize = 24
        pageLoader.rowSize = 6
      }
    }

    pageLoader.load = {
      return try self.load()
    }
  }

  override open func clone() -> ServiceAdapter {
    let cloned = MyHitServiceAdapter(mobile: mobile!)

    cloned.clear()

    return cloned
  }

  override open func load() throws -> [Any] {
    params["bookmarks"] = bookmarks
    params["history"] = history

    return try super.load()
  }

  override func buildLayout() -> UICollectionViewFlowLayout? {
    let layout = UICollectionViewFlowLayout()

    if params["requestType"] as! String == "Soundtracks" || params["requestType"] as! String == "Search" {
      layout.itemSize = CGSize(width: 210*1.3, height: 300*1.3) // 210 x 300
      layout.sectionInset = UIEdgeInsets(top: 40.0, left: 40.0, bottom: 120.0, right: 40.0)
      layout.minimumInteritemSpacing = 50.0
      layout.minimumLineSpacing = 100.0
    }
    else {
      layout.itemSize = CGSize(width: 210*1.2, height: 300*1.2) // 210 x 300
      layout.sectionInset = UIEdgeInsets(top: 40.0, left: 40.0, bottom: 120.0, right: 40.0)
      layout.minimumInteritemSpacing = 40.0
      layout.minimumLineSpacing = 140.0
    }

    layout.headerReferenceSize = CGSize(width: 500, height: 75)

    return layout
  }

  override func getDetailsImageFrame() -> CGRect? {
    return CGRect(x: 40, y: 40, width: 210*2.7, height: 300*2.7)
  }

  override func addBookmark(item: MediaItem) -> Bool {
    return bookmarks.addBookmark(item: item)
  }

  override func removeBookmark(item: MediaItem) -> Bool {
    return bookmarks.removeBookmark(id: item.id!)
  }

  override func addHistoryItem(_ item: MediaItem) {
    history.add(item: item)
  }

  func getConfiguration() -> Configuration {
    var conf = Configuration()

    if params["requestType"] as? String == "Soundtracks" || params["requestType"] as? String == "Search" {
      conf.pageSize = 25
      conf.rowSize = 5
    }
    else {
      conf.pageSize = 24
      conf.rowSize = 6
    }

    return conf
  }
}
