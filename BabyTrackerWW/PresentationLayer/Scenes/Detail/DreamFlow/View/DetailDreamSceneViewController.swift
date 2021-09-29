//
//  DetailDreamSceneViewController.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


final class DreamDetailSceneViewController: UIViewController {
    
    let configurator = DreamDetailSceneConfiguratorImpl()
    var presenter: DetailScenePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    @IBOutlet weak var putDownOutletButton: UIButton!
    @IBOutlet weak var fallAsleepOutletButton: UIButton!
    @IBOutlet weak var wakeUpOutletButton: UIButton!
    
    func setButtonLabel() {
        presenter.setLabelCallback = { [unowned self] (p1, p2, p3) in
            self.putDownOutletButton.setTitle(p1, for: .normal)
            self.fallAsleepOutletButton.setTitle(p2, for: .normal)
            self.wakeUpOutletButton.setTitle(p3, for: .normal)
        }
    }
    
    @IBAction func putDownButton(_ sender: Any) {
        self.performSegue(withIdentifier: "PutDown", sender: nil)
    }
    @IBAction func fallAsleepButton(_ sender: Any) {
        self.performSegue(withIdentifier: "FallAsleep", sender: nil)
    }
    @IBAction func wakeUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "WakeUp", sender: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
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
         print("DreamDetailSceneViewController - is Deinit!")
    }
    
}
