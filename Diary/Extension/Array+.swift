//
//  Array+.swift
//  Diary
//
//  Created by 조호준 on 2023/09/05.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
