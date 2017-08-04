//
//  MenuTableViewController.swift
//  CoreDataPreloadDemo
//
//  Created by Simon Ng on 13/5/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class MenuTableViewController: UITableViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var mArrDistrictData: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make the cell self size
        tableView.estimatedRowHeight = 66.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataForEachTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didTapselecteSegment(_ sender: UISegmentedControl) {
        let modelManager = ModelManager(fileName: "address.db")
        switch sender.selectedSegmentIndex {
        case 0:
            mArrDistrictData = modelManager.getAllCityData()
        case 1:
            mArrDistrictData = modelManager.getAllDistrictData()
        default:
            mArrDistrictData = modelManager.getAllWardData()
        }
        tableView.reloadData()
    }
    
    func getDataForEachTable()
    {
        let modelManager = ModelManager(fileName: "address.db")
        switch segmentControl.selectedSegmentIndex {
        case 0:
            mArrDistrictData = modelManager.getAllCityData()
        case 1:
            mArrDistrictData = modelManager.getAllDistrictData()
        default:
            mArrDistrictData = modelManager.getAllWardData()
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return mArrDistrictData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let city = mArrDistrictData.object(at: indexPath.row) as! City
            cell.id.text = "\(city.id!)"
            cell.name.text = city.name
            cell.rank.text = city.rank
            cell.rankOrder.text = city.rankOrder
        case 1:
            let district = mArrDistrictData.object(at: indexPath.row) as! District
            cell.id.text = "\(district.id!)"
            cell.name.text = district.name
            cell.rank.text = district.rank
            cell.rankOrder.text = district.rankOrder
        default:
            let ward = mArrDistrictData.object(at: indexPath.row) as! Ward
            cell.id.text = "\(ward.id!)"
            cell.name.text = ward.name
            cell.rank.text = ward.rank
            cell.rankOrder.text = ward.rankOrder
        }
        // Configure the cell...
        
        return cell
    }
    

}
