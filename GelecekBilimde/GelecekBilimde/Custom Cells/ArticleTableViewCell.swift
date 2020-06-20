//
//  ArticleTableViewCell.swift
//  GelecekBilimde
//
//  Created by Alperen Ünal on 21.09.2019.
//  Copyright © 2019 Burak Furkan Asilturk. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleBookmarkImageView: UIImageView!
    @IBOutlet weak var articleMainImageView: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    @IBOutlet weak var articleAddedDateLabel: UILabel!
    
    var currentArticle: ArticleCache!
    var didArticleBookmarked: ((ArticleCache) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(bookmarkClicked))
        tap.numberOfTapsRequired = 1
        
        articleBookmarkImageView.isUserInteractionEnabled = true
        
        articleBookmarkImageView.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        articleMainImageView.layer.cornerRadius = articleMainImageView.bounds.height / 2
        articleMainImageView.clipsToBounds = true
    }
    
    func setArticle(article: ArticleCache) {
        currentArticle = article
        articleMainImageView.image = UIImage(named: "GelecekBilimdeLogo")
        articleTitleLabel.text = article.title.convertHTMLEntities()
        articleDescriptionLabel.text = "\(String(cleanString(from: article.excrpt).prefix(75)))..."
        let calender = Calendar.current
        let dateComponent = calender.dateComponents([.year, .month, .day], from: article.date)
        articleAddedDateLabel.text = "\(String(describing: dateComponent.day!))/\(String(describing: dateComponent.month!))/\(String(describing: dateComponent.year!))"
        articleBookmarkImageView.image = UIImage(named: article.bookmarked ? "bookmarked" : "unbookmarked")
        guard let url = URL(string: article.imageURL) else { return }
        articleMainImageView.sd_setImage(with: url)
    }
    
    func cleanString(from text: String) -> String {
        let cleanString = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return cleanString
    }
    
    @objc func bookmarkClicked() {
        UIView.animate(withDuration: 0.2, delay: 0,  options: [], animations: {
            self.articleBookmarkImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            DispatchQueue.main.async {
                self.articleBookmarkImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }) { (finished) in
            self.didArticleBookmarked?(self.currentArticle)
        }
    }
    
}
