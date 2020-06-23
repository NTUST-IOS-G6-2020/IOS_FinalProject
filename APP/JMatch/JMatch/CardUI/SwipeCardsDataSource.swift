//
//  SwipeCardDataSource.swift
//  JMatch
//
//  Created by 柯元豪 on 2020/6/22.
//  Copyright © 2020 IOS-G6. All rights reserved.
//

import UIKit

protocol SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> SwipeCardView
    func emptyView() -> UIView?
    
}

protocol SwipeCardsDelegate {
    func swipeDidEnd(on view: SwipeCardView)
}
