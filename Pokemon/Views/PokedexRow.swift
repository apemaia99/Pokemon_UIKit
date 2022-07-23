//
//  PokedexRow.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 22/07/22.
//

import UIKit

class PokedexRow: UITableViewCell {
    
    private var pokemonImageView = UIImageView()
    private var pokemonLabelView = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(pokemonImageView)
        addSubview(pokemonLabelView)
        configurePokemonImageView()
        configurePokemonLabelView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(pokemon: Pokemon, image: UIImage) {
        self.pokemonLabelView.text = pokemon.name
        self.pokemonImageView.image = image
    }
    
    private func configurePokemonImageView() {
        pokemonImageView.layer.cornerRadius = 10
        pokemonImageView.clipsToBounds = true
        //MARK: Constraints
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        pokemonImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pokemonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        pokemonImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        pokemonImageView.widthAnchor.constraint(equalTo: pokemonImageView.heightAnchor, multiplier: 16/9).isActive = true
    }
    
    private func configurePokemonLabelView() {
        pokemonLabelView.numberOfLines = 0
        pokemonLabelView.adjustsFontSizeToFitWidth = true
        //MARK: Constraints
        pokemonLabelView.translatesAutoresizingMaskIntoConstraints = false
        pokemonLabelView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pokemonLabelView.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 20).isActive = true
        pokemonLabelView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        pokemonLabelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
}
