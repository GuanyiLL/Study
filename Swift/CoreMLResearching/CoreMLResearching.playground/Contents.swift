/*:
 # CoreML Tutorail
 ----
 ## Overview
 
 有了CoreML，就可以将训练好的机器学习模型整合到APP内。
 
 ![coreML-01](/coreml01.jpg)
 
 训练好的模型是将机器学习算法应用于一组训练数据的结果。 该模型基于新的输入数据进行预测。
 
 Core ML是特定领域框架和功能的基础。 Core ML支持用于图像分析的Vision，自然语言处理的基础（例如NSLinguisticTagger类）以及用于评估学习决策树的GameplayKit。 Core ML本身建立在像*Accelerate*和*BNNS*以及*Metal Performance Shaders*的底层之上。
 
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
 
 */

