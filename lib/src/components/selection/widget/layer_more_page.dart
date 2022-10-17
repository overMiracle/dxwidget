import 'package:dxwidget/dxwidget.dart';
import 'package:dxwidget/src/components/selection/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 用于展示浮层的筛选项 如商圈
/// 左侧是：二级筛选项 右侧是三级筛选项
/// 默认将第一个元素选中
class DxSelectionLayerMorePage extends StatefulWidget {
  final DxSelectionItem item;
  final DxSelectionThemeData themeData;

  const DxSelectionLayerMorePage({
    Key? key,
    required this.item,
    required this.themeData,
  }) : super(key: key);

  @override
  State<DxSelectionLayerMorePage> createState() => _DxSelectionLayerMorePageState();
}

class _DxSelectionLayerMorePageState extends State<DxSelectionLayerMorePage> with SingleTickerProviderStateMixin {
  List<DxSelectionItem> _firstList = [];

  late List<DxSelectionItem> _originalSelectedItemsList;

  ///当前选中的 一级筛选条件
  DxSelectionItem? _currentFirstItem;

  ///当前选中的 一级筛选条件的索引
  int _currentIndex = 0;

  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween(end: Offset.zero, begin: const Offset(1.0, 0.0)).animate(_controller);
    _controller.forward();
    _originalSelectedItemsList = widget.item.selectedList();

    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: <Widget>[
          _buildLeftSlide(context),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SlideTransition(
                position: _animation,
                child: child,
              );
            },
            child: _buildRightSlide(context),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  ///左侧是黑色浮层
  Widget _buildLeftSlide(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          DxSelectionUtil.resetSelectionData(widget.item);
          for (var data in _originalSelectedItemsList) {
            data.isSelected = true;
          }
          Navigator.maybePop(context);
        },
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }

  ///右侧是二级列表
  Widget _buildRightSlide(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.zero,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: DxStyle.$222222),
                  onPressed: () {
                    DxSelectionUtil.resetSelectionData(widget.item);
                    //将选中的筛选项返回
                    for (var data in _originalSelectedItemsList) {
                      data.isSelected = true;
                    }
                    Navigator.pop(context, widget.item);
                  },
                ),
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                backgroundColor: Colors.white,
                title: Text('选择${widget.item.title}', style: DxStyle.$222222$14$W500),
              ),
              const DxDivider(),
              _buildSelectionListView(),
              const DxDivider(),
              _buildBottomBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionListView() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xfff8F8F8),
              child: _buildLeftListView(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: ScrollConfiguration(
                behavior: DxNoScrollBehavior(),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return _buildRightItem(index);
                  },
                  itemCount: _currentFirstItem?.children.length ?? 0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLeftListView() {
    return ScrollConfiguration(
      behavior: DxNoScrollBehavior(),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              //一级按钮的点击：1、处理点击 2、设置二级的默认选中
              //如果是单选：
              //      如果是选中的情况，则将已选中的兄弟节点清除
              //      如果是未选的情况，则直接选中

              if (index == _currentIndex) {
                return;
              }
              if (_firstList[index].type == DxSelectionType.radio) {
                setState(() {
                  _currentIndex = index;
                  _currentFirstItem = _firstList[index];
                  if (_currentFirstItem != null) {
                    if (_currentFirstItem!.isSelected) {
                      _currentFirstItem!.clearSelectedEntity();
                    } else {
                      _currentFirstItem!.parent?.clearSelectedEntity();
                      //设置不限
                      setInitialSecondShowingItem(_currentFirstItem!);
                    }
                  }
                });
              } else {
                _firstList[index].parent?.children.where((data) {
                  return data.type != DxSelectionType.checkbox;
                }).forEach((data) {
                  data.isSelected = false;
                  data.clearChildSelection();
                });

                if (!_firstList[index].isSelected) {
                  _currentIndex = index;
                  _currentFirstItem = _firstList[index];
                  //一级选中的情况，初始化二级
                  setInitialSecondShowingItem(_currentFirstItem!);
                  setState(() {});
                } else {
                  _currentIndex = index;
                  _currentFirstItem = _firstList[index];
                  setState(() {});
                }
              }
            },
            child: _buildLeftItem(index),
          );
        },
        itemCount: _firstList.length,
      ),
    );
  }

  //清空
  Widget _buildBottomBtn() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        height: 80,
        child: DxSelectionMoreBottomWidget(
          //entity是商圈
          item: widget.item,
          themeData: widget.themeData,
          clearCallback: () {
            setState(() {
              //商圈的重置
              widget.item.clearSelectedEntity();
            });
          },
          conformCallback: (data) {
            //带着商圈的数据返回
            for (var value in data.children) {
              // 如果房山没有选中的子节点， 那么房山就是未选中
              value.isSelected = value.selectedList().isEmpty ? false : true;
            }
            //如果商圈没有选中的 那么商圈就是未选中
            data.isSelected = data.selectedList().isNotEmpty ? true : false;
            Navigator.maybePop(context, data);
          },
        ),
      ),
    );
  }

  Widget _buildLeftItem(int index) {
    //如果房山 被选中了或者房山处于正在选择的状态 则加粗
    TextStyle textStyle = widget.themeData.flayerNormalTextStyle;
    if (index == _currentIndex) {
      textStyle = widget.themeData.flayerSelectedTextStyle;
    } else if ((_firstList[index].isSelected) && _firstList[index].selectedList().isNotEmpty) {
      textStyle = widget.themeData.flayerBoldTextStyle;
    }

    List<DxSelectionItem> list = _firstList[index].selectedList();
    //如果选中了不限 则展示 房山全部
    //如果选中了某几个
    //        如果可以跨区域 则显示数量 否则只加粗
    String name = _firstList[index].title;

    if (list.isNotEmpty) {
      if (list.every((data) {
        return data.isUnLimit();
      })) {
        name += '(全部)';
      } else {
        bool containsCheck = _firstList[index].hasCheckBoxBrother();
        bool containsCheckChildren = false;

        if (_firstList[index].children.isNotEmpty) {
          containsCheckChildren = _firstList[index].children[0].hasCheckBoxBrother();
        }
        if (containsCheck && containsCheckChildren) {
          name += '(${list.length})';
        }
      }
    }
    return Container(
      alignment: Alignment.centerLeft,
      height: 48,
      color: index == _currentIndex ? Colors.white : const Color(0xFFF8F8F8),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
      ),
    );
  }

  Widget _buildRightItem(int index) {
    bool isSingle = (_currentFirstItem?.children[index].type == DxSelectionType.radio) ||
        (_currentFirstItem?.children[index].type == DxSelectionType.unLimited);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_currentFirstItem != null) {
            if (isSingle) {
              _currentFirstItem!.clearSelectedEntity();
              _currentFirstItem!.isSelected = true;
              _currentFirstItem!.children[index].isSelected = true;
            } else {
              _currentFirstItem!.children.where((data) {
                return data.type != DxSelectionType.checkbox;
              }).forEach((data) {
                data.isSelected = false;
              });
              _currentFirstItem!.children[index].isSelected = !_currentFirstItem!.children[index].isSelected;
            }

            //如果二级没有任何选中的，那么一级为不选中
            if (_currentFirstItem!.selectedList().isEmpty) {
              _currentFirstItem!.isSelected = false;
            } else {
              _currentFirstItem!.isSelected = true;
            }
          }
        });
      },
      child: Container(
        alignment: isSingle ? Alignment.centerLeft : Alignment.centerLeft,
        height: 48,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: isSingle
              ? _buildRightSingleItem(_currentFirstItem?.children[index])
              : _buildRightMultiItem(_currentFirstItem?.children[index]),
        ),
      ),
    );
  }

  void _initData() {
    //填充一级筛选数据
    _firstList = widget.item.children;
    //找到一级需要显示 的索引
    for (int i = 0; i < _firstList.length; i++) {
      if (_firstList[i].selectedList().isNotEmpty) {
        _firstList[i].isSelected = true;
      }
    }
    _currentIndex = _firstList.indexWhere((data) {
      return data.isSelected;
    });

    if (_currentIndex >= _firstList.length || _currentIndex == -1) {
      _currentIndex = 0;
    }
    //当前选中的一级筛选条件
    _currentFirstItem = _firstList[_currentIndex];
    _currentFirstItem?.isSelected = true;

    //找到第二级需要默认选中的索引
    if (_currentFirstItem != null) {
      setInitialSecondShowingItem(_currentFirstItem!);
    }
  }

  Widget _buildRightMultiItem(DxSelectionItem? entity) {
    if (entity == null) {
      return const SizedBox.shrink();
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              entity.title,
              style:
                  entity.isSelected ? widget.themeData.flayerSelectedTextStyle : widget.themeData.flayerNormalTextStyle,
            ),
          ),
          SizedBox(
            height: 16,
            width: 16,
            child: entity.isSelected
                ? Image.asset(DxAsset.selected, package: 'dxwidget')
                : Image.asset(DxAsset.unSelected, package: 'dxwidget'),
          )
        ],
      );
    }
  }

  Widget _buildRightSingleItem(DxSelectionItem? entity) {
    if (entity == null) {
      return const SizedBox.shrink();
    } else {
      return Text(
        entity.title,
        textAlign: TextAlign.left,
        style: entity.isSelected ? widget.themeData.flayerSelectedTextStyle : widget.themeData.flayerNormalTextStyle,
      );
    }
  }

  //初始化二级的选中（小白楼）
  //规则：如果二级没有选中的，那么 选中二级的不限
  void setInitialSecondShowingItem(DxSelectionItem currentFirstEntity) {
    //设置初始化的二级筛选条件 -1没有
    int secondIndex = currentFirstEntity.getFirstSelectedChildIndex();

    // 配置选中不限 : 第一层级是checkbox 并且 没有默认选中的
    if (secondIndex == -1 && currentFirstEntity.children.isNotEmpty) {
      for (int i = 0, n = currentFirstEntity.children.length; i < n; i++) {
        if (currentFirstEntity.children[i].isUnLimit() && currentFirstEntity.type == DxSelectionType.checkbox) {
          currentFirstEntity.children[i].isSelected = true;
          break;
        }
      }
    }

    //如果二级有选中的，一级配置为选中，否则为不选中
    int selectedIndex = currentFirstEntity.children.indexWhere((data) {
      return data.isSelected;
    });
    if (selectedIndex != -1 && currentFirstEntity.children.isNotEmpty) {
      currentFirstEntity.isSelected = true;
    } else {
      currentFirstEntity.isSelected = false;
    }
  }
}
