//
//  PokedexRow.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 22/07/22.
//

import UIKit

class PokedexRow: UITableViewCell {
    //MARK: Stacks
    private var pokemonCaptionStack: UIStackView!
    //MARK: Views
    private var pokemonImageView: UIImageView!
    private var pokemonNameLabelView: UILabel!
    private var pokemonMovesLabelView: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        pokemonImageView = createPokemonImageView()
        pokemonCaptionStack = createPokemonDescriptionStack()
        createChevron()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(pokemon: Pokemon, image: UIImage) {
        self.pokemonNameLabelView.text = pokemon.name.capitalized
        self.pokemonMovesLabelView.text = "Number of moves: \(pokemon.moves.count)"
        self.pokemonImageView.image = image
    }
}
//MARK: - Views Configuration
extension PokedexRow {
    
    private func createPokemonImageView() -> UIImageView {
        
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        return imageView
    }
    
    private func createPokemonDescriptionStack() -> UIStackView {
        
        pokemonNameLabelView = createPokemonNameLabelView()
        pokemonMovesLabelView = createPokemonMovesLabelView()
        
        let stack = UIStackView(arrangedSubviews: [
            pokemonNameLabelView,
            pokemonMovesLabelView
        ])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 12
        
        addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 16).isActive = true
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        return stack
    }
    
    private func createPokemonNameLabelView() -> UILabel {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
    
    private func createPokemonMovesLabelView() -> UILabel {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .secondaryLabel
        
        return label
    }
    
    private func createChevron() {
        let symbolConfig = UIImage.SymbolConfiguration(textStyle: .headline)
        let symbol = UIImageView(
            image: UIImage(
                systemName: "chevron.right",
                withConfiguration: symbolConfig
            )
        )
        symbol.tintColor = .tertiaryLabel
        addSubview(symbol)
        symbol.translatesAutoresizingMaskIntoConstraints = false
        symbol.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        symbol.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
}
