//
//  GongjiCellTableViewCell.swift
//  2021SWhackathon_KNUCSE
//
//  Created by 서경섭 on 2021/07/23.
//

import UIKit
import SnapKit

class GongjiCellTableViewCell: UITableViewCell {

    var ContentView: UILabel!
    var MoveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.accessoryType = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        ContentView = UILabel()
        MoveButton = UIButton()
        
        self.addView()
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView(){
        self.contentView.addSubview(ContentView)
        self.contentView.addSubview(MoveButton)
    }
    
    func makeConstraints(){
        
        ContentView.snp.makeConstraints{ make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        MoveButton.setTitle("이동하기", for: .normal)
        MoveButton.setTitleColor(.black, for: .normal)
        MoveButton.snp.makeConstraints{ make in
             make.top.bottom.equalToSuperview()
            make.left.equalTo(self.ContentView.snp.right)
            make.right.equalToSuperview()
        }
    }
    
}
