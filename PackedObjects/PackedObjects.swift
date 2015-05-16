//
//  PackedObjects.swift
//  testpackedobjects
//
//  Created by John Moore on 15/05/2015.
//  Copyright (c) 2015 John Moore. All rights reserved.
//

import Foundation

class PackedObjects {
    private var pc: UnsafeMutablePointer<packedobjectsContext>
    var bytes: NSInteger = 0
    
    init(schema: String) {
        self.pc = init_packedobjects(schema, 0, 0)
        assert(pc != nil)
    }
    
    init(schema: String, bytes: Int) {
        self.pc = init_packedobjects(schema, bytes, 0)
        assert(pc != nil)
    }
    
    init(schema: String, bytes: Int, options: CInt) {
        self.pc = init_packedobjects(schema, bytes, options)
        assert(pc != nil)
    }
    
    func encode(xml: String) -> NSData? {
        let data = packedobjects_encode_with_string(pc, xml)
        if (data == nil) {
            return nil
        }
        self.bytes = NSInteger(UInt32(pc.memory.bytes))
        return NSData(bytes: data, length: self.bytes)
    }
    
    func decode(data: NSData) -> String? {
        self.bytes = data.length
        var array = [Int8](count: self.bytes, repeatedValue: 0)
        data.getBytes(&array, length: self.bytes)
        let cstr = packedobjects_decode_to_string(pc, &array)
        if (cstr == nil) {
            return nil
        }
        let str = String.fromCString(cstr)!
        free(cstr)
        return str
    }
    
    deinit {
        free_packedobjects(pc)
    }
}
