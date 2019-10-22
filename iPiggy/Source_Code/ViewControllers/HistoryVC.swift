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
        Globals.histories = []
        
        //Add to array
    }
    
    //MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Globals.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TVC_HISTORY, for: indexPath) as! HistoryTableViewCell
        
        let menu = Globals.histories[indexPath.row]
        
        cell.category.text = menu.category
        cell.amount.text = String(menu.amount!)
        cell.date.text = menu.date?.description
        cell.info.text = menu.description
        
        return cell
    }
}
