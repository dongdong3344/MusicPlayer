//
//  MusicTableViewController.swift
//  MusicPlayer
//
//  Created by Ringo on 2017/7/20.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import UIKit
import AVFoundation


class MusicTableViewController: UITableViewController,UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    
    var musics = [Music]()
    var audioPlayer = AVAudioPlayer()
    var currentMusicIndex = 0
    var currentMusicURL:URL!
    var searchController :UISearchController!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationbar()
        
        setupTableView()
        
        getMusics()
        
        setupPlayBackground()
        
        
        
        
    }
    
    func setupTableView(){
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "BackgroundImage"))
        
       tableView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width,
               height: self.view.frame.height - 64)
        
        let footView = UIView()
        footView.backgroundColor = UIColor.clear
        tableView.tableFooterView = footView
        tableView.showsVerticalScrollIndicator = false
        
        searchController = UISearchController(searchResultsController: nil)
    searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "请输入音乐名称…"
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
             textField.textColor = .white
            
            
            let placeholderLabel = textField.value(forKey: "placeholderLabel") as? UILabel
          //  placeholderLabel?.textColor = .white
            placeholderLabel?.font = UIFont.systemFont(ofSize: 15)
            
        }
        
//        let containerView = UIView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 44))
//        containerView.addSubview(searchController.searchBar)
//        view.addSubview(containerView)
   tableView.tableHeaderView = searchController.searchBar
        
        let indexPath = IndexPath(row: getSavedMusicIndex(), section: 0)
        
        tableView.setContentOffset(CGPoint(x: 0, y: indexPath.row * 55), animated:true )
        
        
        
    }
    
    func getMusics(){
       Music.getMusicList { (musics) in
        self.musics = musics.sorted{$0.title! < $1.title!}
        }
    }
    
    func setupNavigationbar(){
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.barTintColor = .orange
        
        
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectRow()
        
        //显示引导页
        
        if (UserDefaults.standard.value(forKey: "isFirstLaunch") != nil) {
            return
        }
        
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "GuideController") as? GuideViewController {
            present(pageVC, animated: true, completion: nil)
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return musics.count
    }
    
    
   override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell", for: indexPath) as! MusicTableViewCell
        cell.music = musics[indexPath.row]
        cell.numberLabel.text = String(indexPath.row + 1)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentMusicIndex = indexPath.row
        
        saveCurrentMusicIndex()
        
        let musicPlayerController = MusicPlayerViewController()
        musicPlayerController.musicVC = self
        
        present(musicPlayerController, animated: true) {
            
           musicPlayerController.playMusic()
       
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0
        let transfrom = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transfrom
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        }
        
    }
    
    func selectRow(){
        
        let indexPath = IndexPath(row: getSavedMusicIndex(), section: 0)
        
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        
        
    }
    
    func saveCurrentMusicIndex(){
        
        UserDefaults.standard.set(currentMusicIndex, forKey:"currentMusicIndex")
        UserDefaults.standard.synchronize()
    }
    
    
    func getSavedMusicIndex() -> Int {
        
        if let musicIndex  = UserDefaults.standard.object(forKey: "currentMusicIndex"){
            currentMusicIndex = musicIndex as! Int
        }
        
        return currentMusicIndex
        
    }
  
    func setupPlayBackground(){
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch let error {
            
            print(error.localizedDescription)
            
        }
        
    }
    
    func imageWithColor(_ color:UIColor,size:CGSize) -> UIImage{
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        if let context  = UIGraphicsGetCurrentContext(){
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
    
    
}


