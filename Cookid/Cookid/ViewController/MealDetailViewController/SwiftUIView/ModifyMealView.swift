////
////  ModifyMealView.swift
////  Cookid
////
////  Created by 임현지 on 2021/07/12.
////
//
//import SwiftUI
//
//@available(iOS 14.0, *)
//struct ModifyMealView: View {
//        @State var image = UIImage()
//        @State var currentDate = Date().dateToString()
//        @State var selectedDate: Date?
//        @State var mealName = ""
//        @State var mealTime: String?
//        @State var price = ""
//        
//        @State var selectionIndex = 0
//        @State var isDineOut = false
//        @State var mealType = MealType.dineIn.rawValue
//        
//        @State var isFocused: Bool = false
//        @State var showImagePicker: Bool = false
//        
//        @State var show: Bool = false
//        
//        var namespace: Namespace.ID
//        var meal: Meal
//        
//        
//        var body: some View {
//                VStack(spacing: 20) {
//                    HStack {
//                        Text("취소")
//                            .bold()
//                            .foregroundColor(.red)
//                        
//                        Spacer()
//                        Text("저장")
//                            .bold()
//                            .foregroundColor(.blue)
//                    }
//                    .matchedGeometryEffect(id: "navBarItem", in: namespace)
//                    .padding(.top, 24)
//                    .padding(.horizontal)
//                    
//                    VStack {
//                        Image(systemName: "camera.circle")
//                            .font(.system(size: 40))
//                            .foregroundColor(.black.opacity(0.6))
//                            .frame(width: 150, height: 150)
//                            .background(
//                                Color.black.opacity(0.3)
//                                    .matchedGeometryEffect(id: "cameraButton", in: namespace)
//                            )
//                            .clipShape(Circle())
//                            .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
//                            .padding(.top, 30)
//                    }
//                    
//                    // Switch
//                    VStack {
//                        HStack {
//                            Toggle(isOn: $isDineOut, label: {
//                                Text(meal.mealType.rawValue ?? "")
//                                    .font(.body)
//                                    .foregroundColor(.gray)
//                            })
//                            .toggleStyle(SwitchToggleStyle(tint: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))))
//                            .onChange(of: isDineOut, perform: { value in
//                                if value {
//                                    self.mealType = MealType.dineOut.rawValue
//                                } else {
//                                    self.mealType = MealType.dineIn.rawValue
//                                }
//                            })
//                        }
//                        .padding(.horizontal, 30)
//                        .padding(.top, 20)
//                    }
//                    
//                    Divider()
//                    
//                    // price
//                    if meal.mealType == MealType.dineOut {
//                        VStack {
//                            VStack {
//                                HStack {
//                                    Text("가격")
//                                        .font(.body)
//                                        .foregroundColor(Color.gray)
//                                    Spacer()
//                                }
//                                .padding(.leading, 40)
//                                
//                                VStack {
//                                    TextField("\(meal.price)", text: $price)
//                                        .keyboardType(.numberPad)
//                                }
//                                .frame(height: 44)
//                                .frame(maxWidth: .infinity)
//                                .padding(.horizontal)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
//                                        .stroke(Color.black.opacity(0.2))
//                                )
//                                .padding(.horizontal, 26)
//                            }
//                        }
//                    }
//                    
//                    // date
//                    VStack(spacing: 8) {
//                        HStack {
//                            Text("날짜")
//                                .font(.body)
//                                .foregroundColor(Color.gray)
//                            Spacer()
//                        }
//                        .padding(.leading, 40)
//                        
//                        VStack {
//                            DatePickerTextField(placeHolder: meal.date.dateToString() ?? Date().dateToString(), date: $selectedDate)
//                        }
//                        .frame(height: 44)
//                        .frame(maxWidth: .infinity)
//                        .padding(.horizontal)
//                        .background(
//                            RoundedRectangle(cornerRadius: 30, style: .continuous)
//                                .stroke(Color.black.opacity(0.2))
//                        )
//                        .padding(.horizontal, 26)
//                    }
//                    
//                    //mealTime
//                    VStack {
//                        HStack {
//                            Text("식사시간")
//                                .font(.body)
//                                .foregroundColor(.gray)
//                            Spacer()
//                        }
//                        .padding(.leading, 40)
//                        
//                        VStack {
//                            TextFieldWithPickerAsInputView(
//                                data: MealTime.allCases.map { String($0.rawValue) },
//                                placeholder: "\(meal.mealTime.rawValue)",
//                                selectionIndex: $selectionIndex,
//                                text: $mealTime)
//                        }
//                        .frame(height: 44)
//                        .frame(maxWidth: .infinity)
//                        .padding(.horizontal)
//                        .background(
//                            RoundedRectangle(cornerRadius: 30, style: .continuous)
//                                .stroke(Color.black.opacity(0.2))
//                        )
//                        .padding(.horizontal, 26)
//                    }
//                    
//                    // mealname
//                    VStack {
//                        HStack {
//                            Text("메뉴")
//                                .font(.body)
//                                .foregroundColor(.gray)
//                            Spacer()
//                        }
//                        .padding(.leading, 40)
//                        
//                        VStack {
//                            TextField("\(meal.name)", text: $mealName)
//                                .matchedGeometryEffect(id: "mealName", in: namespace)
//                                .frame(height: 44)
//                                .frame(maxWidth: .infinity)
//                                .padding(.horizontal)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
//                                        .stroke(Color.black.opacity(0.2))
//                                )
//                                .padding(.horizontal, 26)
//                                .onTapGesture {
//                                    isFocused = true
//                                }
//                        }
//                    }
//                    .padding(.bottom,30)
//                }
//                .background(Color.white.matchedGeometryEffect(id: "background", in: namespace))
//                .cornerRadius(30)
//                .padding()
//                .shadow(radius: 20)
//                .onAppear {
//                    if meal.mealType == .dineOut {
//                        isDineOut = true
//                    }
//                }
//            }
//        func hideKeyboard() {
//            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//        }
//        }
//
//
//
//
////struct ModifyMealView_Previews: PreviewProvider {
////    static var previews: some View {
////        ModifyMealView()
////    }
////}
