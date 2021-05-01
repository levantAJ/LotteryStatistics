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
    let datesRef: DatabaseReference
    
    init() {
        ref = Database.database().reference()
        drawsRef = ref.child("draws")
        datesRef = ref.child("crawls")
    }
    
    func saveIfNeeded(draw: Draw) {
        let key = keyFrom(date: draw.date)
        let child = drawsRef.child(key)
        child.observeSingleEvent(of: .value) { (dataSnapshot) in
            if !dataSnapshot.exists() {
                child.setValue(draw.json)
            }
        }
    }
    
    func saveIfNeeded(crawl: Crawl) {
        let key = keyFrom(date: crawl.date)
        let child = datesRef.child(key)
        child.observeSingleEvent(of: .value) { (dataSnapshot) in
            if !dataSnapshot.exists() {
                child.setValue(crawl.json)
            }
        }
    }

    func drawIsExisted(date: Date, completion: @escaping (Bool) -> Void) {
        let child = datesRef.child(keyFrom(date: date))
        child.observe(.value) { (dataSnapshot) in
            completion(dataSnapshot.exists())
        }
    }
    
    func draws(completion: @escaping (Response<[Draw]>) -> Void) {
        DispatchQueue.global().async {
            self.drawsRef.queryOrdered(byChild: "id").observe(.value) { (dataSnapshot) in
                do {
                    let data = try JSONSerialization.data(withJSONObject: dataSnapshot.value!, options: [])
                    let dict = try JSONDecoder().decode([String: Draw].self, from: data)
                    let draws = Array(dict.values)
                    DispatchQueue.main.async {
                        completion(.success(draws))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    class func setUp() {
        FirebaseApp.configure()
    }
}

//MARK: - Privates

extension FirebaseDatabase {
    func keyFrom(date: Date) -> String {
        return date.string(dateFormat: "yyyy-MM-dd")
    }
}

// MARK: - DBStorage

final class DBStorage {
    lazy var database = FirebaseDatabase()

    func save(draws: [Draw]) {
        for draw in draws {
            database.saveIfNeeded(draw: draw)
            database.saveIfNeeded(crawl: Crawl(date: draw.date, hasData: true))
        }
    }
}
