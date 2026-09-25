//
//  DetailViewController.swift
//  IosFundamentalSubmission
//
//  Created by User on 21/07/26.
//

import Kingfisher
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var gameIndicator: UIActivityIndicatorView!
    
    var game: Game? = nil
    private var gameDetail: GameDetail? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        gameIndicator.startAnimating()
        descLabel.isHidden = true
        if let result = game {
            titleLabel.text = result.name

            let url = URL(string: result.backgroundImage ?? "")
            let processor =
                DownsamplingImageProcessor(size: gameImageView.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 4)
            gameImageView.kf.setImage(
                with: url,
                options: [
                    .processor(processor),
                    .scaleFactor(view.traitCollection.displayScale),
                    .transition(.fade(1)),
                    .cacheOriginalImage,
                ]
            )
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let result = game {
            Task{ await getGameDetail(id: result.id) }
        }
    }
    
    func getGameDetail(id: Int) async {
        let network = NetworkService()
        do {
            gameDetail = try await network.getGame(id: id )
            
            if gameDetail != nil {
                if let plainText = convertHTMLToPlainText(htmlString: gameDetail?.description ?? "") {
                    descLabel.text = plainText
                } else {
                    print("Conversion failed.")
                }
            }
            descLabel.isHidden = false
            gameIndicator.stopAnimating()
            gameIndicator.isHidden = true
            
        } catch {
            descLabel.isHidden = true
            gameIndicator.stopAnimating()
            gameIndicator.isHidden = true
            fatalError("Error: connection failed.")
        }
    }
    
    func convertHTMLToPlainText(htmlString: String) -> String? {
        guard let data = htmlString.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error converting HTML to plain text: \(error)")
            return nil
        }
    }

}
