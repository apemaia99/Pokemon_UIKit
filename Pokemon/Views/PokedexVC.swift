//
//  PokedexVC.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 22/07/22.
//

import UIKit

class PokedexVC: UIViewController {
    
    private let pokemonManager: PokemonManager
    private var tableView: UITableView!
    private var search: UISearchController!
    //Custom init for dependency injection
    init(pokemoManager: PokemonManager) {
        self.pokemonManager = pokemoManager
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        tableView = createTableView()
        search = createSearch()
        Task {
            await pokemonManager.loadPokemons(firstCall: true)
            self.tableView.reloadData()
        }
    }
}
//MARK: - Views Configuration
extension PokedexVC {
    
    private func configureVC() {
        
        self.title = "Pokedex"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = createNavBarMenu()
    }
    
    private func createTableView() -> UITableView {
        
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.rowHeight = 90
        
        tableView.register(PokedexRow.self, forCellReuseIdentifier: "PokedexRow")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.pin(to: view)
        
        return tableView
    }
    
    private func createNavBarMenu() -> UIBarButtonItem {
        
        let actions: [UIAction] = [
            .init(
                title: "Alphabetical",
                handler: { _ in
                    self.pokemonManager.sortPokemons(by: .alphabetical)
                    self.tableView.reloadData()
                }
            ),
            .init(
                title: "Reverse",
                handler: { _ in
                    self.pokemonManager.sortPokemons(by: .reverse)
                    self.tableView.reloadData()
                }
            ),
            .init(
                title: "Standard",
                handler: { _ in
                    self.pokemonManager.sortPokemons(by: .standard)
                    self.tableView.reloadData()
                }
            )
        ]
        
        let menu = UIMenu(
            identifier: .view,
            options: .singleSelection,
            children: actions
        )
        
        let symbol = UIImage(
            systemName: "arrow.up.arrow.down.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(textStyle: .title2)
        )
        
        let button = UIBarButtonItem(
            title: nil,
            image: symbol,
            primaryAction: nil,
            menu: menu
        )
        
        return button
    }
    
    private func createSearch() -> UISearchController {
        
        let search = UISearchController()
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
        return search
    }
}
//MARK: - TableView Delegates
extension PokedexVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonManager.pokemonFiltered.isEmpty ? pokemonManager.pokemonList.count : pokemonManager.pokemonFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Pagination
        if !search.isActive && indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            Task {
                await pokemonManager.loadPokemons()
                self.tableView.reloadData()
            }
        }
        //Cell setup
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokedexRow") as! PokedexRow
        cell.accessoryType = .disclosureIndicator
        
        if pokemonManager.pokemonFiltered.isEmpty {
            cell.setData(pokemon: pokemonManager.pokemonList[indexPath.row])
        } else {
            cell.setData(pokemon: pokemonManager.pokemonFiltered[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pokemonDetailedVC = PokemonDetailedVC(
            pokemon: !search.isActive ? pokemonManager.pokemonList[indexPath.row] : pokemonManager.pokemonFiltered[indexPath.row]
        )
        navigationController?.pushViewController(pokemonDetailedVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - UISearchController Delegates
extension PokedexVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            pokemonManager.filterPokemons(by: searchController.searchBar.text ?? "")
        }
        tableView.reloadData()
    }
}
