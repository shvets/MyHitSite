import UIKit
import TVSetKit

class SerieFilterCell: UICollectionViewCell {
  var name: String?
  
  @IBOutlet weak var thumb: UIImageView!
  
  func configureCell(item: MediaItem, localizedName: String, target: Any?, action: Selector?) {
    name = item.name
    
    thumb.backgroundColor = UIColor(rgb: 0x00BFFF)
    
    let itemSize = UIHelper.shared.getItemSize(target as! UICollectionViewController)

    thumb.image = UIHelper.shared.textToImage(drawText: localizedName, size: itemSize)

    CellHelper.shared.addGestureRecognizer(view: self, target: target, action: action)
  }
  
  override func didUpdateFocus(in inContext: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
    self.thumb.adjustsImageWhenAncestorFocused = self.isFocused
  }
}