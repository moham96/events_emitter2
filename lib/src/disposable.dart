// Copyright 2023 LiveKit, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:events_emitter2/src/extensions.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

typedef OnDisposeFunc = Future<void> Function();

mixin _Disposer {
  //
  final _disposeFuncs = <OnDisposeFunc>[];
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;
  int get disposeFuncCount => _disposeFuncs.length;

  // last added func will be called first when disposing
  void onDispose(OnDisposeFunc func) => _disposeFuncs.add(func);

  Future<bool> _dispose() async {
    if (!_isDisposed) {
      Logger.root.finer('[$objectId] dispose()');
      _isDisposed = true;
      if (_disposeFuncs.isNotEmpty) {
        Logger.root.finer(
            '[$objectId] running ${_disposeFuncs.length} dispose funcs...');
        // call dispose funcs in reverse order
        for (final disposeFunc in _disposeFuncs.reversed) {
          await disposeFunc();
        }
        _disposeFuncs.clear();
        Logger.root.finer('[$objectId] dispose complete.');
      }
      return true;
    } else {
      Logger.root.warning('[$objectId] unnecessary dispose() called.');
      return false;
    }
  }
}

abstract class Disposable with _Disposer {
  @mustCallSuper
  Future<bool> dispose() async {
    return await _dispose();
  }
}