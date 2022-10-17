import 'package:dxwidget/dxwidget.dart';
import 'package:flutter/material.dart';

const double _kItemSidePadding = 5;

/// 描述: 横向步骤条,是一种常见的导航形式，它具有导航通用的属性：告知用户”我在哪/我能去哪“，
/// 步骤数目就相当于告知用户--能去哪或者说流程将要经历什么。
/// 通用组件步骤条分为三个状态：完成态/进行态/等待态，三种状态在样式上均加以区分
/// 注意事项：横向步骤条内的步骤总数最多只支持5个
/// 参考网址：https://bruno.ke.com/page/v2.2.0/widgets/brn-horizontal-steps
class DxHorizontalSteps extends StatefulWidget {
  /// The steps of the stepper whose titles, subtitles, icons always get shown.
  ///
  /// 步骤条中元素的列表
  final List<DxHorizontalStepItem> steps;

  /// 控制类
  final DxStepsController? controller;

  /// 自定义正在进行状态的icon
  final Widget? doingIcon;

  /// 自定义已完成状态的icon
  final Widget? completedIcon;

  const DxHorizontalSteps({
    Key? key,
    required this.steps,
    this.controller,
    this.doingIcon,
    this.completedIcon,
  })  : assert(steps.length < 6),
        super(key: key);

  @override
  State<DxHorizontalSteps> createState() => _DxHorizontalStepsState();
}

class _DxHorizontalStepsState extends State<DxHorizontalSteps> {
  Color get _primary => DxStyle.$0984F9;

  int get _currentIndex {
    return widget.controller?.currentIndex ?? 0;
  }

  Color _getStepContentTextColor(int index) {
    return index > _currentIndex ? const Color(0xFFCCCCCC) : const Color(0xFF222222);
  }

  void _handleStepStateListenerTick() {
    setState(() {});
  }

  void _initController() {
    widget.controller?._setMaxCount(widget.steps.length);
    widget.controller?.addListener(_handleStepStateListenerTick);
  }

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleStepStateListenerTick);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DxHorizontalSteps oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool isControllerDiff = oldWidget.controller != null && widget.controller != oldWidget.controller;
    final bool isCountDiff = widget.steps.length != oldWidget.steps.length;
    if (isControllerDiff || isCountDiff) {
      oldWidget.controller?.removeListener(_handleStepStateListenerTick);
      _initController();
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 单独一个widget组件，用于返回需要生成的内容widget
    Widget content;
    final List<Widget> childrenList = <Widget>[];
    final List<DxHorizontalStepItem> steps = widget.steps;
    final int length = steps.length;
    for (int i = 0; i < length; i += 1) {
      childrenList.add(_applyStepItem(steps[i], i));
    }
    content = SizedBox(
      height: 78,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: childrenList,
      ),
    );
    return content;
  }

  Widget _applyStepItem(DxHorizontalStepItem step, int index) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _applyStepAndLine(step, index),
          _applyStepContent(step, index),
        ],
      ),
    );
  }

  Widget _applyStepAndLine(DxHorizontalStepItem step, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        index == 0 ? const Expanded(child: SizedBox.shrink()) : _applyLineItem(index, true),
        _applyStepIcon(step, index),
        index == widget.steps.length - 1 ? const Expanded(child: SizedBox.shrink()) : _applyLineItem(index, false),
      ],
    );
  }

  Widget _applyStepIcon(DxHorizontalStepItem step, int index) {
    Widget icon;
    if (widget.controller?.isCompleted == true) {
      return _getCompletedIcon(step);
    }
    if (step.state != null) {
      switch (step.state) {
        case DxStepState.indexed:
          icon = _getIndexIcon(index);
          break;
        case DxStepState.done:
          icon = _getCompletedIcon(step);
          break;
        case DxStepState.running:
          icon = _getDoingIcon(step);
          break;
        default:
          icon = _getDoingIcon(step);
          break;
      }
    } else {
      if (index < _currentIndex) {
        // 当前index小于指定的活跃index
        icon = _getCompletedIcon(step);
      } else if (index == _currentIndex) {
        icon = _getDoingIcon(step);
      } else {
        icon = _getIndexIcon(index);
      }
    }
    return icon;
  }

  Widget _applyLineItem(int index, bool isLeft) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: DxSolidLine(
          height: 1,
          leftInset: isLeft ? 0 : _kItemSidePadding,
          rightInset: isLeft ? _kItemSidePadding : 0,
          color: _getLineColor(index, isLeft),
        ),
      ),
    );
  }

  Color _getLineColor(int index, bool isLeft) {
    if (index < _currentIndex) {
      return _primary;
    } else if (_currentIndex == index && isLeft) {
      return _primary;
    }
    return const Color(0xFFE7E7E7);
  }

  Widget _getIndexIcon(int index) {
    Widget icon;
    switch (index) {
      case 1:
        icon = Image.asset(DxAsset.step2, width: 20, height: 20);
        break;
      case 2:
        icon = Image.asset(DxAsset.step3, width: 20, height: 20);
        break;
      case 3:
        icon = Image.asset(DxAsset.step4, width: 20, height: 20);
        break;
      case 4:
        icon = Image.asset(DxAsset.step5, width: 20, height: 20);
        break;
      default:
        icon = Image.asset(DxAsset.stepRunning, width: 20, height: 20);
        break;
    }
    return icon;
  }

  Widget _applyStepContent(DxHorizontalStepItem step, int index) {
    Widget? stepContent = step.content;
    if (stepContent != null) {
      return stepContent;
    }
    return Container(
      margin: const EdgeInsets.only(top: 6, left: _kItemSidePadding, right: _kItemSidePadding),
      child: Text(
        step.text ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          color: _getStepContentTextColor(index),
        ),
      ),
    );
  }

  Widget _getCompletedIcon(DxHorizontalStepItem step) {
    Widget? completedIcon = step.completedIcon;
    if (completedIcon != null) {
      /// 如果Step中自定义completedIcon不为空，则使用自定义的icon
      return completedIcon;
    }
    completedIcon = widget.completedIcon;
    if (completedIcon != null) {
      /// 如果自定义completedIcon不为空，则使用自定义的icon
      return completedIcon;
    }

    /// 使用组件默认的icon
    return Image.asset(DxAsset.stepDone, width: 20, height: 20);
  }

  Widget _getDoingIcon(DxHorizontalStepItem step) {
    Widget? doingIcon = step.doingIcon;
    if (doingIcon != null) {
      /// 如果Step中自定义doingIcon不为空，则使用自定义的icon
      return doingIcon;
    }
    doingIcon = widget.doingIcon;
    if (doingIcon != null) {
      /// 如果自定义doingIcon不为空，则使用自定义的icon
      return doingIcon;
    }
    // 使用组件默认的icon
    return Image.asset(DxAsset.stepRunning, width: 20, height: 20);
  }
}

enum DxStepState {
  /// A step that displays its index in its circle.
  indexed,

  /// A step that displays a running icon in its circle.
  running,

  /// A step that displays a completed icon in its circle.
  done
}

class DxHorizontalStepItem {
  /// Creates a step for a [Stepper].
  ///
  /// The [stepContent], [doingIcon] arguments can be null.
  const DxHorizontalStepItem({
    this.text,
    this.content,
    this.doingIcon,
    this.completedIcon,
    this.state,
  });

  /// The String title of the step that typically describes it.
  final String? text;

  /// The title of the step that typically describes it.
  final Widget? content;

  /// The doingIcon of the step
  final Widget? doingIcon;

  /// The completedIcon of the step
  final Widget? completedIcon;

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
  final DxStepState? state;
}

class DxStepsController with ChangeNotifier {
  /// 指示当前进行态的步骤
  int currentIndex;

  /// 整个流程是否完成
  bool isCompleted;

  /// 最大个数（最多只支持5个）
  int _maxCount = 0;

  DxStepsController({this.currentIndex = 0, this.isCompleted = false});

  /// 只有在当前包内调用，不开放给外部调用
  void _setMaxCount(int maxCount) => _maxCount = maxCount;

  /// 设置当前步骤条的 index,从 0 开始。
  void setCurrentIndex(int currentIndex) {
    if (this.currentIndex == currentIndex || currentIndex > _maxCount) return;
    isCompleted = currentIndex == _maxCount;
    this.currentIndex = currentIndex;
    notifyListeners();
  }

  /// 整个链路完成
  void setCompleted() => setCurrentIndex(_maxCount);

  /// 向前一步
  void forwardStep() {
    if (currentIndex < _maxCount) {
      setCurrentIndex(currentIndex + 1);
    }
  }

  /// 向后一步
  void backStep() {
    final int backIndex = currentIndex <= 0 ? 0 : currentIndex - 1;
    setCurrentIndex(backIndex);
  }
}
