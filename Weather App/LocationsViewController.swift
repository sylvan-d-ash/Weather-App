//
//  ViewController.swift
//  Weather App
//
//  Created by Sylvan Ash on 11/05/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController {
    private let locationsService: LocationsProtocol
    private var locations: [String] = []

    private let tableView = UITableView(frame: .zero, style: .plain)

    init(locationsService: LocationsProtocol) {
        self.locationsService = locationsService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupNavbar()
        loadData()
    }
}

private extension LocationsViewController {
    func setupSubviews() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets()
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
    }

    func setupNavbar() {
        navigationItem.title = "Locations"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocationTapped))
    }

    func loadData() {
        locationsService.getSavedLocations { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let locations):
                self.locations = locations
                tableView.reloadData()
            }
        }
    }

    @objc func addLocationTapped() {
        let alertController = UIAlertController(title: "Enter city", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)

        let addCityAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            self?.saveLocation(location: alertController.textFields?[0].text)
        }
        alertController.addAction(addCityAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func saveLocation(location: String?) {
        guard let location = location else { return }
        locationsService.save(location: location) { errorOrNil in
            if let error = errorOrNil {
                print(error.localizedDescription)
                return
            }

            locations.append(location)
            tableView.reloadData()
        }
    }

    func deleteLocation(atRow index: Int) {
        let location = locations[index]
        locationsService.delete(location: location) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let locations):
                self.locations = locations
                tableView.reloadData()
            }
        }
    }
}

extension LocationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        cell.textLabel?.text = "\(locations[indexPath.row])"
        return cell
    }
}

extension LocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let location = locations[indexPath.row]
        let controller = ForecastViewController(location: location)
        navigationController?.pushViewController(controller, animated: true)
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            self?.deleteLocation(atRow: indexPath.row)
            completion(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            self?.deleteLocation(atRow: indexPath.row)
        }
        return [deleteAction]
    }
}
