import 'package:qoiu_db/database/db_entity.dart';
import 'package:qoiu_utils/qoiu_utils_export.dart';

import 'base_many_to_many.dart';

abstract class ToManyLink<T extends DbEntity> {

  Future<List<T>> fetch();

  Future<void> add(T child);

  Future<void> remove(T child);
}

class DBManyToManyLink<T extends DbEntity, L extends BaseManyToMany>
    extends ToManyLink<T> {
  final int parentId;

  /// ID объекта, которому принадлежит список (напр. id гильдии)
  final L service;

  /// Ссылка на синглтон CharacterGuildLinks
  final LinkSide parentSide;

  DBManyToManyLink({
    required this.parentId,
    required this.service,
    required this.parentSide,
  });

  @override
  Future<List<T>> fetch() async {
    ['get all Where parentID',parentId].print();
    ['parentSide',parentSide.name].print();
    final res = await service.getItems(parentId, parentSide);
    return res.cast<T>();
  }

  @override
  Future<void> add(T child) async {
    if (child.id == -1) {
      throw Exception("Cannot link entity with id -1. Save it to DB first!");
    }

    // if (parentSide == LinkSide.side1) {
    //   await service.createLink(parentId, child.id); // (userId, skillId)
    // } else {
    //   await service.createLink(child.id, parentId); // (skillId, userId)
    // }


    if (parentSide == LinkSide.side1) {
      await service.createLinkWithEntity(child.toDB(), parentId, child.id); // (userId, skillId)
    } else {
      await service.createLinkWithEntity(child.toDB(),child.id, parentId); // (skillId, userId)
    }
  }

  @override
  Future<void> remove(T child) async {
    if (parentSide == LinkSide.side2) {
      await service.removeLink(child.id, parentId);
    } else {
      await service.removeLink(parentId, child.id);
    }
  }

  // Метод восстановления (хотя для SQL он скорее логический)
  static DBManyToManyLink<T, L>
      fromDb<T extends DbEntity, L extends BaseManyToMany>(
          int parentId, LinkSide side, L service) {
    return DBManyToManyLink<T, L>(
        parentId: parentId, parentSide: side, service: service);
  }
}

class MockManyToManyLink<T extends DbEntity> implements ToManyLink<T> {
  final List<T> _mockData;

  MockManyToManyLink([List<T>? mockData]):_mockData=mockData??[];

  @override
  Future<List<T>> fetch() async => _mockData;

  @override
  Future<void> add(T child) async {
    _mockData.add(child);
  }

  @override
  Future<void> remove(T child) async {
    _mockData.removeWhere((item) => (item as dynamic).id == child.id);
  }
}
