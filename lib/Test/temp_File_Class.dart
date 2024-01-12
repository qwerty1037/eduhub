import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

class FileClass {
  late File image;
  late int difficulty;
  FileClass(image, diff) {
    this.image = image;
    this.difficulty = diff;
  }

  Image getImage() {
    return Image.file(image);
  }

  bool isDifficultyCorrect(int settedDifficulty) {
    if (settedDifficulty == this.difficulty) {
      return true;
    } else {
      return false;
    }
  }
}

class TempFileClass {
  List<FileClass> fileClass = <FileClass>[];
  TempFileClass() {
    fileClass.add(FileClass(File("C:\\Users\\JungHyun Han\\Desktop\\data\\image1.png"), 1));
    fileClass.add(FileClass(File("C:\\Users\\JungHyun Han\\Desktop\\data\\image2.png"), 2));
    fileClass.add(FileClass(File("C:\\Users\\JungHyun Han\\Desktop\\data\\image3.png"), 3));
    fileClass.add(FileClass(File("C:\\Users\\JungHyun Han\\Desktop\\data\\image4.png"), 3));
  }
  List<Widget> getGridView(int? diff) {
    List<Widget> temp = <Widget>[];
    if (diff != null) {
      for (int i = 0; i < fileClass.length; i++) {
        if (fileClass[i].isDifficultyCorrect(diff)) {
          temp.add(Container(
            padding: const EdgeInsets.all(8),
            color: material.Colors.green[100],
            child: fileClass[i].getImage(),
          ));
        }
      }
    } else {
      for (int i = 0; i < fileClass.length; i++) {
        temp.add(Container(
          padding: const EdgeInsets.all(8),
          color: material.Colors.green[100],
          child: fileClass[i].getImage(),
        ));
      }
    }
    return temp;
  }
}
