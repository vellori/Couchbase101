//
//  UIHelper.swift
//  CouchbaseExample
//
//  Created by André Vellori on 28/04/2017.
//  Copyright © 2017 André Vellori. All rights reserved.
//

import Foundation
import UIKit


class DocumentAdderUIHelper: NSObject {
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func add() {
        guard let text = textField.text else {
            return
        }
        _ = DocumentAdder(title: text).add()
    }
}

class CouchbaseTableviewHelper: NSObject, CBLUITableDelegate {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let query = DatabaseAccess.db().createAllDocumentsQuery()
            let sorting = NSSortDescriptor(key: "document.properties.\(DocumentKeys.title.rawValue)", ascending: true)
            query.sortDescriptors = [sorting]
            couchbaseDataSource.query = query.asLive()
            tableView.dataSource = couchbaseDataSource
            tableView.delegate = self
            couchbaseDataSource.tableView = tableView
            couchbaseDataSource.deletionAllowed = true
        }
    }
    var couchbaseDataSource = CBLUITableSource()
    
    func couchTableSource(_ source: CBLUITableSource, cellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        guard let document = source.document(at: indexPath) else {
            return nil
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = DocumentReader(docID: document.documentID).readTitle()
        return cell
    }
    
    func couchTableSource(_ source: CBLUITableSource, delete row: CBLQueryRow) -> Bool {
        guard let docID = row.documentID else {
            return false
        }
        return DocumentRemover(docID: docID).remove()
    }
    
}
