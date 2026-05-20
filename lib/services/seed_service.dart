import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/menu_item_model.dart';
import '../models/restaurant_model.dart';
import '../models/restaurant_table_model.dart';
import '../utils/app_constants.dart';

class SeedService {
  SeedService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> seedDemoData() async {
    final restaurantRef = _firestore.collection('restaurants').doc(AppConstants.restaurantId);
    final restaurantDoc = await restaurantRef.get();
    if (restaurantDoc.exists) return;

    final batch = _firestore.batch();
    const restaurant = RestaurantModel(
      id: AppConstants.restaurantId,
      name: 'TableNow Bistro',
      address: '72 Le Thanh Ton, Quan 1, TP. Ho Chi Minh',
      phone: '0909 123 456',
      openTime: '08:00',
      closeTime: '22:00',
      description: 'Nha hang am cung voi mon A-Au hien dai, phu hop hen ho, gia dinh va tiec nho.',
      imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
      latitude: 10.7789,
      longitude: 106.7021,
    );
    batch.set(restaurantRef, restaurant.toMap());

    final menu = <MenuItemModel>[
      _item('pho-bo', 'Pho bo dac biet', 'Mon chinh', 85000),
      _item('bun-cha', 'Bun cha Ha Noi', 'Mon chinh', 79000),
      _item('com-ga', 'Com ga Hoi An', 'Mon chinh', 89000),
      _item('salad-ca-hoi', 'Salad ca hoi', 'Khai vi', 129000),
      _item('cha-gio', 'Cha gio hai san', 'Khai vi', 69000),
      _item('bo-luc-lac', 'Bo luc lac khoai tay', 'Mon chinh', 159000),
      _item('mi-y', 'Mi Y sot bo bam', 'Mon chinh', 119000),
      _item('tra-dao', 'Tra dao cam sa', 'Do uong', 39000),
      _item('ca-phe-sua', 'Ca phe sua da', 'Do uong', 35000),
      _item('che-khuc-bach', 'Che khuc bach', 'Trang mieng', 49000),
    ];
    for (final item in menu) {
      batch.set(_firestore.collection('menu_items').doc(item.id), item.toMap());
    }

    for (var index = 1; index <= 6; index++) {
      final table = RestaurantTableModel(id: 'table-$index', restaurantId: AppConstants.restaurantId, tableName: 'Ban $index', capacity: index <= 2 ? 2 : index <= 4 ? 4 : 8, status: 'available');
      batch.set(_firestore.collection('restaurant_tables').doc(table.id), table.toMap());
    }

    await batch.commit();
  }

  MenuItemModel _item(String id, String name, String category, double price) => MenuItemModel(
    id: id,
    restaurantId: AppConstants.restaurantId,
    name: name,
    category: category,
    price: price,
    description: 'Mon $name duoc chuan bi moi moi ngay, phu hop dat truoc khi den nha hang.',
    imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
    isAvailable: true,
  );
}


