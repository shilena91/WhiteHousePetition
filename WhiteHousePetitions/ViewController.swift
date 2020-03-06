//
//  ViewController.swift
//  WhiteHousePetitions
//
//  Created by Hoang Pham on 1.3.2020.
//  Copyright © 2020 Hoang Pham. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filterPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(showCredit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(search))
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0
        {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString)
        {
            if let data = try? Data(contentsOf: url)
            {
                parse(json: data)
            } else {
                showError()
            }
        }
    }
    
    func parse(json: Data)
    {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json)
        {
            petitions = jsonPetitions.results
            filterPetitions = petitions
            tableView.reloadData()
        }
    }
    
    func showError()
    {
        let ac = UIAlertController(title: "Loading error", message: "There was problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCredit()
    {
        let ac = UIAlertController(title: "Credit", message: "Data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func search()
    {
        let ac = UIAlertController(title: "Search petition you want to read", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submit = UIAlertAction(title: "Submit", style: .default)
        {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            
            if answer.isEmpty {
                return
            }
            self?.filterPetitions.removeAll()
            for petition in self!.petitions
            {
                if petition.title.contains(answer) || petition.body.contains(answer)
                {
                    self?.filterPetitions.append(petition)
                }
            }
            self?.tableView.reloadData()
        }
        ac.addAction(submit)
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = filterPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return (cell)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filterPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
