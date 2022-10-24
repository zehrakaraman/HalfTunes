//
//  SearchViewController.swift
//  HalfTunes
//
//  Created by Zehra on 17.10.2022.
//

import UIKit
import AVKit

class SearchViewController: UIViewController {
    
    let viewModel = SearchViewModel()
    let downloadService = DownloadService()
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = ""
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
        viewModel.delegate = self
        
        downloadService.downloadsSession = downloadsSession
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Half Tunes"
    }
    
    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    func playDownload(_ track: Track) {
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)
        
        let url = localFilePath(for: track.previewURL)
        let player = AVPlayer(url: url)
        playerViewController.player = player
        player.play()
    }
    
    func reload(_ row: Int) {
        searchResultsTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }

}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            return
        }
        
        viewModel.getSearchResults(searchTerm: searchText) 
        
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.idetifier, for: indexPath) as! TrackCell
        let track = viewModel.searchResults[indexPath.row]
        cell.delegate = self
        cell.configure(track, downloaded: track.downloaded, download: downloadService.activeDownloads[track.previewURL])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = viewModel.searchResults[indexPath.row]
        print(track.name)
        if track.downloaded {
            playDownload(track)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SearchViewController: SearchViewModelDelegate {
    
    func updateSearchResults() {
        self.searchResultsTableView.reloadData()
    }
    
}

extension SearchViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        var download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil
        let destinationURL = localFilePath(for: sourceURL)
        print(destinationURL)
        let fileManager = FileManager()
        try? fileManager.removeItem(at: destinationURL)
        
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            download?.track.downloaded = true
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
        
        if let index = download?.track.id {
            if let download = download {
                viewModel.searchResults[download.track.id].downloaded = true
            }
            DispatchQueue.main.async { [weak self] in
                self?.searchResultsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url,
              var download = downloadService.activeDownloads[url] else { return }
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        DispatchQueue.main.async {
            if let trackCell = self.searchResultsTableView.cellForRow(at: IndexPath(row: download.track.id, section: 0)) as? TrackCell {
                trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
            }
        }
    }
    
}

extension SearchViewController: TrackCellDelegate {
    
    func downloadTapped(_ cell: TrackCell) {
        if let indexPath = searchResultsTableView.indexPath(for: cell) {
            let track = viewModel.searchResults[indexPath.row]
            downloadService.startDownload(track)
            reload(indexPath.row)
        }
    }
    
    func pauseTapped(_ cell: TrackCell) {
        if let indexPath = searchResultsTableView.indexPath(for: cell) {
            let track = viewModel.searchResults [indexPath.row]
            downloadService.pauseDownload(track)
            reload(indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: TrackCell) {
        if let indexPath = searchResultsTableView.indexPath(for: cell) {
            let track = viewModel.searchResults[indexPath.row]
            downloadService.resumeDownload(track)
            reload(indexPath.row)
        }
    }
    
    func cancelTapped(_ cell: TrackCell) {
        if let indexPath = searchResultsTableView.indexPath(for: cell) {
            let track = viewModel.searchResults[indexPath.row]
            downloadService.cancelDownload(track)
            reload(indexPath.row)
        }
    }
    
}
