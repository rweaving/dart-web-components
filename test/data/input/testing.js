// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

if (navigator.webkitStartDart) {
  navigator.webkitStartDart();
}

if (window.layoutTestController) {
  window.layoutTestController.waitUntilDone();
}

function messageHandler(e) {
  if (e.data == 'done') {
    // TODO(sigmund): use && in this condition, issue #41
    if (window.layoutTestController) {
      window.layoutTestController.notifyDone();
    }
  }
}

window.addEventListener('message', messageHandler, false);

function errorHandler(e) {
  if (window.layoutTestController) {
    window.layoutTestController.notifyDone();
  }
  window.console.log('FAIL');
}

window.addEventListener('error', errorHandler, false);

// TODO(jmesserly): this is an attempt to work around platform specific font
// differences.
var style = document.createElement('style');
style.textContent = '* { font-family: Ahem; }' +
    'pre, xmp, plaintext, listing { font-family: monospace; }';
document.head.appendChild(style);
