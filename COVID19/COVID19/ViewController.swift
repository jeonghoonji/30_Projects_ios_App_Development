//
//  ViewController.swift
//  COVID19
//
//  Created by 지정훈 on 2022/04/13.
//

import UIKit
import Charts
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.startAnimating()
        self.fetchCovidOverview(completionHandler: { [weak self] result in
            //일시적으로 self가 스트롱 래퍼런스로 만들어줌
            guard let self = self else {return}
            
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            
            switch result{
            case let .success(result):
                //debugPrint("success \(result)")
                self.configureStackView(koreaCovidOverView: result.korea)
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
                self.configureChatView(covidOverviewList: covidOverviewList)
            case let .failure(error):
                debugPrint("error \(error)")
            }
             
        })
        
    }
    
    //시도별 신규확진자 파이차트에 표시 메소드
    func makeCovidOverviewList(
        cityCovidOverview : CityCovidOverview )-> [CovidOverview]{
        return [
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.daegu,
            cityCovidOverview.incheon,
            cityCovidOverview.gwangju,
            cityCovidOverview.daejeon,
            cityCovidOverview.ulsan,
            cityCovidOverview.sejong,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.gangwon,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.jeonbuk,
            cityCovidOverview.jeonnam,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.jeju,
            
            
        ]
    }
    func configureChatView(covidOverviewList:[CovidOverview]){
        self.pieChartView.delegate = self
        //파이차트 데이터를 표시할려면 파이차트 데이터 엔트리 객체 추가해줘야함
        let entries = covidOverviewList.compactMap({ [weak self] overview -> PieChartDataEntry? in
            //일시적 강한 self
            guard let self = self else {return nil}
            
            return PieChartDataEntry(
                value: self.removeFormaString(string: overview.newCase),
                //도시이름
                label: overview.countryName,
                // 상세 데이터
                data: overview
                )
        })
        //
        let dataSet = PieChartDataSet(entries : entries, label:"코로나 발생현황")
        // 파이차트 꾸미는 부분
        // 1피트 간격 떨어지게
        dataSet.sliceSpace = 1
        // 품목이름이 블랙
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        //파이차트 다양한 색상 추가하는 부분
        dataSet.colors = ChartColorTemplates.vordiplom() +
        ChartColorTemplates.joyful()
        ChartColorTemplates.liberty()
        ChartColorTemplates.pastel()
        ChartColorTemplates.material()
        
        //
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        self.pieChartView.spin(duration: 0.3 ,fromAngle:self.pieChartView.rotationAngle, toAngle:
                                self.pieChartView.rotationAngle + 80 )
    }
    
    // 숫자 1,000,000 콤마 이런거 스트링 타입을 더블형으로 바꾸는 메소드
    func removeFormaString(string: String) -> Double{
        let formatter = NumberFormatter()
        // decimal이 먼지 알아내기
        formatter.numberStyle = .decimal
        //만약 nil이면 0이 되게
        return formatter.number(from: string)?.doubleValue ?? 0
    }
    
    
    //
    func configureStackView(koreaCovidOverView:CovidOverview){
        self.totalCaseLabel.text = "\(koreaCovidOverView.totalCase)명"
        self.newCaseLabel.text = "\(koreaCovidOverView.newCase)명"
        debugPrint("CovidDetailViewController - configureStackView called ")
    }
    // 메소드 정의
    func fetchCovidOverview(
        //성공이면 CityCovidOverview 실패면 Error 반환값은 void
        //Result<Value, Error>문법
        //@escaping클로저 네트워크쪽 작업은 비동기 작업이므로 이거를 많이 쓰는데 ???? 이건 다시 공부
        completionHandler: @escaping (Result<CityCovidOverview,Error> )->Void) {
        let url = "https://api.corona-19.kr/korea/country/new/?serviceKey="
        let param = [
            "serviceKey": "SxTBjcnrD8mofCZLzRNFYpvQJsXPEyOba"
        ]
        debugPrint("CovidDetailViewController - fetchCovidOverview called ")
        //Alamofire를 이용  method - .get방식   parameters- param 딕셔너리 형태로 전달하면 알아서 전달함
        AF.request(url, method: .get, parameters: param)
            //응답데이터를 받을수있는 메소드 체이닝
            //completionHandler클로저를 정의를 해주면 응답 데이터가 클로저 파라미터로 전달됨
            
          .responseData(completionHandler: { response in
                switch response.result{
                case let .success(data):
                    do{
                        //매핑되게
                        let decoder = JSONDecoder()
                        
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        completionHandler(.success(result))
                    }catch{
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                    
                }
            })
    }
}

extension ViewController:ChartViewDelegate{
    //차트에서 항목을 선택했을때 호출이 되는 메소드
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        // 내 생각에는 디테일 화면으로 넘어가는
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(
            identifier: "CovidDetailViewController") as? CovidDetailViewController else {return}
        //
        guard let covidOverview = entry.data as? CovidOverview else {return}
        covidDetailViewController.covidOverview = covidOverview
        // 모든 내용을 담고 전달
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
}

