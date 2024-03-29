//
//  ShareSettingsViewController.swift
//  leapsecond
//
//  Created by Jon Andersen on 9/3/17.
//  Copyright © 2017 Andersen. All rights reserved.
//

import UIKit
import MediaPlayer

public enum MusicPickerAnalyticsType: String{
    case importMusic = "importMusic"
    case importFromPhotos = "importFromPhotos"
}

public protocol MusicPickerViewControllerDelegate: class {
    func musicPickerViewControllerHasPremiumAccess(_ viewController: MusicPickerViewController) -> Bool
    func musicPickerViewController(_ viewController: MusicPickerViewController, grantPremiumAccess: @escaping ((Bool) -> ()))
    func musicPickerViewController(_ viewController: MusicPickerViewController, didPickItems musicItems: [MusicTrimmedItem])
    func musicPickerViewController(_ viewController: MusicPickerViewController, triggerAnalitics:MusicPickerAnalyticsType)
}

public class MusicPickerViewController: UINavigationController, UIAdaptivePresentationControllerDelegate{
    
    public weak var musicPickerDelegate: MusicPickerViewControllerDelegate? {
        didSet {
            viewController.musicPickerDelegate = musicPickerDelegate
        }
    }
    public var singleMusicItem: Bool = false {
        didSet {
            viewController.singleMusicItem = singleMusicItem
        }
    }
    
    private var viewController: MusicPickerTableViewController {
        get {
            return viewControllers.first as! MusicPickerTableViewController
        }
    }
    
    public class func pickMusic(musicItems: [MusicTrimmedItem], delegate: MusicPickerViewControllerDelegate?, singleMusicItem: Bool = false) -> MusicPickerViewController {
        let musicPickerViewController = StoryboardScene.Main.initialScene.instantiate()
        
        musicPickerViewController.musicPickerDelegate = delegate
        musicPickerViewController.viewController.musicItems = musicItems
        return musicPickerViewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        presentationController?.delegate = self
    }
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        musicPickerDelegate?.musicPickerViewController(self, didPickItems: viewController.musicItems)
    }
}


