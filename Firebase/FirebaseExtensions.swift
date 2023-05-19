//
//  File.swift
//  
//
//  Created by Samuel Vulakh on 5/19/23.
//

import Firebase

// Firestore Extensions
extension Firestore {
    
    /// Users Database Collection Reference
    static var users: CollectionReference { firestore().collection("users") }
    
    /// Get Current User Document (Is NIL If User Is Not Logged In)
    static var current: DocumentReference? {
        
        /// Making Sure Current User ID Exists
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        
        // Returning Current User Document If ID Is Valid
        return Firestore.users.document(uid)
    }
}
