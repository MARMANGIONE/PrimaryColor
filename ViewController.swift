//
//  ViewController.swift
//  PrimaryColorImageTest
//
//  Created by Martina Mangione on 28/02/2018.
//  Copyright © 2018 Martina Mangione. All rights reserved.
//

import UIKit

struct RGBAComponents: Hashable {
    static func ==(lhs: RGBAComponents, rhs: RGBAComponents) -> Bool {
        
        let lhsRedBlock = round(Double(lhs.red) / Double(RGBAComponents.block))
        let rhsRedBlock = round(Double(rhs.red) / Double(RGBAComponents.block))
        let lhsGreenBlock = round(Double(lhs.green) / Double(RGBAComponents.block))
        let rhsGreenBlock = round(Double(rhs.green) / Double(RGBAComponents.block))
        let lhsBlueBlock = round(Double(lhs.blue) / Double(RGBAComponents.block))
        let rhsBlueBlock = round(Double(rhs.blue) / Double(RGBAComponents.block))
        
        return lhsRedBlock == rhsRedBlock && lhsGreenBlock == rhsGreenBlock && lhsBlueBlock == rhsBlueBlock
    }
    
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
    
    static let block = 25
    
    var hashValue: Int {
        
        let redBlock = round(Double(red) / Double(RGBAComponents.block))
        let lhsGreenBlock = round(Double(green) / Double(RGBAComponents.block))
        let lhsBlueBlock = round(Double(blue) / Double(RGBAComponents.block))
        
        return [redBlock, lhsGreenBlock, lhsBlueBlock].flatMap({String(Double($0))}).joined(separator: "_").hashValue
    }
    
    var color: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var colorButton: UIButton!
    @IBOutlet var image: UIImageView!
    
    
    var componentsCount: [RGBAComponents: Int] = [:]
    
    override func viewDidLoad() {
        
        let image = #imageLiteral(resourceName: "MasterCard_Logo-1")
        
        self.image.image = image
        // l'immagine va rimpicciolita e poi quantizzata prima di essere passata
        
        self.colorButton.backgroundColor = self.primaryColor(for: image)
        
    }
    
    func primaryColor(for image: UIImage) -> UIColor {
        let size = image.size
        for xindex in 0...Int(size.width) {
            for yindex in 0...Int(size.height) {
                if let pixel = image.getPixelColor(pos: CGPoint(x: xindex, y: yindex)) {
                    
                    if let value = componentsCount[pixel] {
                        componentsCount[pixel] = value + 1
                    } else {
                        componentsCount[pixel] = 1
                    }
                }
            }
        }
        
        let component = componentsCount.max(by: { lhs, rhs in
            return lhs.value < rhs.value
        })
        
//        let color = component?.key.color .key.color ?? UIColor.clear
        
        return UIColor.init(red: (component?.key.red)!/255.0 ?? 0, green: (component?.key.green)!/255.0 ?? 0, blue: (component?.key.blue)!/255.0 ?? 0, alpha: 1)
    }
    
}

extension UIImage {
    func getPixelColor(pos: CGPoint) -> RGBAComponents? {
        
        guard let pixelData = self.cgImage?.dataProvider?.data else {
            return nil
        }
        
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo])
        let g = CGFloat(data[pixelInfo+1])
        let b = CGFloat(data[pixelInfo+2])
        let a = CGFloat(data[pixelInfo+3])
        
        return RGBAComponents(red: r, green: g, blue: b, alpha: a)
    }
}


    

    

