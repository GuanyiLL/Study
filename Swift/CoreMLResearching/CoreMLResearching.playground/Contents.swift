/*:
 # CoreML Tutorial
 ----
 ## Overview
 
 有了CoreML，就可以将训练好的机器学习模型整合到APP内。
 
 ![coreML-01](/coreml01.jpg)
 
 训练好的模型是将机器学习算法应用于一组训练数据的结果。 该模型基于新的输入数据进行预测。
 
 Core ML是特定领域框架和功能的基础。 Core ML支持用于图像分析的Vision，自然语言处理的基础（例如NSLinguisticTagger类）以及用于评估学习决策树的*GameplayKit*。 Core ML本身建立在像*Accelerate*和*BNNS*以及*Metal Performance Shaders*的底层之上。
 
  ![coreML-02](/coreml02.jpg)
 
 Core ML针对硬件进行了性能优化，最大限度地减少了内存占用和功耗。能够确保用户数据的隐私安全，并且应用支持离线运行。
 
 ----
 # Topics
 
 ## 整合Core ML模型到app中
 Core ML支持多种机器学习模型，包括神经网络，树集成，支持向量机和广义线性模型。 Core ML需指定的模型文件格式（具有.mlmodel文件扩展名的模型）。
苹果提供了几种用于Core ML格式的开源模型。 另外，各个研究组织和大学也发布了他们的模型和训练数据，这些数据可能不是Core ML模型格式。 要使用这些模型，需要使用转换工具将格式转换成mlmodel格式。

 [模型下载地址](https://developer.apple.com/machine-learning/)
 
 ### 将训练模型加入Xcdoe工程中
 用拖拽的方式将模型文件添加到工程中。在Xcode中点击模型文件，则可以看到相关信息。
 
 ![coreML-03](/coreml03.jpg)
 
 该模型输入参数为一张图片，输出值有两个，一个是没中预测的可能性与可能性最高的结果。
 
 ### 在代码中创建一个模型
 Xcode会自动根据模型的输入输出提供编程接口。
 
 初始化一个模型：
 ```
 let model = MobileNet.mimodel
 ```
 
 ### 将参数传递给模型，并输出预测
 `MobileNet`这个类，有一个预测方法，输入所需参数，返回一个MobilNetOutput类型的实例。

 ```
 let output = try? model.prediction(image: input!)
 ```
 
 然后可以通过MobileNetOutput的实例取得预测结果，并展示在UI中。
 
 ----
 
 # 使用Vision和Core ML来对图片进行分类处理
 
 ----
 
 ## Overview
 
 Core ML框架可以利用训练好的模型对输入的数据进行分类处理。Vision框架结合Core ML则使图像分析以及机器学习变得更加简单可靠。
 
 ## 用Core ML模型来生成Vision
 首先用模型来创建一个Vision请求,并在回调中调用结果的处理方法:
 
 ```
 let model = try VNCoreMLModel(for: MobileNet().model)
 let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
     print("index = \(index)")
 })
 request.imageCropAndScaleOption = .centerCrop
 ```
 
 ML 在处理输入的图像时使用的是固定的长宽比，但是输入的图像可能是任意比例，因此Vision必须缩放或者截取图片来进行处理，设置*imageCropAndScaleOption*来获得最好的结果。出了特殊情况*centerCrop*是最合适的选项。

 ## 发出Vison请求
 
 `VNImageRequestHandler`对象的创建基于一张被处理的图片，以及处理请求的方法。这个方法是同步执行的，然而使用了后台线程，以便主线程在请求执行时不被阻塞。
 
 ```
 DispatchQueue.global(qos: .userInitiated).async {
     let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
     do {
         try handler.perform([self.classificationRequest])
     } catch {
         print("Failed to perform classification.\n\(error.localizedDescription)")
     }
 }
 ```
 大多数的训练模型都已经导向了正确的展示方式。为了对任意方向的图片作出最合适的处理，所以将图片的方向传递给处理方法。
 
 ## 处理图片分类结果
 
 Vision的处理方法内可以得知处理结果是成功还是失败。如果成功，那么结果中将包含`VNClassificationObservation`对象。
 
 ```
 func processClassifications(for request: VNRequest, error: Error?) {
     DispatchQueue.main.async {
         guard let results = request.results else {
         self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
         return
     }
     // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
    let classifications = results as! [VNClassificationObservation]
 ```

 */
