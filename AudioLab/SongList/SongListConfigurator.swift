//
//  SongListConfigurator.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 4/7/18.
//
//

import Foundation

/**
 This class is used for binding controller, presenter, interactor and router.
 */
final class SongListConfigurator {
    
    /// Singleton instance of the configurator.
    static let shared = SongListConfigurator()
    
    private init() {}
    
    // MARK: - Configuration
    
    /// This method is used to map Viewcontroller, Presenter, Interactor and Router with each other.
    func configure(viewcontroller: SongListViewController) {
        
        let presenter = SongListPresenter()
        viewcontroller.presenter = presenter
        
        let interactor = SongListInteractor()
        interactor.listener = presenter
        
        presenter.interactor = interactor
        presenter.viewDelegate = viewcontroller
    }
}
