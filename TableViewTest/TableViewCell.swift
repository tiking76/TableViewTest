//
//  TableViewCell.swift
//  TableViewTest
//
//  Created by 舘佳紀 on 2020/06/14.
//  Copyright © 2020 Yoshiki Tachi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var tittleLabel: UILabel!
    
    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBOutlet weak var userThumbImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(article : Article) {
        tittleLabel.text = article.title
        userIdLabel.text = article.userId
        setUserThumbImageView(imageUserString: article.profileImageUrlString)
    }
    
    private func setUserThumbImageView(imageUserString : String) {
        guard let profileImageUrl = URL(string: imageUserString) else { return }
        let session = URLSession(configuration: .default)
        let downloadImageTask = session.dataTask(with: profileImageUrl) { (data, response, error) in
            guard let imageData = data else { return }
            let imageimage = UIImage(data: imageData)
            DispatchQueue.main.async() { () -> Void in
                self.userThumbImageView.image = imageimage
            }
        }
        downloadImageTask.resume()
    }
}
