//
//  ViewControllerView.swift
//  ChatApp
//
//  Created by 柯元豪 on 2020/5/24.
//  Copyright © 2020 Yuanhao. All rights reserved.
//

import SwiftUI

struct ViewControllerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = LoginViewController
    
    func makeUIViewController(context: Context) -> LoginViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController") as! LoginViewController
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
    }
}

//struct ViewControllerView_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
