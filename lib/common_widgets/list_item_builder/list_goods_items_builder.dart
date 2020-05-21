
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'goods_empty_content.dart';

typedef GoodsItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListGoodsItemsBuilder<T> extends StatelessWidget {
  const ListGoodsItemsBuilder(
      {Key key, @required this.snapshot, @required this.itemBuilder})
      : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final GoodsItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return GoodsEmptyContent();
      }
    } else if (snapshot.hasError) {
      print('error => ${snapshot.error}');
      return GoodsEmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now.',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      separatorBuilder: (contain, index) => Divider(height: 1.5),
      itemCount: items.length + 2,
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
