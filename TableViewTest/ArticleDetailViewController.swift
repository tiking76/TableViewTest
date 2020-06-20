//
//  ArticleDetailViewController.swift
//  TableViewTest
//
//  Created by 舘佳紀 on 2020/06/15.
//  Copyright © 2020 Yoshiki Tachi. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var article : Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = article?.body
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
