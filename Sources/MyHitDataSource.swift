import SwiftyJSON
import WebAPI
import TVSetKit

class MyHitDataSource: DataSource {
  let service = MyHitService.shared

  override open func load(pageSize: Int, currentPage: Int, convert: Bool=true) throws -> [Any] {
    var result: [Any] = []

    let identifier = params["identifier"] as? String
    let bookmarks = params["bookmarks"] as! Bookmarks
    let history = params["history"] as! History
    let selectedItem = params["selectedItem"] as? MyHitMediaItem

    var tracks = [JSON]()

    var request = params["requestType"] as! String

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
        bookmarks.load()
        result = bookmarks.getBookmarks(pageSize: 48, page: currentPage)

      case "History":
        history.load()
        result = history.getHistoryItems(pageSize: 48, page: currentPage)

      case "All Movies":
        result = try service.getAllMovies(page: currentPage)["movies"] as! [Any]

      case "All Series":
        result = try service.getAllSeries(page: currentPage)["movies"] as! [Any]

      case "Movies":
        let path = selectedItem!.id

        result = try service.getMovies(path: path!, page: currentPage)["movies"] as! [Any]

      case "Series":
        let path = selectedItem!.id

        result = try service.getSeries(path: path!, page: currentPage)["movies"] as! [Any]

      case "Popular Movies":
        result = try service.getPopularMovies(page: currentPage)["movies"] as! [Any]

      case "Popular Series":
        result = try service.getPopularSeries(page: currentPage)["movies"] as! [Any]

      case "Seasons":
        let seasons = service.getSeasons(identifier!, parentName: selectedItem!.name!)["movies"] as! [Any]

        if seasons.count == 1 {
          let episodes = (seasons[0] as! [String: Any])["episodes"]

          result = episodes as! [Any]
        }
        else {
          result = seasons
        }

      case "Episodes":
        let seasonNumber = selectedItem?.seasonNumber ?? ""

        let parentName = "\(selectedItem!.parentName!) (\(selectedItem!.name!))"

        result = service.getEpisodes(identifier!, parentName: parentName, seasonNumber: seasonNumber,
            pageSize: pageSize, page: currentPage)["movies"] as! [Any]

      case "Selections":
        result = try service.getSelections(page: currentPage)["movies"] as! [Any]

      case "Selection":
        let selectionId = selectedItem!.id!

        result = try service.getSelection(path: selectionId, page: currentPage)["movies"] as! [Any]

      case "Albums":
        let soundtrackId = selectedItem!.id!

        let albums = try service.getAlbums(soundtrackId)["movies"] as! [Any]

        if albums.count == 1 {
          let tracks = (albums[0] as! [String: Any])["tracks"]

          result = tracks as! [Any]
        }
        else {
          result = albums
        }

      case "Tracks":
        result = tracks

      case "Movies Filter":
        result = try service.getFilters(mode: "film")

      case "Movies Subfilter":
        result = selectedItem!.items

      case "Series Filter":
        result = try service.getFilters(mode: "serial")

      case "Series Subfilter":
        result = selectedItem!.items

      case "Soundtracks":
        result = try service.getSoundtracks(page: currentPage)["movies"] as! [Any]

      case "Search":
        if !identifier!.isEmpty {
          result = try service.search(identifier!, page: currentPage)["movies"] as! [Any]
        }

      default:
        result = []
    }

    return convertToMediaItems(result)
  }

  func convertToMediaItems(_ items: [Any]) -> [MediaItem] {
    var newItems = [MediaItem]()

    for item in items {
      var jsonItem = item as? JSON

      if jsonItem == nil {
        jsonItem = JSON(item)
      }

      let movie = MyHitMediaItem(data: jsonItem!)

      newItems += [movie]
    }

    return newItems
  }
}