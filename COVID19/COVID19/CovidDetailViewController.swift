//
//  CovidDetailViewController.swift
//  COVID19
//
//  Created by 지정훈 on 2022/04/13.
//

import UIKit

class CovidDetailViewController: UITableViewController {

    // 신규 확진자
    @IBOutlet weak var newCaseCell: UITableViewCell!
    // 확진자
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    // 완치자
    @IBOutlet weak var recoveredCell: UITableViewCell!
    // 사망자
    @IBOutlet weak var deathCell: UITableViewCell!
    // 발생률
    @IBOutlet weak var percenttageCell: UITableViewCell!
    // 해외 유입 신규 확진자
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    // 지역 발생 신규 확진자
    @IBOutlet weak var regionalOutbreakCell: UITableViewCell!
    
    
    var covidOverview : CovidOverview?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        debugPrint("CovidDetailViewController - viewDidLoad called ")
    }
    
    func configureView(){
        guard let covidOverview = self.covidOverview else {return}
        //네이케이션바에 지역이름 표시되게
        self.title = covidOverview.countryName
        //신규확진자 표현
        self.newCaseCell.detailTextLabel?.text = "\(covidOverview.newCase)명"
        self.totalCaseCell.detailTextLabel?.text = "\(covidOverview.totalCase)명"
        self.recoveredCell.detailTextLabel?.text = "\(covidOverview.recovered)명"
        self.deathCell.detailTextLabel?.text = "\(covidOverview.death)명"
        self.percenttageCell.detailTextLabel?.text = " \(covidOverview.percentage)%"
        //해외 유입 신규 확진자
        self.overseasInflowCell.detailTextLabel?.text = " \(covidOverview.newFcase)명"
        self.regionalOutbreakCell.detailTextLabel?.text = " \(covidOverview.newCcase)명"
        debugPrint("CovidDetailViewController - configureView() called ")
    }
   
    
}
