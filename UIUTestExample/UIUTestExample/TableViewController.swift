//
//  TableViewController.swift
//
//  Copyright © 2017-2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

class TableViewController: UITableViewController
{
    var recursive = false

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifiers = ["SignInCell", "InfoCell", "NextCell"]
        return tableView.dequeueReusableCell(withIdentifier: identifiers[indexPath.row], for: indexPath)
    }
}
