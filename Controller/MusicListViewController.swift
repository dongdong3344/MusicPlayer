//
//  MusicListViewController.swift
//  MusicPlayer
//
//  Created by lindongdong on 2017/8/31.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import UIKit

class MusicListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating{
   
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var tableView: UITableView!
    // searchController
    lazy var searchController :CustomSearchController = {
        
        let searchVC  = CustomSearchController(searchResultsController: nil)
        searchVC.searchBar.delegate = self
        searchVC.searchResultsUpdater = self
        return searchVC
        
    }()
    
    var musics = [Music]()
    var filteredMusics = [Music]()
    let identifier = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        getMusics()
        
        setupTableView()
        
        
        APIManager.shared.getSearchRecommendation(keyword: "张学友") { (recommendationrs) in
          _ = recommendationrs.map({print($0)})
        }
        
        APIManager.shared.getSearchHotTags { (searchHotTags) in
            _ = searchHotTags.map({print($0)})
        }
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectRow()
        
        animateTableView()
    }
    
    @IBAction func searchClick(_ sender: UIBarButtonItem) {
        
        navigationItem.titleView = searchController.searchBar
        navigationItem.rightBarButtonItem = nil
        
    }
    
    
    func getMusics(){
        musics = MusicPlayManager.shared.musics!
    }
    
    func setupTableView(){
        
        tableView.register(UINib.init(nibName: "MusicCell", bundle: nil), forCellReuseIdentifier: identifier)
        
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "BackgroundImage"))
        tableView.separatorStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFiltering(filteredItemCount: filteredMusics.count, of: musics.count)
            return filteredMusics.count
        }
        searchFooter.setNotFiltering()
        return musics.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as!MusicCell
        let music:Music
        if isFiltering() {
            music = filteredMusics[indexPath.row]
        }else{
            music = musics[indexPath.row]
        }
        cell.music = music
        cell.numberLabel.text = String(indexPath.row + 1)
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.saveIndex(value: indexPath.row)
        let presentVC = MusicPlayerViewController()
        present(presentVC, animated: true) {
            MusicPlayManager.shared.play()
        }
    }
    
    func selectRow(){
        let index  = UserDefaults.standard.getIndex()
        
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
    }
    
    func animateTableView(){
        
        // tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for (index, cell) in cells.enumerated() {
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
        }
        
    }
   

}
