//
//  LinguisticTaggerViewController.swift
//  CoreMLResearching
//
//  Created by Guanyi on 2018/1/15.
//  Copyright © 2018年 yiguan. All rights reserved.
//

import UIKit

class LinguisticTaggerViewController
: UIViewController
, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.delegate = self
            textView.text = "The American Red Cross was established in Washington, D.C., by Clara Barton."
        }
    }
    @IBOutlet weak var label: UILabel!
    @IBAction func classify(_ sender: UIButton) {
        let text = textView.text ?? ""
        let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
        tagger.string = text
        let range = NSRange(location:0, length: text.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
        var contents = [String]()
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
            if let tag = tag, tags.contains(tag) {
                let name = (text as NSString).substring(with: tokenRange)
                contents.append("\(name): \(tag.rawValue)")
                print("\(name): \(tag.rawValue)")
            }
        }
        
        label.text = contents.joined(separator: "\n")
    }
}
