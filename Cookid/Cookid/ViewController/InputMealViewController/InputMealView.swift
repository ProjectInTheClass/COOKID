////
////  InputShoppingListView.swift
////  Cookid
////
////  Created by 임현지 on 2021/07/10.
////

import SwiftUI
import Combine

struct InputMealView: View {
    @ObservedObject var mealDelegate: InputMealViewDelegate
    
    @State var image = UIImage()
    @State var imageURL: URL?
    
    @State var currentDate = Date().dateToString()
    @State var selectedDate: Date?
    
    @State var mealName = ""
    @State var mealTime = ""
    
    @State var price = ""
    
    @State var selectionIndex = 0
    
    @State var isDineOut = false
    @State var mealType = MealType.dineIn
    
    @State var isFocused: Bool = false
    @State var priceTFIsFocused: Bool = false
    @State var showImagePicker: Bool = false
    @State var isEmpty: Bool = true
    @State var isImageSelected: Bool = false
    
    @State var meal: Meal?
    
    var dismissView: (() -> Void)
    var saveButtonTapped: ((Meal) -> Void)

    let mealRepo = MealRepository()
    
    var body: some View {
        ZStack {
            ZStack {
                GeometryReader { proxy in
                    Color.black.opacity(0.8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { dismissView() }
                
                VStack(spacing: 20) {
                    
                    // Image Button
                    VStack {
                        Button(action: {
                            showImagePicker = true
                        }, label: {
                            ZStack {
                                Image(systemName: "camera.circle")
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 150, height: 150)
                            .background(Color.gray.opacity(isImageSelected ? 0 : 0.2))
                            .clipShape(Circle())
                            .padding(.top, 20)
                            .shadow(color: .black.opacity(0.2), radius: 20, x: 1, y: 5)
                        })
                    }
                    
                    Divider()
                    
                    // Date Picker TextField
                    VStack(spacing: 2) {
                        HStack {
                            Text("날짜")
                                .font(.body)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        VStack {
                            DatePickerTextField(placeHolder: currentDate, date: $selectedDate)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 30)
                    
                    
                    // MealType Picker TextField
                    VStack(spacing: 2) {
                        HStack {
                            Text("식사시간")
                                .font(.body)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        VStack {
                            TextFieldWithPickerAsInputView(
                                data: MealTime.allCases.map { String($0.rawValue) },
                                placeholder: "아침",
                                selectionIndex: $selectionIndex,
                                text: $mealTime)
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 30)
                    
                    
                    // Menu TextField
                    VStack(spacing: 2) {
                        HStack {
                            Text("메뉴")
                                .font(.body)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        VStack {
                            TextField("무엇을 드셨나요?", text: $mealName)
                                .onReceive([self.mealName].publisher.first(), perform: { mealName in
                                    if mealName == "" {
                                        self.isEmpty = true
                                    } else {
                                        self.isEmpty = false
                                    }
                                })
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(Color(.systemIndigo))
                                .onTapGesture { isFocused = true }
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    // Toggle View
                    VStack {
                        HStack {
                            if #available(iOS 14.0, *) {
                                Toggle(isOn: $isDineOut, label: {
                                    Text(mealType.rawValue)
                                        .font(.body)
                                        .foregroundColor(.black)
                                })
                                .toggleStyle(SwitchToggleStyle(tint: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))))
                                .onReceive([self.isDineOut].publisher.first()) { isDineOut in
                                    if isDineOut {
                                        self.mealType = .dineOut
                                    } else {
                                        self.mealType = .dineIn
                                    }
                                }
                            } else {
                                Toggle(isOn: $isDineOut, label: {
                                    Text(mealType.rawValue)
                                        .font(.body)
                                        .foregroundColor(.black)
                                })
                                .onReceive([self.isDineOut].publisher.first()) { isDineOut in
                                    if isDineOut {
                                        self.mealType = .dineOut
                                    } else {
                                        self.mealType = .dineIn
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom)
                    
                    // Price TextField
                    if isDineOut {
                        VStack(spacing: 2) {
                            VStack {
                                HStack {
                                    Text("가격")
                                        .font(.body)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                VStack {
                                    TextField("금액을 입력해 주세요.", text: $price)
                                        .keyboardType(.decimalPad)
                                        .foregroundColor(Color(.systemIndigo))
                                        .onTapGesture {
                                            priceTFIsFocused = true
                                        }
                                }
                                .frame(height: 44)
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 30)
                        .transition(.opacity)
                        
                    }
                    
                    
                    // 체크 버튼
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.spring()) {
                                if isImageSelected {
                                    mealRepo.fetchingImageURL(mealID: mealName, image: image) { url in
                                        self.meal = Meal(
                                            id: "nil",
                                            price: Int(price) ?? 0,
                                            date: selectedDate ?? Date(),
                                            name: mealName,
                                            image: url ?? nil,
                                            mealType: mealType,
                                            mealTime: MealTime(rawValue: mealTime) ?? .breakfast)
                                        mealDelegate.meal = self.meal
                                        saveButtonTapped(self.meal!)}
                                } else { self.meal = Meal(id: "nil",
                                                          price: Int(price) ?? 0,
                                                          date: selectedDate ?? Date(),
                                                          name: mealName,
                                                          image: nil,
                                                          mealType: mealType,
                                                          mealTime: MealTime(rawValue: mealTime) ?? .breakfast)
                                    mealDelegate.meal = self.meal
                                    saveButtonTapped(self.meal!)}
                                
                                dismissView()
                            }
                        }, label: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(isEmpty ? .gray : .yellow)
                                .font(.system(size: 40))
                        })
                        .disabled(isEmpty ? true : false)
                    }
                    .padding(.bottom, 24)
                    .padding(.trailing, 24)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 20)
                .padding(40)
                .animation(isDineOut ? .easeIn : nil)
                .offset(y: withAnimation {
                    isFocused ? -230 : 0
                })
                .offset(y: priceTFIsFocused ? -230 : 0)
            }
            .background(Color.clear)
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                isFocused = false
                priceTFIsFocused = false
                hideKeyboard()
            }
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $image, isImageSelected: $isImageSelected)
        })
        }
    }
    
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}


struct preview : PreviewProvider{
    static var previews: some View {
        InputMealView(mealDelegate: InputMealViewDelegate(), dismissView: {}, saveButtonTapped: {_ in})
    }
}
