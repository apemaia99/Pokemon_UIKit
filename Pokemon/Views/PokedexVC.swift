//
//  PokedexVC.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 22/07/22.
//

import UIKit

class PokedexVC: UIViewController {
    
    private let pokemonManager: PokemonManager
    private let tableview = UITableView(frame: .zero, style: .insetGrouped)
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
        configureNC()
        configureTableView()
        Task {
            await load()
        }
    }
    
    func load() async {
        await pokemonManager.loadMore(firstCall: true)
        self.tableview.reloadData()
    }
    
    func order(mode: PokemonManager.OrderMode) {
        pokemonManager.orderList(by: mode)
        self.tableview.reloadData()
    }
}
//MARK: - ViewsConfiguration
extension PokedexVC {
    
    private func configureNC() {
        self.title = "Pokedex"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = createNavBarMenu()
    }
    
    private func configureTableView() {
        view.addSubview(tableview)
        configureDelegates()
        tableview.rowHeight = 100
        tableview.register(PokedexRow.self, forCellReuseIdentifier: "PokedexRow")
        tableview.pin(to: view)
        
    }
    
    private func configureDelegates() {
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    private func createNavBarMenu() -> UIBarButtonItem {
        
        let actions: [UIAction] = [
            .init(
                title: "Alphabetical",
                handler: { _ in
                    self.order(mode: .alphabetical)
                }
            ),
            .init(
                title: "Reverse",
                handler: { _ in
                    self.order(mode: .reverse)
                }
            ),
            .init(
                title: "Standard",
                handler: { _ in
                    self.order(mode: .standard)
                }
            )
        ]
        
        let menu = UIMenu(
            identifier: .view,
            options: .singleSelection,
            children: actions
        )
        
        let button = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "arrow.up.arrow.down.circle.fill"),
            primaryAction: nil,
            menu: menu
        )
        
        return button
    }
}
//MARK: - Delegates
extension PokedexVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonManager.pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokedexRow") as! PokedexRow
        let pokemon = pokemonManager.pokemonList[indexPath.row]
        Task {
            try? await cell.setData(
                pokemon: pokemon,
                image: pokemonManager.fetchImage(by: pokemon.sprites.front_default)
            )
        }
        
        return cell
    }
}
