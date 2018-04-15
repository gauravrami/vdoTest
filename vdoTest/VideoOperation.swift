
import UIKit

class VideoOperation: NSObject {
    lazy var downloadInProgress = [IndexPath : Operation]()
    lazy var downloadQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Video Download Queue"
        //queue.maxConcurrentOperationCount = 1
        return queue
    }()
}


class VideoDownloader : Operation {
    
    let videoBeanObj : VideoBean
    
    init(videoBean : VideoBean) {
        self.videoBeanObj = videoBean
    }
    
    override func main() {
        if self.isCancelled { return }
        
        videoBeanObj.status = .Downloading
        if let urlData = try? Data(contentsOf: videoBeanObj.videoURL) {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let fileName = videoBeanObj.videoURL.absoluteString.components(separatedBy: "/").last ?? "tempFile.mp4"
            let filePath="\(documentsPath)/\(fileName)"
            print("\n\n\n 🙃🙃🙃🙃 File NAME = \(fileName) \n")
            print("\n\n\n 🙃🙃🙃🙃 File Path = \n\n \(filePath) \n\n")
            let filePathUrl = URL(fileURLWithPath: filePath)
            
            if self.isCancelled { return }
            
            do {
                try urlData.write(to: filePathUrl, options: .atomic)
                videoBeanObj.status = .Downloaded
            } catch let error  {
                print(error.localizedDescription)
                videoBeanObj.status = .Failed
            }
        }
    }
}
