//
//  ViewController.swift
//  Diary
//
//  Created by 지정훈 on 2022/04/08.
//

import UIKit

class ViewController: UIViewController {

    //colletctionView 콜렉션뷰 전체
    @IBOutlet var collectionView: UICollectionView!
    
    // 이부분은 모르겠음
    // 프로퍼티 옵저버로 만듬
    private var diaryList = [Diary](){
        // didset될때 saveDiaryList호출
        // 다이어리 리스트 배열에 일기가 추가되거나 변경이 일어날때 마다 userDefaults에 저장된다
        didSet{
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 메소드 호출
        self.configureCollectionView()
        self.loadDiaryList()
        //빡셈
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil)
    }
    @objc func starDiaryNotification(_ notification: Notification){
        guard let starDiary = notification.object as? [String:Any]  else{return}
        guard let isStar = starDiary["isStar"] as? Bool else {return}
        guard let indexPath = starDiary["indexPath"] as? IndexPath else {return}
        self.diaryList[indexPath.row].isStar = isStar 
    }
    //빡셈
    @objc func editDiaryNotification(_ notification:Notification){
        guard let diary = notification.object as? Diary else {return}
        guard let row =  notification.userInfo?["indexPath.row"] as? Int else {return}
        self.diaryList[row] = diary
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionView.reloadData()
    }
    //  세그웨이를 통해 이동하기 때문에 propare 메소드 오버라이드 함
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let wireDiaryViewController = segue.destination as? WriteDiaryViewController {
            //델리게이트 위임
            wireDiaryViewController.delegate = self
        }
    }
    
    // 코드로 콜렉션 뷰 레이아웃 구성 단계
    private func configureCollectionView(){
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10  )
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    //  date 타입 전달받으면 포맷
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    
    // 앱이 껏다 켜져도 데이터 사라지지 않게 구현
    private func saveDiaryList(){
        // 일기들을 userDefaults 딕셔너리 형태로 저장  map핑 시킴
        let date = self.diaryList.map{
            [
                "title": $0.title,
                "contents":$0.contents,
                "date":$0.date,
                "isStar":$0.isStar
            ]
        }
        //상수 선언
        let userDefaults = UserDefaults.standard
        // 이부분 메소드 확인해봐야할듯.  -> date값이 무엇인지?
        userDefaults.set(date, forKey: "diaryList")
    }
    
    // userDefaults 저장된 값을 불러오는 메소드 구현
    private func loadDiaryList(){
        
        let userDefaults = UserDefaults.standard
        //object메소드는 anytype으로 리턴 되기때문에 딕셔너리 배열 형태로 타입캐스팅    타입캐스팅이 실패하면 nil될수있기때문에 guard문으로 옵셔널 바인딩
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String:Any]] else { return }
        self.diaryList = data.compactMap{
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else {return nil }
            guard let date = $0["date"] as? Date else {return nil}
            guard let isStar = $0["isStar"] as? Bool else {return nil}
            // diary타입이 되게 !!!인스턴스화 진행
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }
        // 날짜가 최신순으로 정렬
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    
}



// 채택 콜렉션 뷰에서 데이터 소스는 콜렉션뷰에서 보여주는 컨텐츠를 관리하는 객체
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //diarylist 갯수만큼 뷰 보여짐
        return self.diaryList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //as? 다운 캐스팅 else 빈 콜렉션 뷰셀 보여준다????
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else {return
            UICollectionViewCell()
        }
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

// 표시할 셀의 사이즈를 지정하는 부분
extension ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
    }
}

//WriteDiaryViewDelegate 델리게이트 채택
extension ViewController: WriteDiaryViewDelegate {
    
    func didSelectReigster(diary: Diary) {
        // 일기가 등록 부분
        self.diaryList.append(diary)
        // 날짜가 최신 순으로 정렬
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        // 일기를 추가할떄 마다 추가한다???
        self.collectionView.reloadData()
    }
} 

//delegate선언?    didSelectItemAt 특정 셀이 선택 되었음을 알리는 구문 여기서 DiaryDetailViewController
// 각 일기장 내용을 선택하면 일기의 상세 화면으로 들어감 
extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewcontroller = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        viewcontroller.diary = diary
        viewcontroller.indexPath=indexPath
        //?????
        viewcontroller.delegate = self
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
}

extension ViewController:DiaryDetailViewDelegate{
    //func didSelectDelete(indexPath: IndexPath) {
         //self.diaryList.remove(at: indexPath.row)
        //self.collectionView.deleteItems(at: [indexPath])
    //}
    //func didSelectStar(indexPath: IndexPath, isStar: Bool) {
        //self.diaryList[indexPath.row].isStar = isStar
    //}
}
