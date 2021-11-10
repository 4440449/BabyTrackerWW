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
    var presenter: DetailDreamScenePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.subscribeToLabelState(self) { [unowned self] array in
            self.fallAsleepOutletButton.setTitle(array[0], for: .normal)
            self.putDownOutletButton.setTitle(array[1], for: .normal)
        }
    }
    
    @IBOutlet weak var fallAsleepOutletButton: UIButton!
    @IBOutlet weak var putDownOutletButton: UIButton!
    
    
    @IBAction func fallAsleepButton(_ sender: Any) {
        self.performSegue(withIdentifier: String.init(describing: Dream.FallAsleep.self), sender: nil)
    }
    @IBAction func putDownButton(_ sender: Any) {
        self.performSegue(withIdentifier: String.init(describing: Dream.PutDown.self), sender: nil)
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
//         print("DreamDetailSceneViewController - is Deinit!")
    }
    
}
