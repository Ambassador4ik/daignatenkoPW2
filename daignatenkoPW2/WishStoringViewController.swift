//
//  WishStoringViewController.swift
//  daignatenkoPW2
//
//  Created by Dmitriy Ignatenko on 11/11/23.
//

import UIKit

private struct Constants {
    static let tableCornerRadius: CGFloat = 10
    static let tableOffset: CGFloat = 10
    static let numberOfSections: Int = 2
}

final class WishStoringViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .blue
        configureTable()
    }
    
    
    private let table: UITableView = UITableView(frame: .zero)
    
    private func configureTable() {
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .red
        table.dataSource = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.tableOffset),
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: Constants.tableOffset),
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -Constants.tableOffset),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.tableOffset)
        ])
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
    }
    
    
    private var wishArray: [String] = []
    
    private let defaults = UserDefaults.standard
    
    private func loadWishesFromDefaults() {
        if let storedWishes = defaults.object(forKey: "wishesKey") as? [String] {
            wishArray = storedWishes
        }
    }
    
    private func saveWishesToDefaults() {
        defaults.set(wishArray, forKey: "wishesKey")
    }
}
// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1 // This is for the AddWishCell
            case 1:
                return wishArray.count // This is for the WrittenWishCell
            default:
                return 0
            }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // AddWishCell section
                    let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath) as! AddWishCell
                    cell.addWish = { [weak self] wish in
                        guard let self = self, !wish.isEmpty else { return }
                        wishArray.append(wish)
                        self.saveWishesToDefaults()
                        tableView.reloadData()
                    }
                    return cell

        case 1: // WrittenWishCell section
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath) as! WrittenWishCell
            cell.configure(with: wishArray[indexPath.row])
            return cell

        default:
            fatalError("Unexpected section: \(indexPath.section)")
        }
    }
}

class AddWishCell: UITableViewCell {
    static let reuseId = "AddWishCellReuseID"
    
    // UITextView to input the wish.
    private let textView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = Constants.tableCornerRadius
        textView.isUserInteractionEnabled = true
        return textView
    }()
    
    // UIButton to add the wish.
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Wish", for: .normal)
        return button
    }()
    
    // Closure to handle adding the wish.
    var addWish: ((String) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Adding UITextView and UIButton to the view hierarchy.
        [textView, addButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // AutoLayout constraints for the UITextView.
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        // AutoLayout constraints for the UIButton.
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        // Button action
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    // Method called when the addButton is tapped.
    @objc private func addButtonTapped() {
        if let wish = textView.text, !wish.isEmpty {
            addWish?(wish)
            textView.text = "" // Clear the textView after submitting the wish
        }
    }
}
