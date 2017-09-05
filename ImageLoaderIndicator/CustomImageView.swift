/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
import UIKit

class CustomImageView: UIImageView {
  private let progressIndicatorView = CircularLoaderView(frame: .zero)
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let url = URL(string: "https://koenig-media.raywenderlich.com/uploads/2015/02/mac-glasses.jpeg")
    
    addSubview(progressIndicatorView)
    progressIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[v]|", options: .init(rawValue: 0),
      metrics: nil, views: ["v": progressIndicatorView]))
    addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[v]|", options: .init(rawValue: 0),
      metrics: nil, views:  ["v": progressIndicatorView]))
    
    sd_setImage(with: url, placeholderImage: nil, options: .cacheMemoryOnly, progress:
      { [weak progressIndicatorView] receivedSize, expectedSize, _ in
        progressIndicatorView?.progress = CGFloat(receivedSize)/CGFloat(expectedSize)
      }) { [weak progressIndicatorView] _, error, _, _ in
        if let error = error { print(error) }
        progressIndicatorView?.reveal()
    }
  }
  
}
