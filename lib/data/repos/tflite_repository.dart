import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as imageLib;

class TfLiteRepository {
  static final TfLiteRepository _singleton = TfLiteRepository._internal();
  // String _model = "assets/tflite/ssd_mobilenet.tflite";
  String _modelPath = "assets/tflite/ssd_mobilenet.tflite";
  String _model = "SSDMobileNet";
  String _labels = "assets/tflite/labels.txt";

  factory TfLiteRepository() {
    return _singleton;
  }

  TfLiteRepository._internal();

  Future<void> init() async {
    await Tflite.loadModel(model: _modelPath, labels: _labels);
  }

  // Uint8List imageToByteListFloat32(
  //     imageLib.Image image, int inputSize, double mean, double std) {
  //   var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
  //   var buffer = Float32List.view(convertedBytes.buffer);
  //   int pixelIndex = 0;
  //   for (var i = 0; i < inputSize; i++) {
  //     for (var j = 0; j < inputSize; j++) {
  //       var pixel = image.getPixel(j, i);
  //       buffer[pixelIndex++] = (imageLib.getRed(pixel) - mean) / std;
  //       buffer[pixelIndex++] = (imageLib.getGreen(pixel) - mean) / std;
  //       buffer[pixelIndex++] = (imageLib.getBlue(pixel) - mean) / std;
  //     }
  //   }
  //   return convertedBytes.buffer.asUint8List();
  // }

  Uint8List imageToByteListUint8(imageLib.Image image, int inputSize) {
    var convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
    var buffer = Uint8List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = imageLib.getRed(pixel);
        buffer[pixelIndex++] = imageLib.getGreen(pixel);
        buffer[pixelIndex++] = imageLib.getBlue(pixel);
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  Future<bool> checkHumanInPhoto(File file) async {
    final object = await _recognizeObject(file);
    for (var item in object) {
      if (item['detectedClass'] == "person" &&
          item['confidenceInClass'] > 0.5) {
        return true;
      }
    }
    return false;
  }

  Future<List<dynamic>> _recognizeObject(File file) async {
    await init();

    final res = await Tflite.detectObjectOnImage(
      path: file.path, // required
      model: _model,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.5,
      numResultsPerClass: 10,
    );
    print(res);
    return res;
  }

  void dispose() async {
    await Tflite.close();
  }
}
