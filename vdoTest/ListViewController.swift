

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    var arrVideos = [VideoBean]()
    let videoOperations = VideoOperation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.dataSource = self
        tblView.delegate = self
        
        getVideoList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension ListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell else { return UITableViewCell() }
        
        let bean = arrVideos[indexPath.row]
        
        if bean.status == .New {
            cell.btnDownload.setTitle("Download", for: .normal)
            cell.activityIndi.isHidden = true
        }
        else if bean.status == .Downloading {
            cell.btnDownload.setTitle("Cancel", for: .normal)
            cell.activityIndi.startAnimating()
            cell.activityIndi.isHidden = false
        }
        else if bean.status == .Downloaded {
            cell.btnDownload.setTitle("Play", for: .normal)
            cell.activityIndi.isHidden = true
        }
        else if bean.status == .Failed {
            cell.btnDownload.setTitle("Failed", for: .normal)
            cell.activityIndi.isHidden = true
        }
        cell.lblTitle.text = bean.name
        
        cell.btnDownload.tag = indexPath.row
        cell.btnDownload.addTarget(self, action: #selector(self.btnDownloadTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
}


extension ListViewController {
    @objc func btnDownloadTapped(_ sender : UIButton) {
        let bean = arrVideos[sender.tag]
        
        if bean.status == .New {
            //start download
            startDownloadFor(bean: bean, indexPath: IndexPath(row: sender.tag, section: 1))
        }
        else if bean.status == .Downloading {
            // Pause or Cancel
            cancelDownloadFor(bean: bean, indexPath: IndexPath(row: sender.tag, section: 1))
        }
        else {
            return
        }
    }
    
    
    func startDownloadFor(bean : VideoBean, indexPath : IndexPath) {
        if let _ = videoOperations.downloadInProgress[indexPath] {
            return
        }
        
        print("\n\n\n 🙏🏻🙏🏻🙏🏻🙏🏻🙏🏻 startDownloadFor Function 🙏🏻🙏🏻🙏🏻")
        let downloader = VideoDownloader(videoBean: bean)
        downloader.completionBlock = {
            
            print("\n\n\n 🙏🏻🙏🏻🙏🏻🙏🏻🙏🏻 COMPLATION BLOCK 🙏🏻🙏🏻🙏🏻")
            if downloader.isCancelled { return }
            DispatchQueue.main.async {
                
                print("\n\n\n 🙏🏻🙏🏻🙏🏻🙏🏻🙏🏻 MAIN QUEUE 🙏🏻🙏🏻🙏🏻")
                self.videoOperations.downloadInProgress.removeValue(forKey: indexPath)
                //self.tblView.reloadRows(at: [indexPath], with: .fade)
                self.tblView.reloadData()
            }
        }
        
        
        self.videoOperations.downloadInProgress[indexPath] = downloader
        self.videoOperations.downloadQueue.addOperation(downloader)
        DispatchQueue.main.async {
            print("\n\n\n 🙏🏻🙏🏻🙏🏻🙏🏻🙏🏻 Downloading 🙏🏻🙏🏻🙏🏻")
            bean.status = .Downloading
            //self.tblView.reloadRows(at: [indexPath], with: .fade)
            self.tblView.reloadData()
        }
    }
    
    func cancelDownloadFor(bean : VideoBean, indexPath : IndexPath) {
        if let theOperation = videoOperations.downloadInProgress[indexPath] {
            theOperation.cancel()
            DispatchQueue.main.async {
                bean.status = VideoStatus.New
                self.videoOperations.downloadInProgress.removeValue(forKey: indexPath)
                //self.tblView.reloadRows(at: [indexPath], with: .fade)
                self.tblView.reloadData()
            }
            return
        }
    }
}

extension ListViewController {
    
}


extension ListViewController {
    
}


extension ListViewController {
    func getVideoList() {
        
        let url1 = URL(string: "http://mirrors.standaloneinstaller.com/video-sample/Panasonic_HDC_TM_700_P_50i.mp4")
        let bean1 = VideoBean(name: "Panasonic_HDC_TM_700_P_50i.mp4", theUrl: url1!)
        arrVideos.append(bean1)
        
        let url2 = URL(string: "http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mp4")
        let bean2 = VideoBean(name: "jellyfish-25-mbps-hd-hevc.mp4", theUrl: url2!)
        arrVideos.append(bean2)
        
        let url3 = URL(string: "http://mirrors.standaloneinstaller.com/video-sample/TRA3106.mp4")
        let bean3 = VideoBean(name: "TRA3106.mp4", theUrl: url3!)
        arrVideos.append(bean3)
        
        let url4 = URL(string: "http://mirrors.standaloneinstaller.com/video-sample/grb_2.mp4")
        let bean4 = VideoBean(name: "grb_2.mp4", theUrl: url4!)
        arrVideos.append(bean4)
        
        let url5 = URL(string: "http://mirrors.standaloneinstaller.com/video-sample/star_trails.mp4")
        let bean5 = VideoBean(name: "star_trails.mp4", theUrl: url5!)
        arrVideos.append(bean5)
        
        let url6 = URL(string: "http://mirrors.standaloneinstaller.com/video-sample/page18-movie-4.mov")
        let bean6 = VideoBean(name: "page18-movie-4.mov", theUrl: url6!)
        arrVideos.append(bean6)
        
        let url7 = URL(string: "http://mirrors.standaloneinstaller.com/video-sample/Panasonic_HDC_TM_700_P_50i.mov")
        let bean7 = VideoBean(name: "Panasonic_HDC_TM_700_P_50i.mov", theUrl: url7!)
        arrVideos.append(bean7)
        
        let url8 = URL(string: "http://mirrors.standaloneinstaller.com/video-sample/page18-movie-4.m4v")
        let bean8 = VideoBean(name: "page18-movie-4.m4v", theUrl: url8!)
        arrVideos.append(bean8)
        
        tblView.reloadData()
    }
}

