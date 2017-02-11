import Foundation
import WebAPI

public class MyHitService {

  static let shared: MyHitAPI = {
    return MyHitAPI()
  }()
  
}
