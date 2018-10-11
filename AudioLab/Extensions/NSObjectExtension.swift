//
//  NSObjectExtension.swift
//  AudioLab
//
//  Created by Sagar Gondaliya on 08/04/18.
//
//

import Foundation
import ObjectiveC

// Declare a global var to produce a unique address as the assoc object handle
var AssociatedObjectHandle: UInt8 = 0

extension NSObject {
    
    /// Sets associated object
    public func setAssociatedObject(_ object: Any) {
        objc_setAssociatedObject(self, &AssociatedObjectHandle, object, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// Gets associated object
    public func associatedObject() -> Any? {
        return objc_getAssociatedObject(self, &AssociatedObjectHandle)
    }
}
