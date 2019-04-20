//
//  RoundedButton.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 20/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import UIKit

class StyledButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
    }

}
