//
//  ViewController.swift
//  Mac Accent Color Test
//
//  Created by Dylan McDonald on 3/20/22.
//

import UIKit

class ViewController: UIViewController {
    
    // This app determines the current Mac Accent Color using the system-defined UserDefaults values.
    
    // On the 2021 M1 iMacs, there is a new option in System Preferences called "This Mac" that is color-matched to the iMac's external color. This app takes this into account.
    
    // You can enable this on any Mac using the following Terminal commands:
    // NSColorSimulateHardwareAccent -bool YES
    // NSColorSimulatedHardwareEnclosureNumber -int 1
        // Change 1 with your desired number (see below).
    
    // I have also included color sets that match each system color.
    
    
    @IBOutlet weak var macAccentColorLabel: UILabel!
    @IBOutlet weak var colorNumberLabel: UILabel!
    @IBOutlet weak var colorPreviewView: UIView!
    @IBOutlet weak var getColorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorPreviewView.layer.cornerCurve = .continuous
        colorPreviewView.layer.cornerRadius = 10
        
        DistributedNotificationCenter.default.addObserver(self, selector: #selector(UpdateThemeColor(_:)), name: NSNotification.Name(rawValue: "AppleColorPreferencesChangedNotification"), object: nil)
        
        getMacThemeColor()
    }

    @IBAction func getColorAction(_ sender: Any) {
        getMacThemeColor()
    }
    
    @objc func UpdateThemeColor(_ notification: Notification) {
        getMacThemeColor()
    }
    
    func getMacThemeColor() {
        var colorName: String = ""
        var colorNumber: String = ""
        
    
        // This runs if the Mac is an M1 iMac and the user is using the "This Mac" option.
        if UserDefaults.standard.bool(forKey: "NSColorSimulateHardwareAccent") && UserDefaults.standard.object(forKey: "AppleAccentColor") == nil {
            
            colorNumber = "M1 iMac: \(UserDefaults.standard.string(forKey: "NSColorSimulatedHardwareEnclosureNumber") ?? "no color returned")"
            
            switch UserDefaults.standard.string(forKey: "NSColorSimulatedHardwareEnclosureNumber") ?? "No iMac color returned" {
            case "3":
                colorName = "iMac Yellow"
            case "4":
                colorName = "iMac Green"
            case "5":
                colorName = "iMac Blue"
            case "6":
                colorName = "iMac Pink"
            case "7":
                colorName = "iMac Purple"
            case "8":
                colorName = "iMac Orange"
            default:
                colorName = "No iMac color returned"
                colorNumber = "No iMac color returned"
            }
            
        } else {
            // This runs if the Mac is not an M1 iMac or an M1 iMac is using the standard color options.
            colorNumber = "Regular: \(UserDefaults.standard.string(forKey: "AppleAccentColor") ?? "no color returned")"
            
            switch UserDefaults.standard.string(forKey: "AppleAccentColor") ?? "No color returned" {
            case "4":
                colorName = "Blue"
            case "5":
                colorName = "Purple"
            case "6":
                colorName = "Pink"
            case "0":
                colorName = "Red"
            case "1":
                colorName = "Orange"
            case "2":
                colorName = "Yellow"
            case "3":
                colorName = "Green"
            case "-1":
                colorName = "Graphite"
            case "-2":
                colorName = "Multicolor"
            default:
                colorName = "No regular color returned"
            }
        }
        
        if determineIfMulticolor() {
            colorName = "Multicolor"
        }
        
        let MacAccentColor = (UIColor.value(forKey: "controlAccentColor") as? UIColor ?? UIColor(named: "AccentColor")!)
    
        macAccentColorLabel.text = colorName
        macAccentColorLabel.textColor = MacAccentColor
        colorNumberLabel.text = colorNumber
        colorNumberLabel.textColor = MacAccentColor
        colorPreviewView.backgroundColor = MacAccentColor
        getColorButton.tintColor = MacAccentColor
    }
}



func determineIfMulticolor() -> Bool {
    var toReturn = false
    if UserDefaults.standard.bool(forKey: "NSColorSimulateHardwareAccent") {
        if UserDefaults.standard.string(forKey: "AppleAccentColor") ?? "No color returned" == "-2" {
            toReturn = true
        }
    } else if UserDefaults.standard.object(forKey: "AppleAccentColor") == nil {
        toReturn = true
    }
    return toReturn
}
