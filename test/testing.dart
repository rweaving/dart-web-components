// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/** Common definitions used for setting up the test environment. */
library testing;

import 'package:html5lib/dom.dart';
import 'package:html5lib/parser.dart';
import 'package:web_components/src/analyzer.dart';
import 'package:web_components/src/info.dart';
import 'package:web_components/src/messages.dart';
import 'package:web_components/src/options.dart';
import 'package:web_components/src/files.dart';
import 'package:web_components/src/file_system/path.dart';

useMockMessages() {
  messages = new Messages(printHandler: (message) {});
}

Document parseDocument(String html) => parse(html);

Element parseSubtree(String html) => parseFragment(html).nodes[0];

ElementInfo analyzeElement(Element elem) {
  return analyzeNodeForTesting(elem).bodyInfo;
}

FileInfo analyzeDefinitionsInTree(Document doc) =>
    analyzeDefinitions(new SourceFile(new Path(''))..document = doc);

/** Parses files in [fileContents], with [mainHtmlFile] being the main file. */
List<SourceFile> parseFiles(Map<String, String> fileContents,
    [String mainHtmlFile = 'index.html']) {

  var result = <SourceFile>[];
  fileContents.forEach((filename, contents) {
    var src = new SourceFile(new Path(filename));
    src.document = parse(contents);
    result.add(src);
  });

  return result;
}

/** Analyze all files. */
Map<String, FileInfo> analyzeFiles(List<SourceFile> files) {
  var result = new Map<Path, FileInfo>();
  // analyze definitions
  for (var file in files) {
    result[file.path] = analyzeDefinitions(file);
  }

  // analyze file contents
  for (var file in files) {
    analyzeFile(file, result);
  }
  return _toStringMap(result);
}

Map<Path, FileInfo> toPathMap(Map<String, FileInfo> map) {
  var res = new Map<Path, FileInfo>();
  for (var k in map.keys) {
    res[new Path(k)] = map[k];
  }
  return res;
}

Map<String, FileInfo> _toStringMap(Map<Path, FileInfo> map) {
  var res = new Map<String, FileInfo>();
  for (var k in map.keys) {
    res[k.toString()] = map[k];
  }
  return res;
}
