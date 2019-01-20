//
//  GenericDatasource.swift
//  LibertyPoolTest
//
//  Created by Nidhi  on 18/01/19.
//  Copyright © 2019 LibertyPool. All rights reserved.
//

import Foundation

class GenericDataSource<T>: NSObject {
    var data: DataSourceValue<[T]> = DataSourceValue([])
}
