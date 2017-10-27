import TVSetKit
import AudioPlayer

open class MyHitMediaItemsController: MediaItemsController {
  override open func navigate(from view: UICollectionViewCell, playImmediately: Bool=false) {
    if let indexPath = collectionView?.indexPath(for: view),
       let mediaItem = items.getItem(for: indexPath) as? MyHitMediaItem {

      if mediaItem.isContainer() {
        if mediaItem.isAudioContainer() {
          performSegue(withIdentifier: AudioItemsController.SegueIdentifier, sender: view)
        }
        else {
          if let destination = MediaItemsController.instantiateController(configuration?["storyboardId"] as! String) {
           destination.configuration = configuration

           destination.params["selectedItem"] = mediaItem
           destination.params["parentId"] = mediaItem.id
           destination.params["parentName"] = mediaItem.name
           destination.params["isContainer"] = true

           if !mobile {
             if let layout = configuration?["buildLayout"] {
               destination.collectionView?.collectionViewLayout = layout as! UICollectionViewLayout
             }

             present(destination, animated: true)
           }
           else {
             navigationController?.pushViewController(destination, animated: true)
           }
         }
        }
      }
      else {
        super.navigate(from: view, playImmediately: playImmediately)
      }
    }
  }

  // MARK: Navigation

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier,
       let selectedCell = sender as? MediaItemCell {

      if let indexPath = collectionView?.indexPath(for: selectedCell) {
        let mediaItem = items[indexPath.row] as! MediaItem

        switch identifier {
        case AudioItemsController.SegueIdentifier:
          if let destination = segue.destination as? AudioItemsController {
            destination.name = mediaItem.name
            destination.thumb = mediaItem.thumb
            destination.id = mediaItem.id

            if let requestType = params["requestType"] as? String {
              if requestType != "History" {
                historyManager?.addHistoryItem(mediaItem)
              }
            }

            destination.pageLoader.load = {
              var items: [AudioItem] = []

              var newParams = Parameters()

              newParams["requestType"] = "Tracks"
              newParams["selectedItem"] = mediaItem
              newParams["convert"] = false

              if let data = try self.dataSource?.load(params: newParams) {
                if let mediaItems = data as? [[String: String]] {
                  for mediaItem in mediaItems {
                    items.append(AudioItem(name: mediaItem["name"]!, id: mediaItem["id"]!))
                  }
                }
              }

              return items
            }
          }

        default:
          super.prepare(for: segue, sender: sender)
        }
      }
    }
  }

}
