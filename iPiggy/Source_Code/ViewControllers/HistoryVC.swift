//
//  HistoryVC.swift
//  iPiggy
//
//  Created by Gardyan Akbar on 22/10/19.
//  Copyright © 2019 Gardyan Akbar. All rights reserved.
//

import UIKit

class HistoryVC:UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Primary Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Initialize
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Add to array
    }
    
    //MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Other Methods
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        Methods.loadExpenses()
        self.tableView.reloadData()
    }
    
    //MARK: - Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Globals.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TVC_HISTORY, for: indexPath) as! HistoryTableViewCell
        
        let expenses = Globals.histories[indexPath.row]
        
        cell.category.text = expenses.category
        cell.amount.text = String(expenses.cost)
        cell.date.text = Globals.dateFormatter.string(from: expenses.date ?? Date())
        cell.info.text = expenses.description
        
        return cell
    }
}
