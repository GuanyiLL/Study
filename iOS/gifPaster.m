MutableArray *)imgArray {
    if (_imgArray) {
        return _imgArray;
    }
    _imgArray = [NSMutableArray array];
    NSData * data = [self gifImageData];
    
    CGImageSourceRef sourec = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //2.将gif图片分解成帧
    
    size_t count = CGImageSourceGetCount(sourec);
    
    for (size_t i = 0; i < count; i++)
    {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourec, i, NULL);
        
        //3.将单帧图片转化为UIimage
        UIImage * image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        
        [_imgArray addObject:image];
        
        //释放imageRef
        CGImageRelease(imageRef);
    }
    //释放sourec
    CFRelease(sourec);
    return _imgArray;
}

- (NSData *)gifImageData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}
