//
//  FilterViewController.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 25/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    var contentView: FilterView?
    
    var apiLabelUseCase: LabelUseCase?
    var persistenceLabelUseCase: LabelUseCase?
    
    var onDismiss: () -> Void
    
    init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView = FilterView(frame: .zero)
        self.contentView?.addAction = self.add
        self.contentView?.removeAction = self.remove
        
        self.view = contentView
        
        self.apiLabelUseCase = LabelUseCase(gateway: ApiManager())
        self.persistenceLabelUseCase = LabelUseCase(gateway: UserDefaultManager())
        
        self.fetchLabels()
        self.fetchSavedLabels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.onDismiss()
    }
    
    func fetchLabels() {
        self.apiLabelUseCase?.fetchLabels(completion: { (result) in
            switch result {
            case let .sucess(labels):
                self.contentView?.labels = labels
            case .failure(_):
                let alert = UIAlertController(title: "Ocorreu um erro",
                                              message: "Ocorreu um erro aos buscar pelos opções de filtro. Tente novamente", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.fetchLabels()
                    alert.dismiss(animated: true, completion: nil)
                }
                
                let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive) { (action) in
                    alert.dismiss(animated: true) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                alert.addAction(cancelAction)
                alert.addAction(action)
            
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func fetchSavedLabels() {
        self.persistenceLabelUseCase?.fetchLabels(completion: { (result) in
            switch result {
            case let .sucess(labels):
                self.contentView?.savedLabels = labels
            case .failure(_):
                let alert = UIAlertController(title: "Ocorreu um erro",
                                              message: "Ocorreu um erro aos buscar pelos opções de filtro. Tente novamente", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.fetchSavedLabels()
                    alert.dismiss(animated: true, completion: nil)
                }
                
                let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive) { (action) in
                    alert.dismiss(animated: true) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                alert.addAction(cancelAction)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func add(label: Label) {
        persistenceLabelUseCase?.add(label: label, completion: { (result) in
            switch result {
            case let .sucess(labels):
                self.contentView?.savedLabels = labels
            case .failure(_):
                let alert = UIAlertController(title: "Ocorreu um erro",
                                              message: "Houve um erro selecionando este filtro. Tente novamente",
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.add(label: label)
                    alert.dismiss(animated: true, completion: nil)
                }
                
                let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(cancelAction)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func remove(label: Label) {
        persistenceLabelUseCase?.remove(label: label, completion: { (result) in
            switch result {
            case let .sucess(labels):
                self.contentView?.savedLabels = labels
            case .failure(_):
                let alert = UIAlertController(title: "Ocorreu um erro",
                                              message: "Houve um erro selecionando este filtro. Tente novamente",
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.remove(label: label)
                    alert.dismiss(animated: true, completion: nil)
                }
                
                let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(cancelAction)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
        })
    }

}
