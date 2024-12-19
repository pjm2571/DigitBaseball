//
//  ViewController.swift
//  DigitBaseball
//
//  Created by zoonmy on 12/19/24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showScreen(withIdentifier: "gameViewController")
        }
    }
    
    // 화면 전환
    private func showScreen(withIdentifier: String) {
        if let mainVC = storyboard?.instantiateViewController(withIdentifier: withIdentifier) {
            mainVC.modalTransitionStyle = .crossDissolve // 부드러운 전환 효과
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated: true, completion: nil)
        } else {
            print("error")
        }
    }

}

