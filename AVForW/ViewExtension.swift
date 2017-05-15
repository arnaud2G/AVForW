//
//  ViewExtension.swift
//  AVForW
//
//  Created by 2Gather Arnaud Verrier on 15/05/2017.
//  Copyright © 2017 Arnaud Verrier. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addOnAllView(subview:UIView) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        subview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
}
