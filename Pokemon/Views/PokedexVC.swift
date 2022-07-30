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
        Task {
            await load(firstCall: true)
        }
    }
    
    private func load(firstCall: Bool = false) async {
        await pokemonManager.loadMore(firstCall: firstCall)
        self.tableView.reloadData()
    }
    
    private func order(mode: PokemonManager.OrderMode) {
        pokemonManager.orderList(by: mode)
        self.tableView.reloadData()
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
}
//MARK: - TableView Delegates
extension PokedexVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonManager.pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Pagination
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            Task {
                await load()
            }
        }
        //Cell setup
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokedexRow") as! PokedexRow
        cell.accessoryType = .disclosureIndicator
        cell.setData(pokemon: pokemonManager.pokemonList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pokemonDetailedVC = PokemonDetailedVC(pokemon: pokemonManager.pokemonList[indexPath.row])
        navigationController?.pushViewController(pokemonDetailedVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
