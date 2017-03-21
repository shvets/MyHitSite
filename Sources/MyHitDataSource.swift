import SwiftyJSON
import WebAPI
import TVSetKit

class MyHitDataSource: DataSource {
  let service = MyHitService.shared

  func load(_ requestType: String, params: RequestParams, pageSize: Int, currentPage: Int) throws -> [MediaItem] {
    var result: [Any] = []

    let identifier = params.identifier
    let bookmarks = params.bookmarks!
    let history = params.history!
    let selectedItem = params.selectedItem as? MyHitMediaItem

    var tracks = [JSON]()

    var request = requestType

    if selectedItem?.type == "serie" {
      request = "SEASONS"
    }
    else if selectedItem?.type == "season" {
      request = "EPISODES"
    }
    else if selectedItem?.type == "selection" {
      request = "SELECTION"
    }
    else if selectedItem?.type == "soundtrack" {
      request = "ALBUMS"
    }
    else if selectedItem?.type == "tracks" {
      request = "TRACKS"

      tracks = selectedItem!.tracks
    }

    switch request {
      case "BOOKMARKS":
        bookmarks.load()
        result = bookmarks.getBookmarks(pageSize: pageSize, page: currentPage)

      case "HISTORY":
        history.load()
        result = history.getHistoryItems(pageSize: pageSize, page: currentPage)

      case "ALL_MOVIES":
        result = try service.getAllMovies(page: currentPage)["movies"] as! [Any]

      case "ALL_SERIES":
        result = try service.getAllSeries(page: currentPage)["movies"] as! [Any]

      case "MOVIES":
        let path = selectedItem!.id

        result = try service.getMovies(path: path!, page: currentPage)["movies"] as! [Any]

      case "SERIES":
        let path = selectedItem!.id

        result = try service.getSeries(path: path!, page: currentPage)["movies"] as! [Any]

      case "POPULAR_MOVIES":
        result = try service.getPopularMovies(page: currentPage)["movies"] as! [Any]

      case "POPULAR_SERIES":
        result = try service.getPopularSeries(page: currentPage)["movies"] as! [Any]

      case "SEASONS":
        let seasons = service.getSeasons(identifier!, parentName: selectedItem!.name!)["movies"] as! [Any]

        if seasons.count == 1 {
          let episodes = (seasons[0] as! [String: Any])["episodes"]

          result = episodes as! [Any]
        }
        else {
          result = seasons
        }

      case "EPISODES":
        let seasonNumber = selectedItem?.seasonNumber ?? ""

        let parentName = "\(selectedItem!.parentName!) (\(selectedItem!.name!))"

        result = service.getEpisodes(identifier!, parentName: parentName, seasonNumber: seasonNumber,
            pageSize: pageSize, page: currentPage)["movies"] as! [Any]

      case "SELECTIONS":
        result = try service.getSelections(page: currentPage)["movies"] as! [Any]

      case "SELECTION":
        let selectionId = selectedItem!.id!

        result = try service.getSelection(path: selectionId, page: currentPage)["movies"] as! [Any]

//      case "SOUNDTRACKS":
//        result = try service.getSoundtracks(page: currentPage)

      case "ALBUMS":
        let soundtrackId = selectedItem!.id!

        let albums = try service.getAlbums(soundtrackId)["movies"] as! [Any]

        if albums.count == 1 {
          let tracks = (albums[0] as! [String: Any])["tracks"]

          result = tracks as! [Any]
        }
        else {
          result = albums
        }

      case "TRACKS":
        result = tracks

      case "MOVIES_FILTER":
        result = try service.getFilters(mode: "film")

      case "MOVIES_SUB_FILTER":
        result = selectedItem!.items

      case "SERIES_FILTER":
        result = try service.getFilters(mode: "serial")

      case "SERIES_SUB_FILTER":
        result = selectedItem!.items

      case "SOUNDTRACKS":
        result = try service.getSoundtracks(page: currentPage)["movies"] as! [Any]

      case "SEARCH":
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