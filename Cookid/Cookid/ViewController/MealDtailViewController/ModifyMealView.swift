////
////  ModifyMealView.swift
////  Cookid
////
////  Created by 임현지 on 2021/07/12.
////
//
import SwiftUI
import Combine
import Kingfisher

@available(iOS 14.0, *)
struct ModifyMealView: View {
    @State var image = UIImage()
    @State var currentDate = Date().dateToString()
    @State var selectedDate: Date?
    @State var mealName = ""
    @State var mealTime = ""
    @State var price = ""
    
    @State var selectionIndex = 0
    @State var mealType: MealType?
    
    @Binding var isDineOut: Bool 
    @State var isFocused: Bool = false
    @State var showImagePicker: Bool = false
    @State var isImageSelected: Bool = false
    @State var saveButtonTapped: Bool = false
    @State var cancel: Bool = false
    
    var disposeBag = Set<AnyCancellable>()
    var cancelTapped: (() -> Void)
    var saveTapped: (() -> Void)
    var namespace: Namespace.ID
    var meal: Meal
    
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                
                Text("취소")
                    .bold()
                    .foregroundColor(.red)
                    .onTapGesture {
                        
                    }
                Spacer()
                Text("저장")
                    .bold()
                    .foregroundColor(.blue)
                    .onTapGesture {
                        meal.name = mealName
                        saveTapped()
                    }
                    
            }
            .matchedGeometryEffect(id: "navBarItem", in: namespace)
            .padding(.top, 24)
            .padding(.horizontal)
            
            VStack {
                VStack {
                    Button(action: {
                        showImagePicker = true
                    }, label: {
                        ZStack {
                            Image(systemName: "camera.circle")
                                .font(.system(size: 40))
                                .foregroundColor(.black.opacity(0.6))
                            if isImageSelected {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .onReceive(Just(image), perform: { newImage in
                                        if isImageSelected {
                                            MealRepository.shared.fetchingImageURL(mealID: meal.id!, image: newImage) { url in
                                                meal.image = url
                                            }
                                        } else {
                                            meal.image = meal.image
                                        }
                                    })
                                    
                                    
                            } else {
                                KFImage.url(meal.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                    })
                }
                .frame(width: 150, height: 150)
                .background(Color.clear.matchedGeometryEffect(id: "cameraButton", in: namespace))
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
                .padding(.top, 30)
            }
            
            // Switch
            VStack {
                HStack {
                    Toggle(isOn: $isDineOut, label: {
                        Text(isDineOut ? "외식" : "집밥")
                            .font(.body)
                            .foregroundColor(.gray)
                    })
                    .toggleStyle(SwitchToggleStyle(tint: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))))
                    .onReceive(Just(isDineOut), perform: { dineOut in
                        if !cancel {
                            if dineOut {
                                meal.mealType = .dineOut
                            } else {
                                meal.mealType = .dineIn
                            }
                        }
                            
                    })
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
            }
            
            
            Divider()
            
            // price
            if isDineOut {
                VStack {
                    VStack {
                        HStack {
                            Text("가격")
                                .font(.body)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.leading, 40)
                        
                        VStack {
                            TextField("\(meal.price)", text: $price)
                                .keyboardType(.numberPad)
                                .onReceive(Just(price), perform: { newPrice in
                                    guard saveButtonTapped else { return }
                                    if newPrice == "" {
                                        meal.price = meal.price
                                    } else {
                                        meal.price = Int(newPrice)!
                                    }
                                })
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.black.opacity(0.2))
                        )
                        .padding(.horizontal, 26)
                    }
                }
            }
            
            // date
            VStack(spacing: 8) {
                HStack {
                    Text("날짜")
                        .font(.body)
                        .foregroundColor(Color.gray)
                    Spacer()
                }
                .padding(.leading, 40)
                
                VStack {
                    DatePickerTextField(placeHolder: meal.date.dateToString(), date: $selectedDate)
                        .onReceive(Just(selectedDate), perform: { newDate in
                            guard saveButtonTapped else { return }
                            meal.date = newDate ?? meal.date
                        })
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.black.opacity(0.2))
                )
                .padding(.horizontal, 26)
            }
            
            //mealTime
            VStack {
                HStack {
                    Text("식사시간")
                        .font(.body)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.leading, 40)
                
                VStack {
                    TextFieldWithPickerAsInputView(
                        data: MealTime.allCases.map { String($0.rawValue) },
                        placeholder: "\(meal.mealTime.rawValue)",
                        selectionIndex: $selectionIndex,
                        text: $mealTime)
                        .onReceive(Just(mealTime), perform: { newMealTime in
                            guard saveButtonTapped else { return }
                            meal.mealTime = MealTime(rawValue: newMealTime) ?? meal.mealTime
                        })
                        
                }
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.black.opacity(0.2))
                )
                .padding(.horizontal, 26)
            }
            
            // mealname
            VStack {
                HStack {
                    Text("메뉴")
                        .font(.body)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.leading, 40)
                
                VStack {
                    TextField("\(meal.name)", text: $mealName)
                        .matchedGeometryEffect(id: "mealName", in: namespace)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.black.opacity(0.2))
                        )
                        .padding(.horizontal, 26)
                        .onTapGesture {
                            isFocused = true
                        }
                        
                }
            }
            .padding(.bottom,30)
        }
        .background(Color.white.matchedGeometryEffect(id: "background", in: namespace))
        .cornerRadius(30)
        .padding()
        .shadow(radius: 20)
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(selectedImage: $image, isImageSelected: $isImageSelected)
        })
        
    }
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

