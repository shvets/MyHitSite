import UIKit
import SwiftyJSON
import WebAPI
import TVSetKit

class MyHitMediaItem: MediaItem {
  let service = MyHitService.shared

  var tracks = [JSON]()
  var items = [JSON]()

//  override init(data: JSON) {
//    super.init(data: [:])
//
//    self.seasonNumber = data["seasonNumber"].stringValue
//    self.episodeNumber = data["episodeNumber"].stringValue
//
//    self.tracks = []
//
//    let tracks = data["tracks"].arrayValue
//
//    for track in tracks {
//      self.tracks.append(track)
//    }
//
//    self.items = []
//
//    let items = data["items"].arrayValue
//
//    for item in items {
//      self.items.append(item)
//    }
//  }
  
  required convenience init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
  override func isContainer() -> Bool {
    return type == "serie" || type == "season" || type == "soundtrack" || type == "selection" || type == "tracks"
  }
  
  func isAudioContainer() -> Bool {
    var result = false
    
    if type == "soundtrack" {
      do {
        let albums = try service.getAlbums(id!)["movies"] as! [Any]

        if albums.count == 1 {
          result = true
        }
      }
      catch {
        print("error")
      }
    }
    else if type == "tracks" {
      result = true
    }
    
    return result
  }
  
  override func getBitrates() throws -> [[String: String]] {
    var bitrates: [[String: String]] = []

    let urls: [String]?
      
    if type == "episode" {
      urls = try MyHitAPI(proxy: true).getUrls(url: id!)
    }
    else {
      urls = try MyHitAPI(proxy: true).getUrls(path: id!)
    }

    if let urls = urls {
      for url in urls {
        let metadata = try service.getMetadata(url)

        let bitrate = metadata["bitrate"]

        if bitrate != nil {
          bitrates.append(["id": bitrate!])
        }
      }
    }

    let qualityLevels = QualityLevel.availableLevels(bitrates.count)

    var newBitrates: [[String: String]] = []

    for (index, bitrate) in bitrates.enumerated() {
      var newBitrate = bitrate

      newBitrate["name"] = qualityLevels[index].rawValue

      newBitrates.append(newBitrate)
    }

    return newBitrates
  }

  override func getUrl(_ bitrate: [String: String]) throws -> String? {
    let urls: [String]?

    if type == "episode" {
      urls = try service.getUrls(url: id!)
    }
    else {
      urls = try service.getUrls(path: id!)
    }

    return urls?[0]
  }

  override func retrieveExtraInfo() throws {
    if type == "movie" {
      let mediaData = try service.getMediaData(pathOrUrl: id!)

      var text = ""

      if let intro = mediaData["Продолжительность:"] as? String {
        text += "\(intro)\n\n"
      }

      if let genre = mediaData["Жанр:"] as? String {
        text += "\(genre)\n\n"
      }

      if let artists = (mediaData["В ролях:"] as? String)?.description {
        text += "\(artists)\n\n"
      }

      if let description = mediaData["description"] as? String {
        text += "\(description)\n\n"
      }

      description = text
    }
  }
}
