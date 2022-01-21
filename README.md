## 물마시기 알람 앱 만들기

###  1) 구현 기능
- 시간 알람 설정
- 알림 기능

### 2) 기본 개념

#### UNNotificationRequest
- identifier (uuid)
- UNMutableNotificationContent
- Trigger
    - UNCalendarNotificationTrigger
    - UNTimeIntervalNotificationTrigger
    - UNLocationNotificationTrigger

#### UNNotificationCenter
    - request의 실제 발송을담당하는 객체
    - 등록된 알림 내용을 확인하고 정해진 시각에 발송하는 역할
    - 싱글톤 방식으로 동작
        - current() 메소드를 통해 참조 정보만 가져온다
        - AppDelegate의 didFinishLaunchingWithOptions 메소드 내에서 구현

##### 종류
UNNotificationPresentationOptions
    - badge
    - banner
    - list
    - sound

##### Delegate Method
    - willPresent notification
    - didReceive response

##### 사용자 승인
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        let notiCenter = UNUserNotificationCenter.current()
        notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) {
            (didAllow, e) in
        } 
               
        return true
    }
```

##### content
```swift
 let content = UNMutableNotificationContent()
        content.title = "물 마실 시간이에요💦"
        content.body = "세계보건기구(WHO)가 권장하는 하루 물 섭취량은 1.5-2리터 입니다."
        content.sound = .default
        content.badge = 1
```

##### trigger
```swift
let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
```

##### Notification Center 
```swift
 self.add(request)

```
?? .current는 어디가고 self에서 바로 add를 하죠?
싱글톤이라서 가능한 일이라고 생각.

##### remove
```swift
 userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [self.alerts[indexPath.row].id])
```

?? Extension 을 쓴 이유가??
```swift
extension UNUserNotificationCenter {
    func addNotificationRequest(by alert: Alert) {
```
Add notification을 재사용하기 좋다


### 3) 새롭게 알게 된 것

- tableview register custom table cell
1. Cocoa touch class file + xib 생성
2. Xib 디자인 
3. TableviewController viewDidLoad 에서 register
    - UINib 생성 
    - 등록

- 페이지 내의 변수 이름 한 번에 수정하기 단축키
Control + command + E

- cellForRowAt
    - self.tableView.dequeueReusableCell
    - prop 접근을 위해 guard 문 안에서 casting 

- add button
    - segueway 로 이어주기 보다는
    - 이전 뷰로 값을 전달하기 위해 코드로 연결

- save 구현
    - clousure
    - delegate pattern 을 protocol을 사용하지 않고 closure로만 구현한 것
    - LED 예제 (protocol delegate), Diary(Notification Center) 와 비교

```swift
// VC1
@IBAction func addAlertButtonAction(_ sender: Any) {
        guard let addAlertVC = self.storyboard?.instantiateViewController(identifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        // closure 구현
        addAlertVC.pickedDate = {
            [weak self] date in
            guard let self = self else { return }
            var alertList = self.alertList()
            let newAlert = Alert(date: date, isOn: true)
            alertList.append(newAlert)
            alertList.sort(by: {$0.date.compare($1.date) == .orderedAscending})
            self.alerts = alertList
            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            self.tableView.reloadData()
            
        }
        
        self.present(addAlertVC, animated: true, completion: nil)
    }


// VC2 (child)
 var pickedDate: ((_ date: Date) -> Void)?  // type을 closure로 선언
@IBAction func saveButtonTapped(_ sender: Any) {
        // present 될 때 initialize(정의)된 closure를 실행한다.
        self.pickedDate?(self.datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }

```
The presenting view controller is responsible for dismissing the view controller it presented.
If you call this method on the presented view controller itself,
UIKit asks the presenting view controller to handle the dismissal.

If you want to retain a reference to the view controller’s presented view controller,
Get the value in the presentedViewController property before calling this method


- UserDefaults 는 custom 한 구조체를 이해하지 못한다 (제한적인 타입만 이해함)
    - ProperyListDecoder() 사용
        - JSONDecoder 와 유사하게 동작한다.
    - basic 예제에서는 casting을 [[String:Any]] 한 후에 data.compactMap 을 사용해서 decode 
        - type이 Dictionary를 담은 Array 형태이기 때문에 가능했던 듯 

```swift
guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return [] }
```

- try try?, try!
    - try : do, catch 와 함께
    - try? 

- UISwitch tag
    - tag 는 UIView 라면 모두 가지는 Instance Property
    - An integer that you can use to identify view objects in your application
    - tapped 되는 UISwitch 를 특정하기 위해 tag 값에 indexPath.row 값을 담았고
    - 이를 userDefaults에 저장했기 때문에 app을 껐다 켜도 값이 반영될 것

- SceneDelegate
```swift
func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        UIApplication.shared.applicationIconBadgeNumber = 0
```


