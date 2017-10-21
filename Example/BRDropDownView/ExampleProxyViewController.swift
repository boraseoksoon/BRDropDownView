//
//  ExampleProxyViewController.swift
//  BRDropDownView_Example
//
//  Created by Seoksoon Jang on 2017. 10. 22..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit

class ExampleProxyViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  let examples = ["typeA", "typeB", "typeC"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationView = segue.destination as? ViewController {
      if segue.identifier == "TypeA" {
        destinationView.dropdownViewstyle = .typeA
      } else if segue.identifier == "TypeB" {
        destinationView.dropdownViewstyle = .typeB
      } else if segue.identifier == "TypeC" {
        destinationView.dropdownViewstyle = .typeC
      }
    }
  }
}

extension ExampleProxyViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return examples.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
    cell.textLabel?.text = examples[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 0 {
      self.performSegue(withIdentifier: "TypeA", sender: nil)
    } else if indexPath.row == 1 {
      self.performSegue(withIdentifier: "TypeB", sender: nil)
    } else if indexPath.row == 2 {
      self.performSegue(withIdentifier: "TypeC", sender: nil)
    }
  }
}

