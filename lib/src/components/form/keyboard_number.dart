import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

class DxNumberKeyboard {
  // 当前输入值
  final String? value;

  // 键盘标题
  final String? title;

  // 输入值最大长度
  final int? maxLength;

  // 左下角按键内容
  final String extraKey;

  // 关闭按钮文字，空则不展示，在标题右侧展示
  final String? closeButtonText;

  // 删除按钮文字
  final String deleteButtonText;

  // 是否展示删除按钮
  final bool showDeleteKey;

  // 当前输入值改变时触发
  final Function(String val)? onChange;

  // 当前输入值等于最大值时触发
  final Function(String val)? onSubmitted;

  // 键盘关闭时触发
  final Function()? onClose;

  final Widget _sizedBoxShrink = const SizedBox.shrink();

  DxNumberKeyboard({
    this.value = '',
    this.title,
    this.maxLength,
    this.extraKey = '返回',
    this.closeButtonText,
    this.deleteButtonText = '删除',
    this.showDeleteKey = true,
    this.onChange,
    this.onSubmitted,
    this.onClose,
  });

  show(BuildContext context) {
    List<int> list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0];
    int length = value!.length;
    List<String?> codeList = [...value!.split('')];

    Widget buildTitle() {
      return title != null
          ? Container(
              padding: DxStyle.numberKeyboardTitlePadding,
              decoration: const BoxDecoration(
                color: DxStyle.numberKeyboardBackgroundColor,
                border: Border(bottom: BorderSide(width: DxStyle.borderWidthBase, color: DxStyle.borderColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  title != null
                      ? Text(
                          title!,
                          style: const TextStyle(
                            fontSize: DxStyle.numberKeyboardTitleFontSize,
                            color: DxStyle.numberKeyboardTitleTextColor,
                          ),
                        )
                      : _sizedBoxShrink,
                  closeButtonText != null
                      ? GestureDetector(
                          child: Text(
                            closeButtonText!,
                            style: const TextStyle(
                              fontSize: DxStyle.numberKeyboardCloseFontSize,
                              color: DxStyle.numberKeyboardCloseColor,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            onClose?.call();
                          },
                        )
                      : _sizedBoxShrink,
                ],
              ),
            )
          : _sizedBoxShrink;
    }

    GridView buildKeyBoard() {
      return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.2,
            mainAxisSpacing: DxStyle.numberKeyboardNumSpacing,
            crossAxisSpacing: DxStyle.numberKeyboardNumSpacing,
          ),
          itemCount: 12,
          itemBuilder: (_, index) {
            return Material(
              color: (index == 9 || index == 11) ? DxStyle.numberKeyboardKeyBackground : Colors.white,
              child: InkWell(
                child: Center(
                  child: index == 11
                      ? Text(showDeleteKey ? deleteButtonText : "",
                          style: const TextStyle(fontSize: DxStyle.numberKeyboardDeleteFontSize))
                      : index == 9
                          ? Text(extraKey, style: const TextStyle(fontSize: DxStyle.numberKeyboardDeleteFontSize))
                          : Text(list[index].toString(),
                              style: const TextStyle(fontSize: DxStyle.numberKeyboardKeyFontSize)),
                ),
                onTap: () {
                  if (index == 9) {
                    Navigator.pop(context);
                    return;
                  }
                  if (index == 11 && showDeleteKey) {
                    if (length == 0) return;
                    codeList.removeLast();
                    length--;
                  } else {
                    if (maxLength != null && codeList.length == maxLength) {
                      return;
                    }
                    codeList.add(index == 9 ? extraKey : list[index].toString());
                    length++;
                  }
                  String code = '';
                  for (int i = 0; i < codeList.length; i++) {
                    code = code + codeList[i].toString();
                  }
                  if (onChange != null) onChange!(code);
                  if (maxLength != null && codeList.length == maxLength && onSubmitted != null) {
                    onSubmitted!(code);
                  }
                },
              ),
            );
          });
    }

    return showBottomSheet(
      context: context,
      backgroundColor: DxStyle.numberKeyboardKeyBackground,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: DxStyle.borderWidthBase, color: DxStyle.borderColor),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              buildKeyBoard(),
            ],
          ),
        );
      },
    );
  }
}
