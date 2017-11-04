import SwiftyJSON
import WebAPI
import TVSetKit
import RxSwift

class MyHitDataSource: DataSource {
  let service = MyHitService.shared

  override open func load(params: Parameters) throws -> Observable<[Any]> {
    var items: Observable<[Any]> = Observable.just([])

    let selectedItem = params["selectedItem"] as? MyHitMediaItem

    var tracks = [JSON]()

    var request = params["requestType"] as! String
    let pageSize = params["pageSize"] as? Int
    let currentPage = params["currentPage"] as? Int ?? 0

    if selectedItem?.type == "serie" {
      request = "Seasons"
    }
    else if selectedItem?.type == "season" {
      request = "Episodes"
    }
    else if selectedItem?.type == "selection" {
      request = "Selection"
    }
    else if selectedItem?.type == "soundtrack" {
      request = "Albums"
    }
    else if selectedItem?.type == "tracks" {
      request = "Tracks"

      tracks = selectedItem!.tracks
    }

    switch request {
    case "Bookmarks":
      if let bookmarksManager = params["bookmarksManager"]  as? BookmarksManager,
         let bookmarks = bookmarksManager.bookmarks {
        items = Observable.just(bookmarks.getBookmarks(pageSize: 60, page: currentPage))
      }

    case "History":
      if let historyManager = params["historyManager"]  as? HistoryManager,
         let history = historyManager.history {
        items = Observable.just(history.getHistoryItems(pageSize: 60, page: currentPage))
      }

      case "All Movies":
        items = Observable.just(adjustItems(try service.getAllMovies(page: currentPage)["movies"] as! [Any]))

      case "All Series":
        items = Observable.just(adjustItems(try service.getAllSeries(page: currentPage)["movies"] as! [Any]))

      case "Movies":
        let path = selectedItem!.id

        items = Observable.just(adjustItems(try service.getMovies(path: path!, page: currentPage)["movies"] as! [Any]))

      case "Series":
        let path = selectedItem!.id

        items = Observable.just(adjustItems(try service.getSeries(path: path!, page: currentPage)["movies"] as! [Any]))

      case "Popular Movies":
        items = Observable.just(adjustItems(try service.getPopularMovies(page: currentPage)["movies"] as! [Any]))

      case "Popular Series":
        items = Observable.just(adjustItems(try service.getPopularSeries(page: currentPage)["movies"] as! [Any]))

      case "Seasons":
        if let identifier = params["parentId"] as? String {
          let seasons = service.getSeasons(identifier, parentName: selectedItem!.name!)["movies"] as! [Any]

          if seasons.count == 1 {
            let episodes = (seasons[0] as! [String: Any])["episodes"]

            items = Observable.just(adjustItems(episodes as! [Any]))
          }
          else {
            items = Observable.just(adjustItems(seasons))
          }
        }

      case "Episodes":
        if let identifier = params["parentId"] as? String {
          let seasonNumber = selectedItem?.seasonNumber ?? ""

          let parentName = "\(selectedItem!.parentName!) (\(selectedItem!.name!))"

          items = Observable.just(adjustItems(service.getEpisodes(identifier, parentName: parentName, seasonNumber: seasonNumber,
            pageSize: pageSize!, page: currentPage)["movies"] as! [Any]))
        }

      case "Selections":
        items = Observable.just(try service.getSelections(page: currentPage)["movies"] as! [Any])

      case "Selection":
        let selectionId = selectedItem!.id!

        items = Observable.just(adjustItems(try service.getSelection(path: selectionId, page: currentPage)["movies"] as! [Any]))

      case "Soundtracks":
        items = Observable.just(adjustItems(try service.getSoundtracks(page: currentPage)["movies"] as! [Any]))

      case "Albums":
        let soundtrackId = selectedItem!.id!

        let albums = try service.getAlbums(soundtrackId)["movies"] as! [Any]

        if albums.count == 1 {
          let tracks = (albums[0] as! [String: Any])["tracks"]

          var list = [[String: String]]()

          for track in tracks as! [[String: Any]] {
            let newTrack = ["name": track["name"] as! String, "id": track["id"] as! String]
            list.append(newTrack)
          }

          items = Observable.just(list)
        }
        else {
          items = Observable.just(albums)
        }

      case "Tracks":
        var list = [[String: String]]()

        for track in tracks {
          let newTrack = ["name": track["name"].rawString(), "id": track["id"].rawString()]
            list.append(newTrack as! [String : String])
        }

        items = Observable.just(adjustItems(list))

      case "Movies Filter":
        items = Observable.just(adjustItems(try service.getFilters(mode: "film")))

      case "Movies Subfilter":
        items = Observable.just(selectedItem!.items)

      case "Series Filter":
        items = Observable.just(adjustItems(try service.getFilters(mode: "serial")))

      case "Series Subfilter":
        items = Observable.just(selectedItem!.items)

      case "Search":
        if let query = params["query"] as? String {
          if !query.isEmpty {
            items = Observable.just(adjustItems(try service.search(query, page: currentPage)["movies"] as! [Any]))
          }
        }

      default:
        items = Observable.just([])
    }

    return items
  }

  func adjustItems(_ items: [Any]) -> [Item] {
    var newItems = [Item]()

    for item in items {
      var jsonItem = item as? JSON

      if jsonItem == nil {
        jsonItem = JSON(item)
      }

      let movie = MyHitMediaItem(data: jsonItem!)
//      let movie = MyHitMediaItem(data: [:])

      newItems += [movie]
    }

    return newItems
  }
}
