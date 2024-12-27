//
//  SceneDelegate.swift
//  Todoey
//
//  Created by murad on 19.12.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        configureNavBar()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        //window?.rootViewController = UINavigationController(rootViewController: TodoListViewController())
        window?.rootViewController = UINavigationController(rootViewController: CategoryViewController())
        window?.makeKeyAndVisible()
    }
    
    private func configureNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white,
                                          .font: UIFont.systemFont(ofSize: 25, weight: .medium)]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

