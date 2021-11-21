//
//  DetailDreamSceneViewController.swift
//  Baby tracker
//
//  Created by Max on 12.07.2021.
//  Copyright © 2021 Max. All rights reserved.
//

import UIKit


final class DetailDreamSceneViewController: UIViewController {
    
    let configurator = DetailDreamSceneConfiguratorImpl()
    var presenter: DetailDreamScenePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.dream.subscribe(observer: self) { [unowned self] dream in
        self.fallAsleepOutletButton.setTitle(dream.fallAsleep, for: .normal)
        self.putDownOutletButton.setTitle(dream.putDown, for: .normal)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        presenter.dream.unsubscribe(observer: self)
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
//         print("DreamDetailSceneViewController - is Deinit!")
    }
    
}
