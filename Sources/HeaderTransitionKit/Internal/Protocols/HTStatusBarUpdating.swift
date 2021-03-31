//
//  HTStatusBarUpdating.swift
//
//
//  Created by Antoine Barré on 3/31/21.
//

import UIKit

protocol HTStatusBarUpdating: AnyObject {

    var statusBarStyle: UIStatusBarStyle { get }
    var barStyle: UIBarStyle { get set }
}
