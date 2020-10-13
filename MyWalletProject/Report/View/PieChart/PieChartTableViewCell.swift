import UIKit

protocol CustomCollectionCellDelegate:class {
    func collectionView(collectioncell:PieChartCollectionViewCell?, didTappedInTableview TableCell:PieChartTableViewCell, indexPath: IndexPath)
}

class PieChartTableViewCell: BaseTBCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var sumIncome = 0
    var sumExpense = 0
    var sumByCategoryIncome = [SumByCate]()
    var sumByCategoryExpense = [SumByCate]()
    weak var delegate: CustomCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        PieChartCollectionViewCell.registerCellByNib(collectionView)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func setupDataTB(info: SumForPieChart) {
        self.sumIncome = info.sumIncome
        self.sumExpense = info.sumExpense
        self.sumByCategoryIncome = info.sumByCateIncome
        self.sumByCategoryExpense = info.sumByCateExpense
        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension PieChartTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PieChartCollectionViewCell.loadCell(collectionView, path: indexPath) as! PieChartCollectionViewCell
        cell.setupDataCL(info: SumForPieChart(sumIncome: sumIncome, sumExpense: sumExpense, sumByCateIncome: sumByCategoryIncome, sumByCateExpense: sumByCategoryExpense))
        if indexPath.row == 0 {
            cell.state = .income
            cell.setupLabel(Constants.income, .blue)
        } else {
            cell.setupLabel(Constants.expense, .red)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = PieChartCollectionViewCell.loadCell(collectionView, path: indexPath) as! PieChartCollectionViewCell
        self.delegate?.collectionView(collectioncell: cell, didTappedInTableview: self, indexPath: indexPath)
    }
}
