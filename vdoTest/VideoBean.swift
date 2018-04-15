
import UIKit

enum VideoStatus {
    case New, Downloading, Downloaded, Failed
}

class VideoBean: NSObject {
    var name : String
    var videoURL : URL
    var status : VideoStatus = .New
    var thumbImage : UIImage? = UIImage(named: "video-placeholder")
    var filePath : URL?
    
    init(name : String, theUrl : URL) {
        self.name = name
        self.videoURL = theUrl
    }
}
