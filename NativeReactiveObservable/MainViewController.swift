//
//  MainViewController.swift
//  NativeReactiveObserver
//
//  Created by Giovanne Bressam on 03/10/21.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Variables
    private var initialFruts = ["Banana", "Apple", "Pineapple", "Grape"]
    private var fruits: Observable<[String]> = .init(["Banana", "Apple", "Pineapple", "Grape"])
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup tableview
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Fake fetch to populate tableView
        self.fakeFetch()
        
        // Bind observable and observer logic
        self.bindObservableAndObserver()
    }
    
    func fakeFetch() {
        // Every 2 seconds add new itens to
        for i in 0..<100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (1*TimeInterval(i))) {
                let fruit: String = self.initialFruts.randomElement() ?? "Some fruit"
                self.fruits.value.append("\(fruit) \(i)")
            }
        }
    }
    
    func bindObservableAndObserver() {
        // Creates a "subscription" to observable class created
        self.fruits.subscribeOnMain { fruits in
            print("New fruits added: \(fruits)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        print(cell?.textLabel?.text)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fruits.value.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = self.fruits.value[indexPath.row]
        
        return cell
    }
}
