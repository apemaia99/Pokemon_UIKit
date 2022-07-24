//
//  PokemonDetailedVC.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 24/07/22.
//

import UIKit

class PokemonDetailedVC: UIViewController {

    private let pokemon: Pokemon
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        
    }

}
//MARK: - Views Configuration
extension PokemonDetailedVC {
    
    private func configureVC() {
        self.title = pokemon.name.capitalized
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .systemBackground
    }
    
}
