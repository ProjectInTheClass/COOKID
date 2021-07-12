//
//  InputShoppingListView.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/10.
//

import SwiftUI

struct InputMealView: View {
    @State var image = UIImage()
    @State var imageURL: URL?
    
    @State var currentDate = Date().dateToString()
    @State var selectedDate: Date?
    
    @State var mealName = ""
    @State var mealTime: String?
    
    @State var price = ""
    
    @State var selectionIndex = 0
    
    @State var isDineOut = false
    @State var mealType = MealType.dineIn.rawValue
    
    @State var isFocused: Bool = false
    @State var showImagePicker: Bool = false
    
    @State var meal: Meal?
    
    var dismissView: (() -> Void)
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Image Button
                    VStack {
                        Button(action: {
                            showImagePicker = true
                        }, label: {
                            ZStack {
                                Image(systemName: "camera.circle")
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.black.opacity(0.7))
                            .frame(width: 300, height: 160, alignment: .center)
                            .background(Color.gray.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 22.0, style: .continuous))
                            .shadow(color: .black.opacity(0.4), radius: 20, x: 5, y: 10)
                            .padding(.top)
                        })
                    }
                    
                    // Toggle View
                    VStack {
                        HStack {
                            if #available(iOS 14.0, *) {
                                Toggle(isOn: $isDineOut, label: {
                                    Text(mealType)
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }).onChange(of: isDineOut, perform: { value in
                                    withAnimation(.easeInOut) {
                                        if value {
                                            self.mealType = MealType.dineOut.rawValue
                                            self.isDineOut = true
                                        } else {
                                            self.mealType = MealType.dineIn.rawValue
                                        }
                                    }
                                })
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    
                    
                    Divider()
                    
                    
                    // Price TextField
                    if isDineOut {
                        VStack(spacing: 8) {
                            VStack {
                                HStack {
                                    Text("가격")
                                        .font(.body)
                                        .foregroundColor(Color.gray)
                                    Spacer()
                                }
                                .padding(.leading, 40)
                                
                                VStack {
                                    TextField("금액을 입력해 주세요.", text: $price)
                                        .keyboardType(.numberPad)
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
                        } .transition(.opacity)
                    }
                    
                    
                    // Date Picker TextField
                    VStack(spacing: 8) {
                        HStack {
                            Text("날짜")
                                .font(.body)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                        .padding(.leading, 40)
                        
                        VStack {
                            DatePickerTextField(placeHolder: currentDate, date: $selectedDate)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    
                    
                    // MealType Picker TextField
                    VStack(spacing: 8) {
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
                                placeholder: "아침",
                                selectionIndex: $selectionIndex,
                                text: ($mealTime))
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
                    
                    
                    // Menu TextField
                    VStack {
                        HStack {
                            Text("메뉴")
                                .font(.body)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.leading, 40)
                        
                        VStack {
                                TextField("무엇을 드셨나요?", text: $mealName)
                                    
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
                    Spacer()
                }
                .offset(y: -30)
                .animation(isDineOut ? .easeIn : nil)
            }
            .onTapGesture {
                isFocused = false
                hideKeyboard()
            }
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
            })
            
            .navigationBarHidden(false)
            .navigationBarItems(
                leading: Button(action: {
                    dismissView()
                }, label: {
                    Text("Cancle")
                }), trailing: Button(action: {
                    
                    MealRepository.shared.fetchingImageURL(uid: AuthRepository.shared.uid, mealID: mealName, image: image) {  url in
                        
                        self.meal = Meal(
                            price: Int(price) ?? 0,
                            date: selectedDate ?? Date() ,
                            name: mealName,
                            image: url,
                            mealType: MealType(rawValue: mealType) ?? MealType.dineIn,
                            mealTime: MealTime(rawValue: mealTime ?? "") ?? .breakfast)
                        
                        if let meal = self.meal {
                            MealRepository.shared.uploadMealToFirebase(meal: meal)
                        }
                    }
                    dismissView()
                }, label: {
                    Text("Save")
            }))
        }
    }
    
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

