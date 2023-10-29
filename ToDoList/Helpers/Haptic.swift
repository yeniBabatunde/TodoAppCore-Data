//
//  Haptic.swift
//  ToDoList
//
//  Created by Sharon Omoyeni Babatunde on 28/10/2023.
//

import UIKit

struct Haptics {
    
    static func playLightImpact() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    static func playSuccessNotification() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
