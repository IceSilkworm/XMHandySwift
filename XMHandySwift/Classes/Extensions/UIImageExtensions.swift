//
//  UIImageExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 15/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

extension UIImage {
    
    /// EZSE: Returns base64 string
    public var base64: String {
        return self.jpegData(compressionQuality: 1.0)!.base64EncodedString()
    }
    
    /// EZSE: Returns compressed image to rate from 0 to 1
    public func compressImage(rate: CGFloat) -> Data? {
        return self.jpegData(compressionQuality: rate)
    }

    /// EZSE: Returns Image size in Bytes
    public func getSizeAsBytes() -> Int {
        return self.jpegData(compressionQuality: 1)?.count ?? 0
    }

    /// EZSE: Returns Image size in Kylobites
    public func getSizeAsKilobytes() -> Int {
        let sizeAsBytes = getSizeAsBytes()
        return sizeAsBytes != 0 ? sizeAsBytes / 1024 : 0
    }

    /// EZSE: scales image
    public class func scaleTo(image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
        let newSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    /// EZSE Returns resized image with width. Might return low quality
    public func resizeWithWidth(_ width: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }

    /// EZSE Returns resized image with height. Might return low quality
    public func resizeWithHeight(_ height: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: aspectWidthForHeight(height), height: height)

        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }

    /// EZSE:
    public func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }

    /// EZSE:
    public func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }

    /// EZSE: Returns cropped image from CGRect
    public func croppedImage(_ bound: CGRect) -> UIImage? {
        guard self.size.width > bound.origin.x else {
            print("EZSE: Your cropping X coordinate is larger than the image width")
            return nil
        }
        guard self.size.height > bound.origin.y else {
            print("EZSE: Your cropping Y coordinate is larger than the image height")
            return nil
        }
        let scaledBounds: CGRect = CGRect(x: bound.x * self.scale, y: bound.y * self.scale, width: bound.w * self.scale, height: bound.h * self.scale)
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        let croppedImage: UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImage.Orientation.up)
        return croppedImage
    }

    /// EZSE: Use current image for pattern of color
    public func withColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context?.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()

        return newImage
    }

    ///EZSE: Returns the image associated with the URL
    public convenience init?(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.init(data: Data())
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            print("EZSE: No image in URL \(urlString)")
            self.init(data: Data())
            return
        }
        self.init(data: data)
    }

    ///EZSE: Returns an empty image //TODO: Add to readme
    public class func blankImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    ///  使图片压缩后刚好小于指定大小
    ///
    ///  - Parameter image: 当前要压缩的图 maxLength 压缩后的大小
    ///
    ///  - Returns: 图片对象
    //图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
    public func compressImage(toByte maxLength: Int) -> UIImage? {
        //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
        var compression: CGFloat = 1
        var data = self.jpegData(compressionQuality: compression)
        if (data?.count ?? 0) < maxLength {
            return self
        }
        //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression)
            if Double((data?.count ?? 0)) < Double(maxLength) * 0.9 {
                min = compression
            } else if (data?.count ?? 0) > maxLength {
                max = compression
            } else {
                break
            }
        }
        //判断“压处理”的结果是否符合要求，符合要求就over
        var resultImage: UIImage? = nil
        if let data = data {
            resultImage = UIImage(data: data)
        }
        if (data?.count ?? 0) < maxLength {
            return resultImage
        }

        //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
        var lastDataLength = 0
        while (data?.count ?? 0) > maxLength && (data?.count ?? 0) != lastDataLength {
            lastDataLength = data?.count ?? 0
            //获取处理后的尺寸
            let ratio = CGFloat(maxLength) / CGFloat((data?.count ?? 0))
            let size = CGSize(
                    width: CGFloat(Float(resultImage?.size.width ?? 0) * sqrtf(Float(ratio))),
                    height: CGFloat(Float(resultImage?.size.height ?? 0) * sqrtf(Float(ratio))))
            //通过图片上下文进行处理图片
            UIGraphicsBeginImageContext(size)
            resultImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            //获取处理后图片的大小
            data = resultImage?.jpegData(compressionQuality: compression)
        }

        return resultImage
    }

    ///  根据图片指定size重新绘制图片
    public func redrawImage(imgSize:CGSize) -> UIImage? {
        if min(imgSize.width, imgSize.height) <= 0 {
            return nil
        }
        var img: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(imgSize, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: imgSize), blendMode: .normal, alpha: 1.0)
        img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

#endif
