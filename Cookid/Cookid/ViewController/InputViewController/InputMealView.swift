//
//  InputShoppingListView.swift
//  Cookid
//
//  Created by 임현지 on 2021/07/10.
//

import SwiftUI

struct InputMealView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var image = UIImage()
    @State var currentDate = Date().dateToString()
    @State var selectedDate: Date?
    @State var mealName = ""
    @State var mealTime: String?
    @State var price = 0
    
    @State var selectionIndex = 0
    @State var isDineOut = false
    @State var mealType = MealType.dineIn.rawValue
    @State var meal:  Meal?
    
    @State var isFocused: Bool = false
    @State var showImagePicker: Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                if #available(iOS 14.0, *) {
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
                                            .aspectRatio(contentMode: .fill)
                                        
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
                                            
                                            if value {
                                                self.mealType = MealType.dineOut.rawValue
                                            } else {
                                                self.mealType = MealType.dineIn.rawValue
                                            }
                                        })
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                }
                                .padding(.horizontal, 30)
                                .padding(.top, 20)
                            }
                            
                            Divider()
                            
                            // Price TextField
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
                                            TextField("금액을 입력해 주세요.", value: $price, formatter: NumberFormatter())
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
                                }
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
                                        placeholder: "아침",
                                        selectionIndex: $selectionIndex,
                                        text: $mealTime)
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
                        .offset(y: isFocused ? -150 : 0)
                        .onTapGesture {
                            isFocused = false
                            hideKeyboard()
                        }
                        .sheet(isPresented: $showImagePicker, content: {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                        })
                    }
                    .navigationBarItems(trailing: Button(action: {
                        let meal = Meal(price: price,
                                    date: selectedDate ?? Date(),
                                    name: mealName,
                                    image: nil,
                                    mealType: MealType(rawValue: mealType) ?? .dineIn,
                                    mealTime: MealTime(rawValue: mealTime!) ?? .breakfast)
                        
                        if meal != nil {
                            MealRepository.shared.pushMealToFirebase(meal: meal)
                            MealRepository.shared.uploadMealImage(mealName: meal.name, image: image)
                        } else {
                            //disabled(true)
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        Text("Save")
                    }))
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    // Fallback on earlier versions
                }
                
            }
            
        }
    }
    
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


