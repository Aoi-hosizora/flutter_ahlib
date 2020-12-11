import 'package:flutter/foundation.dart';
import 'package:flutter_ahlib/src/list/updatable_list_setting.dart';

/// This is a library private getData function used for
/// [RefreshableListView], [RefreshableSliverListView] and [RefreshableStaggeredGridView].
Future<void> getRefreshableDataFunc<T>({
  @required void Function(bool) setLoading,
  @required void Function(String) setErrorMessage,
  @required UpdatableListSetting setting,
  @required List<T> data,
  @required Future<List<T>> Function() getData,
  @required Function() setState,
}) async {
  assert(setLoading != null);
  assert(setErrorMessage != null);
  assert(setting != null);
  assert(data != null);
  assert(getData != null);
  assert(setState != null);

  // start loading
  setLoading(true);
  if (setting.clearWhenRefresh) {
    setErrorMessage('');
    data.clear();
  }
  setting.onStartLoading?.call();
  setState();

  // get data
  final func = getData.call();

  // return future
  return func.then((List<T> list) async {
    // success to get data without error
    setErrorMessage('');
    if (setting.updateOnlyIfNotEmpty && list.isEmpty) {
      return; // get an empty list
    }
    if (data.isNotEmpty) {
      data.clear();
      setState();
      await Future.delayed(Duration(milliseconds: 20));
    }
    data.addAll(list);
    setting.onAppend?.call(list);
  }).catchError((e) {
    // error aroused
    setErrorMessage(e.toString());
    if (setting.clearWhenError) {
      data.clear();
    }
    setting.onError?.call(e);
  }).whenComplete(() {
    // finish loading and setState
    setLoading(false);
    setting.onStopLoading?.call();
    setState();
  });
}
