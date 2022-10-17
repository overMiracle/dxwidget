import 'package:dxwidget/src/theme/index.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DxSelectionMenuItemWidget extends StatelessWidget {
  final String title;
  final bool isHighLight;
  final bool active;
  final VoidCallback? itemClick;
  DxSelectionThemeData themeData;

  DxSelectionMenuItemWidget({
    Key? key,
    required this.title,
    this.isHighLight = false,
    this.active = false,
    this.itemClick,
    required this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () => itemClick?.call(),
        child: Container(
          color: Colors.transparent,
          constraints: const BoxConstraints.expand(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
                style: isHighLight ? themeData.menuSelectedTextStyle : themeData.menuNormalTextStyle,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: isHighLight
                    ? (active
                        ? const Icon(Icons.arrow_drop_up, size: 18, color: DxStyle.$0984F9)
                        : const Icon(Icons.arrow_drop_down, size: 18, color: DxStyle.$0984F9))
                    : (active
                        ? const Icon(Icons.arrow_drop_up, size: 18, color: DxStyle.$5E5E5E)
                        : const Icon(Icons.arrow_drop_down, size: 18, color: DxStyle.$5E5E5E)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
