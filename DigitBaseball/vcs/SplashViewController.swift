//
//  ViewController.swift
//  DigitBaseball
//
//  Created by zoonmy on 12/19/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2초 후에 메인 화면으로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            if let user = Auth.auth().currentUser {
//                print("현재 로그인된 사용자: \(user.email ?? "이메일 없음")")
//                // 로그인 되어 있으면 메인화면으로 이동
//                self.showScreen(withIdentifier: "mainTabBarController")
//            } else {
//                print("로그인된 사용자가 없습니다.")
//                // 로그인 되어 있지 않으면 인트로 화면으로 이동
//                self.showScreen(withIdentifier: "introViewController")
//            }
            self.showScreen(withIdentifier: "MainViewController")
        }
    }
    
    // 화면 전환
    private func showScreen(withIdentifier: String) {
        if let mainVC = storyboard?.instantiateViewController(withIdentifier: withIdentifier) {
            mainVC.modalTransitionStyle = .crossDissolve // 부드러운 전환 효과
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated: true, completion: nil)
        }
    }

}

