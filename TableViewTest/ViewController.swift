//
//  ViewController.swift
//  TableViewTest
//
//  Created by 舘佳紀 on 2020/06/14.
//  Copyright © 2020 Yoshiki Tachi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    fileprivate var viewModel  = ViewModel()

    fileprivate var articles : [Article] {
        return viewModel.articles
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tableView.delegate = self
        tableView.dataSource = self

        initViewModel()
        viewModel.fetchArticles()
        initTableView()

    }

    private func initTableView() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func initViewModel() {
        viewModel.reloadHandler = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}


extension ViewController : UITableViewDataSource {
    
    
    //セクションの個数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションごとにセルの個数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    
    //セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let article = articles[indexPath.row]
        let title = article.title
        cell.bindData(article: article)
        return cell
    }
    
    
    //セルの高さを返す
    func tableView(_ tableView: UITableView, heightForRowAt indexPath : IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension ViewController : UITableViewDelegate {
    
    //セルがタップされたときの処理を書く
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "ArticleDetail", bundle: nil).instantiateInitialViewController()! as! ArticleDetailViewController
        vc.article = articles[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //スクロールしたときの処理を書く
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY
        if distanceToBottom < 500 {
            viewModel.fetchArticles()
        }

    }
}

