//
//  WakeDetailSceneViewController.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 12.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


class DetailWakeSceneViewController: UIViewController {
    
    let configurator = DetailWakeSceneConfiguratorImpl()
    var presenter: DetailWakeScenePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.wake.subscribe(observer: self) { [unowned self] wake in
            self.wakeUpOutletButton.setTitle(wake.wakeUp.rawValue, for: .normal)
            self.wakeWindowOutletButton.setTitle(wake.wakeWindow.rawValue, for: .normal)
            self.signsOutletButton.setTitle(wake.signs.rawValue, for: .normal)
        }
    }
    
    @IBOutlet weak var wakeUpOutletButton: UIButton!
    @IBOutlet weak var wakeWindowOutletButton: UIButton!
    @IBOutlet weak var signsOutletButton: UIButton!
    
    
    @IBAction func wakeUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: String.init(describing: Wake.WakeUp.self), sender: nil)
    }
    @IBAction func wakeWindowButton(_ sender: Any) {
        self.performSegue(withIdentifier: String.init(describing: Wake.WakeWindow.self), sender: nil)
    }
    @IBAction func signsButton(_ sender: Any) {
        self.performSegue(withIdentifier: String.init(describing: Wake.Signs.self), sender: nil)
    }
    
    @IBAction func saveWakeButton(_ sender: Any) {
        presenter.saveButtonTapped()
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepare(for: segue)
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
    }
    
    
    deinit {
         print("WakeDetailSceneViewController - is Deinit!")
    }
    
}
