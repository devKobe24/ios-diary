//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/09/02.
//

import UIKit
import CoreLocation

final class DetailDiaryViewController: UIViewController {
    private let locationManager = CLLocationManager()
    
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.keyboardDismissMode = .onDrag
        
        return textView
    }()
    
    private let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    private var diary: DiaryEntity
    
    init(diary: DiaryEntity) {
        self.diary = diary
        
        super.init(nibName: nil, bundle: nil)
        
        self.configureUI()
        self.configureDelegates()
        self.setupKeyboardEvent()
        self.fetchDiaryData(diary)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchDiaryData(_ data: DiaryEntity) {
        guard let title = data.title,
              let body = data.body,
              let createdAt = data.createdAt  else {
            
            return
        }
        
        diary = data
        diaryTextView.text = "\(title)\n\(body)"
        
        configureNavigationItem(date: createdAt)
    }
    
    func saveDiaryData() {
        let splitedText = diaryTextView.text.split(separator: "\n")
        let title = String(splitedText[safe: 0] ?? .init())
        let body = String(diaryTextView.text.dropFirst(title.count))
        
        diary.title = title
        diary.body = body
        
        persistentContainer?.saveContext()
    }
    
    private func configureDelegates() {
        diaryTextView.delegate = self
        // MARK: - CLLocationManager instance delegate setting
        locationManager.delegate = self
    }
}

extension DetailDiaryViewController {
    private func configureUI() {
        configureView()
        configureNavigationItem()
        addSubViews()
        diaryTextViewConstraints()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationItem(date: Date = Date()) {
        navigationItem.title = DiaryDateFormatter.convertDate(date, Locale.current.identifier)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "일기장", style: .plain, target: self, action: #selector(didTapBackToMainButton))
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(didTapMoreOptionsButton))
    }
    
    private func addSubViews() {
        view.addSubview(diaryTextView)
    }
    
    private func diaryTextViewConstraints() {
        diaryTextView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 15.0, *) {
            NSLayoutConstraint.activate([
                diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                diaryTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
}

extension DetailDiaryViewController {
    private func setupKeyboardEvent() {
        if #unavailable(iOS 15.0) {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            
            return
        }
        
        diaryTextView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: keyboardFrame.height, right: .zero)
    }
    
    @objc private func keyboardWillHide() {
        diaryTextView.contentInset = UIEdgeInsets()
    }
    
    @objc private func keyboardDidHide() {
        saveDiaryData()
    }
}

extension DetailDiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.becomeFirstResponder()
    }
}

extension DetailDiaryViewController {
    @objc private func didTapBackToMainButton() {
        saveDiaryData()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapMoreOptionsButton() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareSheetAction = createShareSheetAction()
        let deleteSheetAction = createDeleteSheetAction()
        let cancelSheetAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(shareSheetAction)
        actionSheet.addAction(deleteSheetAction)
        actionSheet.addAction(cancelSheetAction)
        
        self.present(actionSheet, animated: true)
    }
    
    private func createShareSheetAction() -> UIAlertAction {
        let shareSheetAction = UIAlertAction(title: "Share...", style: .default) { _ in
            guard let title = self.diary.title,
                  let body = self.diary.body,
                  let createdAt = self.diary.createdAt else {
                
                return
            }
            
            let activityView = UIActivityViewController(activityItems: [title, body, createdAt], applicationActivities: nil)
            self.present(activityView, animated: true)
        }
        
        return shareSheetAction
    }
    
    private func createDeleteSheetAction() -> UIAlertAction {
        let deleteSheetAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            let deleteAlert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.persistentContainer?.deleteItem(self.diary)
                self.navigationController?.popViewController(animated: true)
            }
            
            deleteAlert.addAction(cancelAction)
            deleteAlert.addAction(deleteAction)
            
            self.present(deleteAlert, animated: true)
        }
        
        return deleteSheetAction
    }
}

extension DetailDiaryViewController {
    // MARK: - checkUserDeviceLocationServiceAuthorization()
    /// # 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 추가
    private func checkUserDeviceLocationServiceAuthorization() {
        
        // MARK: - 1. CLLocationManager.locationServicesEnabled()
        /// # 디바이스 자체에 위치 서비스가 활성화 상태인지 확인.
        ///
        /// CLLocationManager의 타입 메서드인 locationServiceEnabled()를 통해 활성화 상태 여부를 Bool값으로 반환받음.
        /// 만약 사용자 디바이스가 위치 서비스를 비활성화한 경우, 위치에 대한 권한 요청 자체가 불가하기 때문에 시스템 설정에 가서 사용자가 직접 설정값을 변경할 수 있도록 유도해야 함.
        guard CLLocationManager.locationServicesEnabled() else {
            // 시스템 설정으로 유도하는 얼럿
            showRequestLocationServiceAlert()
            return
        }
        
        // MARK: - 2. authoriztionStatus
        /// # 앱에 대한 권한 상태는 CLAuthorizationStatus라는 열거형 타입으로 표현됨.
        /// iOS 14를 기점으로 이를 확인할 수 있는 코드가 변경되었기 때문에 버전에 따른 분기 처리가 필요함.
        let authoriztionStatus: CLAuthorizationStatus
        
        // 앱의 권한 상태 가져오는 코드(iOS 버전에 따라 분기처리)
        /// # 사용자 디바이스의 위치가 활성화 상태일 경우, 앱에 대한 권한 상태를 확인해야함.
        if #available(iOS 14.0, *) {
            authoriztionStatus = locationManager.authorizationStatus
        } else {
            /// authorizationStatus() : deprecated in iOS 14.0
            authoriztionStatus = CLLocationManager.authorizationStatus()
        }
        
        // MARK: - checkUserCurrentLocationAuthorization
        /// 권한 상태값에 따라 분기처리를 수행하는 메서드 실행
        checkUserCurrentLocationAuthorization(authoriztionStatus)
    }
}

extension DetailDiaryViewController {
    // MARK: - checkUserCurrentLocationAuthorization(_:)
    private func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
        // MARK: - .notDetermined
        case .notDetermined:
            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
            
            // MARK: - desiredAccuracy
            /// 권한 요청을 보내기 전에 desiredAccuracy 설정 필요
            /// desiredAccuracy: 앱이 수신하려는 위치 데이터의 정확성.
            ///
            /// 위치 서비스는 요청된 정확도를 달성하기 위해 최선을 다함
            /// 그러나 앱은 덜 정확한 데이터를 사용할 준비가 되어 있어야 함.
            /// 앱이 정확한 위치 정보에 액세스 하도록 승인되지 않은 경우(isAuthorizedForPreciseLocation이 false) 이 속성 값을 변경해도 아무런 효과가 없음.
            /// 정확도는 항상 kCLLocationAccuracyReduced임.
            ///
            /// 앱이 배터리 수명에 미치는 영향을 줄이려면 이 속성에 용도에 적합한 값을 할당해야함.
            /// 예를 들어 1km 이내의 현재 위치만 필요한 경우 kCLLocationAccuracyKilometer를 지정.
            /// 더욱 정확한 위치 데이터도 제공되기 까지는 더 많은 시간이 걸림.
            ///
            /// 높은 정확도의 위치 데이터를 요청한 후에도 앱은 일정 기간 동안 정확도가 낮은 데이터를 계속 얻을 수 있음.
            /// 요청된 정확도 내에서 위치를 확인하는 데 걸리는 시간 동안 해당 데이터가 앱이 요청한 것만큼 정확하지 않더라도 위치 서비스는 사용가능한 데이터를 계속 제공함.
            /// 해당 데이터가 사용 가능해지면 앱에서 더 정확한 위치 데이터를 수신하게 됨.
            ///
            /// iOS의 경우 이 속성의 기본 값은 kCLLocationAccuracyBest임.
            /// macOS, watchOS, tvOS의 경우 기본값은 kCLLocationAccuracyHundredMeters임.
            ///
            /// 이 속성은 표준 위치 서비스에만 영향을 미치며 중요한 위치 변경 사항을 모니터링 하는 데에는 영향을 미치지 않음.
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // MARK: - requestWhenInUseAuthorization(),requestAlwaysAuthorization()
            /// 권한 요청 보내기.
            locationManager.requestWhenInUseAuthorization()
//            locationManager.requestAlwaysAuthorization()
        // MARK: - .denied, .restricted
        case .denied, .restricted:
            /// 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
            print("위치 서비스를 다시 켤 수 있도록 유도")
        // MARK: - .authorizedWhenInUse
        case .authorizedWhenInUse:
            // MARK: - requestLocation()
            /// 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태.
            /// manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
            ///
            /// # 사용자의 현재 위치를 가져오는 2가지 방법
            /// 1. requestLocation() : 한 번만 위치를 요청(가져옴)
            /// 2. startUpdatingLocation() : 현재 위치를 지속적으로 요청(가져옴)
            ///
            /// # 1,2의 차이점
            /// 한 번만 요청하여 가져오는지, 지속적으로 요청하는지에 있음
            ///
            /// startUpdatingLocation()을 실행하면 stopUpdatingLocation() 메서드를 통해 update를 중지하기 전까지 반복적으로 사용자의 위치를 가져옴(사용자의 위치가 변경시, 시간이 조금 지났을 경우, 등등)
            ///
            /// startUpdatingLocation()을 사용한 후, 더 이상 사용자의 위치를 받아올 필요가 없을 경우 stopUpdatingLocation()을 통해 불필요한 위치 업데이트는 멈춰주는 것이 좋음
            locationManager.requestLocation()
        // MARK: - .authorizedAlways
        case .authorizedAlways:
            // MARK: - requestLocation()
            /// 앱을 항상 허용
            /// 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태.
            /// manager 인스턴스를 사용하여 사용자의 위치를 가져온다.
            locationManager.requestLocation()
        // MARK: - @unknown default
        /// 스위치는 알려진 사례를 다루지만 'CLAuthorizationStatus'에는 알 수 없는 추가 값이 있을 수 있으며 향후 버전에 추가될 수 있습니다.
        /// 때문에 @unknown default를 사용합니다.
        @unknown default:
            fatalError("Unknown Error")
        }
    }
}

extension DetailDiaryViewController {
    private func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 이용",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 ➡️ 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        
        let moveToDeviceSetting = UIAlertAction(
            title: "설정으로 이동",
            style: .destructive
        ) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(moveToDeviceSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate Protocol 채택
extension DetailDiaryViewController: CLLocationManagerDelegate {
    // 사용자의 위치를 성공적으로 가져왔을 때 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 위치 정보를 배열로 입력받는데, 마지막 index값이 가장 정확하다고 함.
        if let coordinate = locations.last?.coordinate {
            print("위도: \(coordinate.latitude)")
            print("경도: \(coordinate.longitude)")
        }
    }
    
    // 사용자가 GPS 사용이 불가한 지역에 있는 등 위치 정보를 가져오지 못했을 때 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 이상)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }
    
    // 앱에 대한 권한 설정이 변경되면 호출 (iOS 14 미만)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 사용자 디바이스의 위치 서비스가 활성화 상태인지 확인하는 메서드 호출
        checkUserDeviceLocationServiceAuthorization()
    }
}
