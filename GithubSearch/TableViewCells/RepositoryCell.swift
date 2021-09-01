//
//  RepositoryCell.swift
//
//  Created by Erwin Robles on 8/29/21.
//

import UIKit
import Lottie

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var repositoryName: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starGazerCount: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var endOfList: UILabel!
    @IBOutlet weak var loading: AnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loading.contentMode = .scaleAspectFit
        loading.loopMode = .loop
        loading.animationSpeed = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func showLoadingAnimation(show: Bool){
        if show {
            loading.isHidden = false
            loading.play()
        }else{
            loading.isHidden = true
            loading.stop()
        }
    }

}
