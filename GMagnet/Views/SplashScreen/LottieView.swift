/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 3
  Authors: Le Quynh Giang (s3802828), Phan Truong Quynh Anh (s3818245), Ngo Huu Tri (s3818520), Pham Thanh Dat (s3678437)
  Created  date: 14/09/2022
  Last modified: 18/09/2022
 Acknowledgement:
 How to add animated assets using Lottie in SwiftUI - https://designcode.io/swiftui-handbook-lottie-animation
 */
import Lottie
import SwiftUI
 
struct LottieView: UIViewRepresentable{
    typealias UIViewType = UIView
    
    //Run "loading" lottie json animation file
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = AnimationView()
        animationView.animation = Animation.named("loading")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.play()
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context contect: UIViewRepresentableContext<LottieView>) {
        
    }
}
