//
//  ErrorView.swift
//  Weather App
//
//  Created by Tornike on 18.02.22.
//

import UIKit

class ErrorView: UIView {
    
    @IBOutlet var errorButton : UIButton!
    @IBOutlet var errorL : UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame : CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        commonInit()
    }

    func commonInit(){
        
    }
}
