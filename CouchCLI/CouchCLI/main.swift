//
//  main.swift
//  CouchCLI
//
//  Created by André Vellori on 28/04/2017.
//  Copyright © 2017 André Vellori. All rights reserved.
//

import Foundation

func main() {
    let db = try! CBLManager.sharedInstance().databaseNamed("any")
    
    let url = URL(string: "http://ec2-52-14-192-85.us-east-2.compute.amazonaws.com:4984/db")!
    let push = db.createPushReplication(url)
    let pull = db.createPullReplication(url)
    push.continuous = true
    pull.continuous = true
    push.start()
    pull.start()
    
    let document = db.createDocument()
    _ = try? document.putProperties(["title": CommandLine.arguments[1]])
    
    while (push.isDocumentPending(document)) {
        sleep(1)
    }
    
    
}

main()

