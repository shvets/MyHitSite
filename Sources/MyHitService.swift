import Foundation
import WebAPI
import TVSetKit

public class MyHitService {
  static let shared: MyHitAPI = {
    return MyHitAPI()
  }()

  static let bookmarksFileName = NSHomeDirectory() + "/Library/Caches/myhit-bookmarks.json"
  static let historyFileName = NSHomeDirectory() + "/Library/Caches/myhit-history.json"

  public static let StoryboardId = "MyHit"
  public static let BundleId = "com.rubikon.MyHitSite"

  lazy var bookmarks = Bookmarks(MyHitService.bookmarksFileName)
  lazy var history = History(MyHitService.historyFileName)

  lazy var bookmarksManager = BookmarksManager(bookmarks)
  lazy var historyManager = HistoryManager(history)

  var dataSource = MyHitDataSource()

  let mobile: Bool

  public init(_ mobile: Bool=false) {
    self.mobile = mobile
  }

  func buildLayout() -> UICollectionViewFlowLayout? {
    let layout = UICollectionViewFlowLayout()

    //if params["requestType"] as! String == "Soundtracks" || params["requestType"] as! String == "Search" {
      layout.itemSize = CGSize(width: 210*1.3, height: 300*1.3) // 210 x 300
      layout.sectionInset = UIEdgeInsets(top: 40.0, left: 40.0, bottom: 120.0, right: 40.0)
      layout.minimumInteritemSpacing = 50.0
      layout.minimumLineSpacing = 100.0
//    }
//    else {
//      layout.itemSize = CGSize(width: 210*1.2, height: 300*1.2) // 210 x 300
//      layout.sectionInset = UIEdgeInsets(top: 40.0, left: 40.0, bottom: 120.0, right: 40.0)
//      layout.minimumInteritemSpacing = 40.0
//      layout.minimumLineSpacing = 140.0
//    }

    layout.headerReferenceSize = CGSize(width: 500, height: 75)

    return layout
  }

  func getDetailsImageFrame() -> CGRect? {
    return CGRect(x: 40, y: 40, width: 210*2.7, height: 300*2.7)
  }

  func getConfiguration() -> [String: Any] {
    var conf = [String: Any]()

//    if params["requestType"] as? String == "Soundtracks" || params["requestType"] as? String == "Search" {
      conf["pageSize"] = 25
//    }
//    else {
//      conf["pageSize"] = 24
//    }

    if mobile {
      conf["rowSize"] = 1
    }
    else {
      conf["rowSize"] = 6
    }
    conf["mobile"] = mobile
    conf["bookmarksManager"] = bookmarksManager
    conf["historyManager"] = historyManager
    conf["dataSource"] = dataSource
    conf["storyboardId"] = MyHitService.StoryboardId
    conf["bundleId"] = MyHitService.BundleId
    conf["detailsImageFrame"] = getDetailsImageFrame()
    conf["buildLayout"] = buildLayout()

    return conf
  }

}
