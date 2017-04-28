//
//  CouchbaseAccess.swift
//  CouchbaseExample
//
//  Created by André Vellori on 28/04/2017.
//  Copyright © 2017 André Vellori. All rights reserved.
//

import Foundation

class DBManager {
    static var sharedInstance = DBManager()
    var db: CBLDatabase
    
    init() {
        let manager = CBLManager.sharedInstance()
        db = try! manager.databaseNamed("mydb")
        
        // If you don't use Sync Gateway, you don't need the following
        let url = URL(string: "http://ec2-52-14-192-85.us-east-2.compute.amazonaws.com:4984/db")!
        let push = db.createPushReplication(url)
        let pull = db.createPullReplication(url)
        push.continuous = true
        pull.continuous = true
        
        push.start()
        pull.start()
    }
}

struct DatabaseAccess {
    static func db() -> CBLDatabase {
        return DBManager.sharedInstance.db
    }
}

struct DocumentReader {
    var docID: String
    
    func readTitle() -> String? {
        let document = DatabaseAccess.db().document(withID: docID)
        return document?.properties?[DocumentKeys.title.rawValue] as? String
    }
}

struct DocumentRemover {
    var docID: String
    
    func remove() -> Bool {
        let document = DatabaseAccess.db().document(withID: docID)
        if let _ = try? document?.delete() {
            return true
        }
        return false
    }
}

struct DocumentAdder {
    var title: String
    
    func add() -> String? {
        let document = DatabaseAccess.db().createDocument()
        _ = try? document.putProperties([DocumentKeys.title.rawValue: title])
        return document.documentID
    }
}


enum DocumentKeys: String {
    case title
}
