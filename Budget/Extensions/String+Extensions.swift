//
//  String+Extensions.swift
//  Budget
//
//  Created by Vlad on 30/5/25.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
