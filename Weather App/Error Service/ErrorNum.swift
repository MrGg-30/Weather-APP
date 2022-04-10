//
//  ErrorNum.swift
//  Weather App
//
//  Created by Tornike on 19.02.22.
//

import UIKit


enum ServiceError: Error {
    case httpLayerError
    case parseError
    case noDataError
    case invalidParametersError
    
    var description : String {
        switch self {
       
        case .httpLayerError:
            return "httpLayerError"
        case .parseError:
            return "parseError"
        case .noDataError:
            return "noDataError"
        case .invalidParametersError:
            return "invalidParameters"
        }
    }
}
