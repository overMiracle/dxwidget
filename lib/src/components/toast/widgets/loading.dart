// The MIT License (MIT)
//
// Copyright (c) 2020 nslogx
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import 'package:dxwidget/src/components/toast/index.dart';
import 'package:dxwidget/src/components/toast/toast.dart';
import 'package:flutter/material.dart';

class DxToastLoading extends StatefulWidget {
  final Widget? child;

  const DxToastLoading({
    Key? key,
    required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  State<DxToastLoading> createState() => _DxToastLoadingState();
}

class _DxToastLoadingState extends State<DxToastLoading> {
  late DxToastOverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = DxToastOverlayEntry(
      builder: (BuildContext context) => DxToast.instance.w ?? const SizedBox.shrink(),
    );
    DxToast.instance.overlayEntry = _overlayEntry;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        initialEntries: [
          DxToastOverlayEntry(
            builder: (BuildContext context) => widget.child ?? const SizedBox.shrink(),
          ),
          _overlayEntry,
        ],
      ),
    );
  }
}
