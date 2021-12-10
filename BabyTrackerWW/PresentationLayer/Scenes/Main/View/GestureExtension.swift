//
//  GestureExtension.swift
//  BabyTrackerWW
//
//  Created by Max on 09.12.2021.
//  Copyright © 2021 Max. All rights reserved.
//
// https://stackoverflow.com/questions/7100884/uipangesturerecognizer-only-vertical-or-horizontal
// @Lee Goodrich


//import Foundation
import UIKit


enum PanDirection {
    case vertical
    case horizontal
}

class PanDirectionGestureRecognizer: UIPanGestureRecognizer {

    let direction: PanDirection

    init(direction: PanDirection, target: AnyObject, action: Selector) {
        self.direction = direction
        super.init(target: target, action: action)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        if state == .began {
            let vel = velocity(in: view)
            switch direction {
            case .horizontal where abs(vel.y) > abs(vel.x):
                state = .cancelled
            case .vertical where abs(vel.x) > abs(vel.y):
                state = .cancelled
            default:
                break
            }
        }
    }
}
