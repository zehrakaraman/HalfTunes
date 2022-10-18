//
//  TrackCell.swift
//  HalfTunes
//
//  Created by Zehra on 17.10.2022.
//

import UIKit

class TrackCell: UITableViewCell {
    
    static let idetifier = "TrackCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    func configure(_ track: Track, downloaded: Bool) {
        titleLabel.text = track.name
        artistLabel.text = track.artist
        
        selectionStyle = downloaded ? UITableViewCell.SelectionStyle.gray : UITableViewCell.SelectionStyle.none
        downloadButton.isHidden = downloaded
    }

}
