//
//  WakeDetailSceneViewController.swift
//  BabyTracker - 2 with WakeWindow
//
//  Created by Max on 12.09.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


class WakeDetailSceneViewController: UIViewController {
    
    let configurator = WakeDetailSceneConfiguratorImpl()
    var presenter: DetailScenePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    @IBOutlet weak var wakeUpOutletButton: UIButton!
    @IBOutlet weak var wakeWindowOutletButton: UIButton!
    @IBOutlet weak var signsOutletButton: UIButton!
    
    func setButtonLabel() {
        presenter.setLabelCallback = { [unowned self] (p1, p2, p3) in
            self.wakeUpOutletButton.setTitle(p1, for: .normal)
            self.wakeWindowOutletButton.setTitle(p2, for: .normal)
            self.signsOutletButton.setTitle(p3, for: .normal)
        }
    }
    
    @IBAction func wakeUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "WakeUp", sender: nil)
    }
    @IBAction func wakeWindowButton(_ sender: Any) {
        self.performSegue(withIdentifier: "WakeWindow", sender: nil)
    }
    @IBAction func signsButton(_ sender: Any) {
        self.performSegue(withIdentifier: "Signs", sender: nil)
    }
    
    @IBAction func saveWakeButton(_ sender: Any) {
        presenter.saveButtonTapped()
        //TODO: - Сделать нормальный роутинг!
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
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
