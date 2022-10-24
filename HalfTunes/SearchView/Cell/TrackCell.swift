//
//  TrackCell.swift
//  HalfTunes
//
//  Created by Zehra on 17.10.2022.
//

import UIKit

protocol TrackCellDelegate {
    func downloadTapped(_ cell: TrackCell)
    func pauseTapped(_ cell: TrackCell)
    func resumeTapped(_ cell: TrackCell)
    func cancelTapped(_ cell: TrackCell)
}

class TrackCell: UITableViewCell {
    
    static let idetifier = "TrackCell"
    
    var delegate: TrackCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    func configure(_ track: Track, downloaded: Bool, download: Download?) {
        var showDownloadControls = false
        
        titleLabel.text = track.name
        artistLabel.text = track.artist
        
        if let download = download {
            showDownloadControls = true
            let image = download.isDownloading ? "pause.circle" : "play.circle"
            pauseButton.setImage(UIImage(systemName: image), for: .normal)
        }
        
        pauseButton.isHidden = !showDownloadControls
        cancelButton.isHidden = !showDownloadControls
        
        selectionStyle = downloaded ? UITableViewCell.SelectionStyle.none : UITableViewCell.SelectionStyle.blue
        downloadButton.isHidden = downloaded || showDownloadControls
    }

    @IBAction func downloadTapped(_ sender: Any) {
        delegate?.downloadTapped(self)
    }
    
    @IBAction func pauseOrResumeTapped(_ sender: Any) {
        if pauseButton.currentImage == UIImage(systemName: "pause.circle") {
            pauseButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
            delegate?.pauseTapped(self)
        } else {
            pauseButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            delegate?.resumeTapped(self)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        delegate?.cancelTapped(self)
    }
    
}
