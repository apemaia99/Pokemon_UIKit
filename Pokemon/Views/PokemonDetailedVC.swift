//
//  PokemonDetailedVC.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 24/07/22.
//

import UIKit

class PokemonDetailedVC: UIViewController {

    private let pokemon: Pokemon
    private var tableView: UITableView!
    
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
        tableView = createTableView()
    }

}
//MARK: - Views Configuration
extension PokemonDetailedVC {
    
    private func configureVC() {
        self.title = pokemon.name.capitalized
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .systemBackground
    }
    
    private func createTableView() -> UITableView {
        
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = 90
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.pin(to: view)
        
        return tableView
    }
    
    private func createCell(text: String) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: text)
        
        let labelView = UILabel()
        labelView.text = text
        
        cell.addSubview(labelView)
        
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        labelView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20).isActive = true
        
        return cell
    }
}
//MARK: - TableView Delegates
extension PokemonDetailedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return pokemon.moves.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 210
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "details".uppercased()
        case 2:
            return "moves \(pokemon.moves.count)".uppercased()
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            //FIXME: need to implement image part
            let cell = UITableViewCell(style: .default, reuseIdentifier: "image")
            return cell
            
        case 1:
            if indexPath.row == 0 {
                return createCell(text: "Height \(pokemon.height)")
            } else {
                return createCell(text: "weight \(pokemon.weight)")
            }
        default:
            return createCell(text: pokemon.moves[indexPath.row].detail.name)
        }
    }
}
