# 일기장[STEP2]

> 📌 화면에 제목, 작성일자, 한줄 미리보기가 보여지는 일기장 앱입니다.

> **핵심 개념**
UITextView, UITableView, DateFormatter, NotificationCenter, CoreData, UISwipeActionsConfiguration, UIActivityViewController

## 📚 목차</br>
- [팀원소개](#-팀원-소개)
- [파일트리](#-파일트리)
- [시각화된 프로젝트 구조](#시각화된-프로젝트-구조)
- [타임라인](#-타임라인)
- [실행화면](#-실행화면)
- [트러블 슈팅](#-트러블-슈팅)
- [참고자료](#-참고자료)

## 🧑‍💻 팀원 소개</br>
| <img src="https://github.com/devKobe24/images/blob/main/%E1%84%86%E1%85%AE%E1%86%AB.jpeg?raw=true" width="200" height="200"/> | <img src="https://github.com/devKobe24/BranchTest/blob/main/IMG_5424.JPG?raw=true" width="200" height="200"/> |
| :-: | :-: |
| [**Moon(문)**](https://github.com/hojun-jo) | [**Kobe(코비)**](https://github.com/devKobe24) |

## 🗂️ 파일트리</br>
```
.
├── Diary
│   ├── Model
│   │   ├── DiaryDateFormatter.swift
│   │   └── Protocol
│   │       └── IdentifierGenerator.swift
│   ├── View
│   │   ├── Base.lproj
│   │   │   └── LaunchScreen.storyboard
│   │   └── DiaryTableViewCell.swift
│   ├── Controller
│   │   ├── DetailDiaryViewController.swift
│   │   └── DiaryMainViewController.swift
│   ├── Application
│   │   ├── AppDelegate.swift
│   │   ├── DiaryPersistentContainer.swift
│   │   └── SceneDelegate.swift
│   ├── Extension
│   │   ├── Array+.swift
│   │   └── UITableViewCell+.swift
│   └──Resource
│       └── Assets.xcassets
│           ├── AccentColor.colorset
│           │   └── Contents.json
│           ├── AppIcon.appiconset
│           │   └── Contents.json
│           └── Contents.json
└── README.md
```

## 🗺️ 시각화된 프로젝트 구조</br>
<img src = "https://github.com/devKobe24/images/blob/main/Diary%5BSTEP2%5DUML.png?raw=true">

## ⏰ 타임라인</br>
프로젝트 진행 기간 | 23.08.29.(화) ~ 23.09.15.(금)

| 날짜 | 진행 사항 |
| -------- | -------- |
| 23.08.29.(화)     |  SwiftLint 적용.<br/>테이블 뷰 생성, Autolayout 적용.<br/>DiaryTableViewCell 생성 및 구현.<br/>UITableViewCell Extension 구현.<br/>Main.storyboard 삭제.<br/>DiaryTableViewCell UI 수정<br/>네비게이션 아이템 추가<br/>DateFormatter extension 구현|
| 23.08.30.(수)     | Diary DTO 생성<br/>DecodeError 생성 및 구현<br/>샘플 에셋 추가<br/>샘플 데이터 디코딩<br/>NSAttributedString 반환 함수 수정<br/>fetchDate 함수 생성 및 구현.<br/>formatCreatedAt 함수 생성 및 구현.<br/>DiaryDateFormatter 생성 및 구현
| 23.08.31.(목)     | DateFormatter, UITextView 개념 학습<br/>
| 23.09.01(금)     | 일기장 [STEP1-1] README 작성.<br/>
| 23.09.02(토)     | DetailDiaryViewController 생성<br>TextView 구현.<br/>TextViewDelegate 설정<br>keyboardDismissMode 설정
| 23.09.06(수)     | TextView keyboardDismissMode 옵션 추가<br>추상화 레벨 통일<br>접근제한자 수정<br>Array extension 생성 및 subscript 구현<br>index 접근을 safe subscript로 수정<br>iOS 15 버전을 기준으로 diaryTextView layout constraints 분기 처리.<br/>
| 23.09.08(금)     | 일기장 [STEP1] README 작성.<br/>
| 23.09.09(토)     | 프로젝트 관련 회의 및 개념 학습.<br/>
| 23.09.10(일)     | tableView(_ :, didSelectRowAt:) 생성 및 화면 변경 로직 구현.<br>tableView(_ :, trailingSwipeActionsConfigurationForRowAt: ) 생성 및 스와이프 삭제 기능 구현.<br>ableView(_ :, trailingSwipeActionsConfigurationForRowAt: )함수 내부 스와이프 share 기능 구현.<br><br/>
| 23.09.11(월)     | 프로젝트 관련 회의 및 개념 학습.<br/>
| 23.09.12(화)     | core data 에러 수정 및 leftBarButtonItem을 backBarButtonItem으로 변경<br/>
| 23.09.13(수)     | 프로젝트 관련 회의 및 개념 학습.<br/>
| 23.09.14(목)     | 프로젝트 관련 회의 및 개념 학습.<br/>
| 23.09.15(금)     |  이전 화면으로 전환 시 데이터가 바로 저장되지 않던 오류 수정<br>일기장 [STEP2] README 작성.<br/>


## 📺 실행화면</br>
- STEP1 일기장 시뮬레이터 실행화면 🎬 </br>
<img src = "https://github.com/devKobe24/images/blob/main/%E1%84%8B%E1%85%B5%E1%86%AF%E1%84%80%E1%85%B5%E1%84%8C%E1%85%A1%E1%86%BCstep2-g.gif?raw=true">

## 🔨 트러블 슈팅 
### 1️⃣ **StackView 내부에서 Label의 Height가 잡히지 않는 현상.**</br>
### 🔒 **문제점** 🔒</br>

**🚨 StackView 내부에서 Label의 Height가 잡히지 않는 현상이 있었습니다.</br>height is ambiguous for UILabel 경고가 생겨 트러블 슈팅을 진행하게 되었습니다.**</br>

### 🔑 **해결방법** 🔑</br>
**🙋‍♂️ diaryTitle과 dateAndPreview의 content hugging priority 가 같아 생기는 현상이였습니다.</br>따라서 diaryTitle에 .defaultHigh + 1 값을 주었고, dateAndPreview에는 .defaultHigh값을 주어 각각 다른 content hugging priority값을 주어 해결하였습니다.**

```swift
import UIKit

class DiaryTableViewCell: UITableViewCell {
    private let diaryTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        
        return label
    }()
    
    private let dateAndPreview: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
}
```

### 2️⃣ **NSAttributedString이 적용되지 않는 현상.** </br>
### 🔒 **문제점** 🔒</br>
**🚨 [__NSCFConstantString renderingMode]: unrecognized selector sent to instance 0x10aa5a2e8 에러가 발생했습니다.
원인은 NSAttributedString.Key.font에 필요한 타입이 UIFont였으나 UIFont.TextStyle을 사용 중이었습니다.**

```swift
private func convertAttributedString(text: String, font: UIFont.TextStyle) -> NSAttributedString {
    let attributes = [NSAttributedString.Key.font: font as Any] as [NSAttributedString.Key : Any]
    let attributedString = NSAttributedString(string: text, attributes: attributes)

    return attributedString
}
```

### 🔑 **해결방법** 🔑</br>
🙋‍♂️**NSAttributedString.Key.font에 UIFont 타입으로 전달하여 해결했습니다.**</br>

```swift
private func convertAttributedString(text: String, font: UIFont) -> NSAttributedString {
    let attributes = [NSAttributedString.Key.font: font as Any] as [NSAttributedString.Key : Any]
    let attributedString = NSAttributedString(string: text, attributes: attributes)

    return attributedString
}
```

### 3️⃣ NSAttributedString의 가운데 정렬
### 🔒 **문제점** 🔒</br>
**🚨 문자열 자체의 모양이 아래 이미지와 같기 때문에 UILabel의 baselineAdjustment로 가운데 정렬을 맞출 수 없었습니다.**
<img src = "https://github.com/devKobe24/images/blob/main/NSAttributedString%E1%84%86%E1%85%AE%E1%86%AB%E1%84%8C%E1%85%A6%E1%84%8C%E1%85%A5%E1%86%B7.png?raw=true"></br>

### 🔑 **해결방법** 🔑</br>
**🙋‍♂️NSAttributedString.Key.baselineOffset을 이용해 작은 문자 부분의 baseline을 올리는 것으로 해결했습니다.**</br>
<img src = "https://github.com/devKobe24/images/blob/main/NSAttributedString%E1%84%92%E1%85%A2%E1%84%80%E1%85%A7%E1%86%AF%E1%84%8C%E1%85%A5%E1%86%B7.png?raw=true"></br>

```swift
private func attributedDateAndPreview(data: Diary, font: UIFont) -> NSMutableAttributedString {
    let text = "\(formatCreatedAt(data.createdAt)) \(data.body)"
    let attributedString = NSMutableAttributedString(string: text)
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .baselineOffset: 2
    ]

    attributedString.addAttributes(attributes, range: (text as NSString).range(of: data.body))

    return attributedString
}
```
### 4️⃣ **텍스트를 길게 작성시 키보드에 가리는 문제 발생.**
### 🔒 **문제점** 🔒</br>
**🚨 텍스트가 길어짐에 따라 키보드 상단에 가려져 의도적으로 키보드를 내리거나 유저가 스크롤를 하여 텍스트를 봐야하는 문제가 생겼습니다.**

### 🔑 **해결방법** 🔑</br>
**🙋‍♂️ 노티피케이션 센터를 활용하였습니다. 그 중 `UIResponder.keyboardWillHideNotification`와 `UIResponder.keyboardWillShowNotification`를 이용하여 문제를 해결하였습니다. 해결한 코드는 아래와 같습니다.**</br>

```swift
extension DetailDiaryViewController {
    private func setupKeyboardEvent() {
        if #unavailable(iOS 15.0) {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillShow),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillHide),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[
                  UIResponder.keyboardFrameEndUserInfoKey
              ] as? CGRect
        else {    
            return
        }
        
        diaryTextView.contentInset = UIEdgeInsets(
            top: .zero,
            left: .zero,
            bottom: keyboardFrame.height,
            right: .zero
        )
    }
    
    @objc private func keyboardWillHide() {
        diaryTextView.contentInset = UIEdgeInsets()
    }
}
```

### 5️⃣ **일기의 맨 첫 줄은 일기의 제목이 되고, 그 다음 줄부터 본문이 되는 로직.**
### 🔒 **문제점** 🔒</br>
**🚨 일기의 맨 첫 줄은 일기의 제목이 되게 하고, 그 다음 줄부터 본문이 되도록 하는 로직을 만드는 부분에서 텍스트 뷰의 첫 번째 줄과 그 다음 줄을 어떤 기준으로 나누어야 하는지 알 수 없어 문제가 되었습니다.**

### 🔑 **해결방법** 🔑</br>
**🙋‍♂️텍스트 뷰의 맨 첫 줄은 일기의 제목이 되고, 그 다음 줄부터 본문이 되도록 하는 로직에 대하여 많은 고민을 하게 되었습니다.</br>split(separator:), 배열, dropFirst(_:)를 활용하여 로직을 만들었습니다. 그래서 텍스트 뷰의 텍스트에 "\n" 줄바꿈을 기준으로 String.SubSequence 배열을 만들고 그 배열의 index 0번째를 일기의 제목으로 만들고, dropFirst(제목.count)를 활용하여 제목 count 이상은 본문으로 만드는 것으로 해결하였습니다.**</br>

```swift
let splitedText = diaryTextView.text.split(separator: "\n")
let title = String(splitedText[safe: 0] ?? .init())
let body = String(diaryTextView.text.dropFirst(title.count))
```

### 6️⃣ **백그라운드 진입 시 데이터 저장.**
### 🔒 **문제점** 🔒</br>
**🚨 컨텍스트만 저장할 경우 일기에서 수정 중인 내용이 반영되지 않았습니다.
윈도우를 통해 뷰 컨트롤러를 가져와 저장하는 작업이 필요할 듯하여 다음과 같이 시도 했으나 실패했습니다.**</br>

```swift
func sceneDidEnterBackground(_ scene: UIScene) {
    guard let diaryViewController = window?.rootViewController?.navigationController?.topViewController as? DetailDiaryViewController else {
        return
    }

    diaryViewController.saveDiaryData()

//        persistentContainer?.saveContext()
}
```

### 🔑 **해결방법** 🔑</br>
**🙋‍♂️ 루트 뷰 컨트롤러가 네비게이션 컨트롤러였기 때문에 아래와 같이 수정하였습니다.**</br>

```swift
func sceneDidEnterBackground(_ scene: UIScene) {
    guard let navigationController = window?.rootViewController as? UINavigationController,
          let diaryViewController = navigationController.topViewController as? DetailDiaryViewController else {
        return
    }

    diaryViewController.saveDiaryData()
}
```

### 7️⃣ **이전 화면으로 전화 시 데이터 저장.**
### 🔒 **문제점** 🔒</br>
**🚨 backBarButtonItem을 이용해 이전 화면으로 전환할 경우 UIBarButtonItem의 action으로 진입하지 않는 현상이 발생했습니다. 이로 인해 데이터를 바로 저장하지 못 하는 상황이 일어났습니다.**</br>

```swift
private func configureNavigationItem(date: Date = Date()) {
    ...
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "일기장", style: .plain, target: self, action: #selector(didTapBackToMainButton))
    ...
}

@objc private func didTapBackToMainButton() {
    saveDiaryData()
    navigationController?.popViewController(animated: true)
}
```

### 🔑 **해결방법** 🔑</br>
**🙋‍♂️ viewWillDisappear에서 데이터를 저장하도록 하여 화면 전환 시 항상 데이터를 저장할 수 있도록 하였습니다.**</br>

```swift
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    saveDiaryData()
}
```

## 📑 참고자료
- [📃 Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/layout)
- [📃 UIKit: Apps for Every Size and Shape](https://www.wwdcnotes.com/notes/wwdc18/235/)
- [🎥 Making apps adaptive part 1](https://www.youtube.com/watch?v=hLkqt2g-450)
- [🎥 Making apps adaptive part 2](https://www.youtube.com/watch?v=s3utpBiRbB0)
- [📃 DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter)
- [📃 UITextView](https://developer.apple.com/documentation/uikit/uitextview)
- [📃 NotificationCenter](https://developer.apple.com/documentation/foundation/notificationcenter)
- [📃 UIResponder](https://developer.apple.com/documentation/uikit/uiresponder)
- [📃 contentInset](https://developer.apple.com/documentation/uikit/uiscrollview/1619406-contentinset)
- [😺 SwiftLint](https://github.com/realm/SwiftLint)
- [📃 Core Data](https://developer.apple.com/documentation/coredata)
- [🎥 Making Apps with Core Data](https://developer.apple.com/videos/play/wwdc2019/230/)
- [📃 UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
- [📃 UISwipeActionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
