//
//  ChatInputAccessoryView.swift
//  protain
//
//  Created by 平田翔大 on 2021/02/03.
//

import UIKit


protocol ChatInputAccessoryViewDelegate: class {
    func tappedSendButton(text: String)
}

class ChatInputAccessoryView: UIView{
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!

    @IBOutlet weak var sendButton: UIButton!
    @IBAction func tappedSendButton(_ sender: Any) {
        let textwhite = chatTextView.text.trimmingCharacters(in: .newlines)
//        guard let text = chatTextView.text else { return } 最初はこっち
        delegate?.tappedSendButton(text: textwhite)
    }
    @IBAction func stampButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "stampCollection", bundle: nil)
        let sinkitoukou = storyboard.instantiateViewController(withIdentifier: "stampViewController")
        self.ChatRoomViewController()?.present(sinkitoukou, animated: true, completion: nil)
    }
    weak var delegate: ChatInputAccessoryViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibInit()
        setUpViews()
        autoresizingMask = .flexibleHeight
    }
    private func setUpViews() {
        chatTextView.layer.cornerRadius = 15
        chatTextView.layer.borderWidth = 1
        sendButton.layer.cornerRadius = 15
        sendButton.imageView?.contentMode = .scaleAspectFill
        sendButton.contentHorizontalAlignment = .fill
        sendButton.contentVerticalAlignment = .fill
        sendButton.isEnabled = false
        chatTextView.text = ""
        chatTextView.delegate = self
        chatTextView.font = UIFont(name: "System Semibold", size:  14.0)
        imageButton.addTarget(self, action: #selector(tappedImageButton), for: .touchUpInside)

    }
    
    
    @objc private func tappedImageButton() {
        let storyboard = UIStoryboard.init(name: "imagetoukou", bundle: nil)
        let imagetoukou = storyboard.instantiateViewController(withIdentifier: "imagetoukouViewController")
        self.ChatRoomViewController()?.present(imagetoukou, animated: true, completion: nil)
    }
    
    func removeText() {
        chatTextView.text = ""
        sendButton.isEnabled =  false
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    private func nibInit() {
        
        let nib = UINib(nibName: "ChatInputAccessoryView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth,]
        self.addSubview(view)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ChatInputAccessoryView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let textWhite = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)//空白、改行のみを防ぐ
        sendButton.tintColor = .green
        if textWhite.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}
