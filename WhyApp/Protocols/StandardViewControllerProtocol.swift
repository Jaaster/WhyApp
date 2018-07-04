//
//  Goalable.swift
//  WhyApp
//
//  Created by Joriah Lasater on 6/13/18.
//  Copyright © 2018 Joriah Lasater. All rights reserved.
//

import UIKit

protocol StandardViewControllerProtocol: class  {
    var currentGoal: Goal! { get set }
    var shouldPromptUser: Bool { get }
}
