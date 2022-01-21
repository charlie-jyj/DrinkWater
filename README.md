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
    - request의 실제 발송을 담당하는 객체
    - 등록된 알림 내용을 확인하고 정해진 시각에 발송하는 역할
    - 싱글턴 방식으로 동작
        - current() 메소드를 통해 참조 정보만 가져온다
    

### 3) 새롭게 알게 된 것
