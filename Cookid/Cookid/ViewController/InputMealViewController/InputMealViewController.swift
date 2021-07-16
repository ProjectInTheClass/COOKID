//
//import UIKit
//import SwiftUI
//import Combine
//
//class InputMealViewController: UIViewController {
//
//    private let delegate = InputMealViewDelegate()
//    private var cancellable: AnyCancellable?
//    var saveMeal: ((Meal) -> Void)?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        let inputMealView = UIHostingController(rootView: InputMealView(mealDelegate: delegate,
//             dismissView: {self.dismiss(animated: true, completion: nil)},
//             saveButtonTapped: {
//            self.cancellable = self.delegate.$meal.sink(receiveValue: { [weak self] meal in
//                guard let newMeal = meal else { return }
//                self?.saveMeal!(newMeal)})
//             }
//        ))
//
//        inputMealView.view.translatesAutoresizingMaskIntoConstraints = false
//        self.addChild(inputMealView)
//        self.view.addSubview(inputMealView.view)
//
//        NSLayoutConstraint.activate([
//            inputMealView.view.widthAnchor.constraint(equalTo: view.widthAnchor),
//            inputMealView.view.heightAnchor.constraint(equalTo: view.heightAnchor)
//        ])
//        
//    }
//}
//
//
//class InputMealViewDelegate: ObservableObject {
//    @Published var meal: Meal?
//}
