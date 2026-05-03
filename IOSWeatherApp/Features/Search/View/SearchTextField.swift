//
//  SearchTextField.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 02.05.2026.
//

import UIKit
import SnapKit

final class SearchTextField: UIView {
    
    var onTextChanged: ((String) -> Void)?
    
    private lazy var searchIcon: UIImageView = {
        $0.image = .search
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var textField: UITextField = {
        $0.placeholder = "Поиск города или аэропорта"
        $0.textColor = .gray
        $0.delegate = self
        return $0
    }(UITextField())
    
    private lazy var clearButton: UIButton = {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.tintColor = .white
        $0.isHidden = true
        $0.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        return $0
    }(UIButton())
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        
        [searchIcon, textField, clearButton].forEach{
            addSubview($0) }
            
            searchIcon.snp.makeConstraints{
                $0.leading.equalToSuperview().offset(16)
                $0.top.equalToSuperview().offset(12)
                $0.width.equalTo(20)
                $0.bottom.equalToSuperview().inset(12)
            }
            
            textField.snp.makeConstraints {
                $0.leading.equalTo(searchIcon.snp.trailing).offset(8)
                $0.centerY.equalToSuperview()
                $0.trailing.equalTo(clearButton.snp.leading).offset(-8)
            }
            
            clearButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(16)
                $0.height.width.equalTo(20)
                $0.centerY.equalToSuperview()
            }
    }
    
    @objc private func clearTapped(){
        textField.text = ""
        clearButton.isHidden = true
        onTextChanged?("")
    }
}


extension SearchTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        clearButton.isHidden = text.isEmpty
        onTextChanged?(text)
        return true
    }
}


