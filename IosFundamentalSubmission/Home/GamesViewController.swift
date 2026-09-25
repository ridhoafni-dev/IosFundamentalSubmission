//
//  GamesViewController.swift
//  IosFundamentalSubmission
//
//  Created by User on 12/09/26.
//

import UIKit
import Kingfisher

class GamesViewController: UIViewController {

    @IBOutlet weak var gameSearchBar: UISearchBar!
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var gameIndicatorLoading: UIActivityIndicatorView!
    
    private var games: [Game] = []
    private var filterGames: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameIndicatorLoading.startAnimating()
        
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameSearchBar.delegate = self
        
        gameTableView.register(UINib(nibName: "GamesTableViewCell", bundle: nil), forCellReuseIdentifier: "gameTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await getGames() }
    }
    
    func getGames() async {
        
        let network = NetworkService()
        do {
            games = try await network.getGames()
            filterGames = games
            gameTableView.reloadData()
            
            gameIndicatorLoading.stopAnimating()
            gameIndicatorLoading.isHidden = true
        } catch {
            
            gameIndicatorLoading.stopAnimating()
            gameIndicatorLoading.isHidden = true
            fatalError("Error: connection failed.")
        }
    }

}

extension GamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "gameTableViewCell", for: indexPath) as? GamesTableViewCell {
            let game = games[indexPath.row]
            cell.titleLabel.text = game.name ?? ""
            cell.ratingLabel.text = String(format: "%.2f", game.rating ?? 0.0)
            
            let url = URL(string: game.backgroundImage ?? "")
            let processor = DownsamplingImageProcessor(size: cell.gameImageView.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 4)
            cell.gameImageView.kf.setImage(with: url, options: [
                .processor(processor),
                .scaleFactor(view.traitCollection.displayScale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
         return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension GamesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterGames = []
        if searchText == "" {
            filterGames = games
        }
        
        for game in games {
            if(game.name!.lowercased().contains(searchText.lowercased())) {
                filterGames.append(game)
            }
        }
        gameTableView.reloadData()
    }
}

extension GamesViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "moveToDetail", sender: games[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToDetail" {
            if let detailViewController = segue.destination as? DetailViewController {
                detailViewController.game = sender as? Game
            }
        }
    }
    
}
