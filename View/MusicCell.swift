//
//  MusicCell.swift
//  MusicPlayer
//
//  Created by lindongdong on 2017/8/31.
//  Copyright © 2017年 com.omni. All rights reserved.
//

import UIKit

class MusicCell: UITableViewCell {

    @IBOutlet weak var speakerImgView: UIImageView!
    @IBOutlet weak var separatorLine: UILabel!
    @IBOutlet weak var musicImageView: CustomImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var music : Music? {
        didSet{
            
            if let music = music {
                update(with: music)
            }
            
        }
    }
    
    func update(with music:Music){
        
        titleLabel.text = music.title
        artistLabel.text = (music.artist)! + " - " + (music.album)!
        musicImageView.image = music.artwork!
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // numberLabel.font = UIFont.init(name: "Pacifico-Regular", size: 16)
        
        backgroundColor = UIColor.clear
        
        speakerImgView.isHidden = true
        
        //设置cell选中时的背景View为透明
        let bgView = UIView()
        bgView.backgroundColor = .clear
        selectedBackgroundView = bgView
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //设置分割线背景色，否则选中cell时分割线消失
        separatorLine.backgroundColor = .white
        
        if selected {
            titleLabel.textColor = UIColor(r: 227, g: 0, b: 24)
            artistLabel.textColor = UIColor(r: 227, g: 0, b: 24)
            speakerImgView.isHidden = false
            numberLabel.isHidden = true
            
        } else {
            
            titleLabel.textColor = .white
            artistLabel.textColor = .white
            speakerImgView.isHidden = true
            numberLabel.isHidden = false
        }
    }
    
    
}
