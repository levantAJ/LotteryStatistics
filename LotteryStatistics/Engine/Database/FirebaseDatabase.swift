//
//  FirebaseDatabase.swift
//  LotteryStatistics
//
//  Created by levantAJ on 11/3/18.
//  Copyright © 2018 levantAJ. All rights reserved.
//

import Firebase

class FirebaseDatabase {
    let ref: DatabaseReference
    let drawsRef: DatabaseReference
    
    init() {
        ref = Database.database().reference()
        drawsRef = ref.child("draws")
    }
    
    func saveIfNeeded(draw: Draw) {
        let key = draw.date.shortFormatString
        let child = drawsRef.child(key)
        child.observe(.value) { (dataSnapshot) in
            if !dataSnapshot.exists() {
                child.setValue(draw.json)
            }
        }
    }
    
    func drawIsExisted(date: Date, completion: @escaping (Bool) -> Void) {
        let child = drawsRef.child(date.shortFormatString)
        child.observe(.value) { (dataSnapshot) in
            completion(dataSnapshot.exists())
        }
    }
    
    class func setUp() {
        FirebaseApp.configure()
    }
}
