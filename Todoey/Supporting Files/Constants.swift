//
//  Constants.swift
//  Todoey
//
//  Created by murad on 01.01.2025.
//

import UIKit

struct Constants {
    // MARK: - Cell Identifiers
        struct CellIdentifiers {
            static let swipeCell = "SwipeCell"
        }
        
        // MARK: - Navigation Bar Colors
        struct NavigationBarColors {
            static let backgroundColorHex = "1D9BF6" // Белый цвет
            static let tintColor = UIColor.white // Синий цвет
            
            // Вычисляемое свойство для преобразования HEX в UIColor
            static var backgroundColor: UIColor {
                return UIColor(hexString: backgroundColorHex) ?? .systemBlue
            }
        }
        
        // MARK: - Navigation Titles
        struct NavigationTitles {
            static let mainTitle = "Todoye"
        }
}
