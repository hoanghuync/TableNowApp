import '../../models/rustic_models.dart';

class MockData {
  static final now = DateTime.now();

  static final currentUser = RusticUser(uid: 'demo-customer', fullName: 'Nguyen Van A', email: 'customer@rustic.dev', phone: '090 123 4567', avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80', role: 'customer', membershipLevel: 'Thanh vien Vang', points: 2500, createdAt: now, updatedAt: now);
  static final adminUser = RusticUser(uid: 'demo-admin', fullName: 'Rustic Admin', email: 'admin@rustic.dev', phone: '090 999 0000', avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80', role: 'admin', membershipLevel: 'Staff', points: 0, createdAt: now, updatedAt: now);

  static final categories = <CategoryModel>[
    const CategoryModel(id: 'all', name: 'Tat ca', slug: 'all', sortOrder: 0),
    const CategoryModel(id: 'combo', name: 'Combo', slug: 'combo', sortOrder: 1),
    const CategoryModel(id: 'main', name: 'Mon chinh', slug: 'main', sortOrder: 2),
    const CategoryModel(id: 'pasta', name: 'Pasta', slug: 'pasta', sortOrder: 3),
    const CategoryModel(id: 'dessert', name: 'Trang mieng', slug: 'dessert', sortOrder: 4),
    const CategoryModel(id: 'drink', name: 'Do uong', slug: 'drink', sortOrder: 5),
  ];

  static final menuItems = <MenuItemModel2>[
    MenuItemModel2(id: 'risotto', name: 'Truffle Risotto', description: 'Su ket hop hoan hao giua nam truffle den va pho mai Parmesan thuong hang.', price: 420000, categoryId: 'main', imageUrl: 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?auto=format&fit=crop&w=900&q=80', rating: 4.9, totalReviews: 122, isSignature: true, isRecommended: true, tags: const ['signature'], createdAt: now, updatedAt: now),
    MenuItemModel2(id: 'ribeye', name: 'Wood-Fired Ribeye', description: 'Than lung bo My nuong cui, sot bo thao moc dam da.', price: 450000, categoryId: 'main', imageUrl: 'https://images.unsplash.com/photo-1558030006-450675393462?auto=format&fit=crop&w=900&q=80', rating: 4.8, totalReviews: 98, isRecommended: true, tags: const ['steak'], createdAt: now, updatedAt: now),
    MenuItemModel2(id: 'combo-fuji', name: 'Combo Bo Fuji Nuong Da', description: 'Than bo Fuji thuong hang nuong tren da muoi Himalaya, kem mang tay, khoai tay nghien.', price: 549000, categoryId: 'combo', imageUrl: 'https://images.unsplash.com/photo-1600891964092-4316c288032e?auto=format&fit=crop&w=900&q=80', rating: 4.8, totalReviews: 76, isRecommended: true, createdAt: now, updatedAt: now),
    MenuItemModel2(id: 'pasta-seafood', name: 'Pasta Hai San Sot Ca', description: 'Mi Y tuoi lam thu cong ket hop hai san tuoi song va sot ca chua thao moc.', price: 285000, categoryId: 'pasta', imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=900&q=80', rating: 4.5, totalReviews: 64, createdAt: now, updatedAt: now),
    MenuItemModel2(id: 'lava', name: 'Chocolate Lava Cake', description: 'Banh socola nuong nong voi nhan tan chay, dung kem vani hat tu nhien.', price: 125000, categoryId: 'dessert', imageUrl: 'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?auto=format&fit=crop&w=900&q=80', rating: 4.7, totalReviews: 57, createdAt: now, updatedAt: now),
    MenuItemModel2(id: 'fizz', name: 'Rosemary Citrus Fizz', description: 'Mocktail sang khoai voi huong thao moc tuoi, cam vang say va soda sui bot nhe.', price: 85000, categoryId: 'drink', imageUrl: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?auto=format&fit=crop&w=900&q=80', rating: 4.6, totalReviews: 31, createdAt: now, updatedAt: now),
    MenuItemModel2(id: 'salad', name: 'Salad Vuon Tuoi Mat', description: 'Xa lach hon hop, ca chua bi, dua chuot, sot chanh leo.', price: 120000, categoryId: 'main', imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=80', rating: 4.5, totalReviews: 42, createdAt: now, updatedAt: now),
    MenuItemModel2(id: 'wine', name: 'Ruou vang do Cabernet Sauvignon', description: 'Huong vi dam da, phu hop voi cac mon thit do.', price: 150000, categoryId: 'drink', imageUrl: 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?auto=format&fit=crop&w=900&q=80', rating: 4.8, totalReviews: 25, createdAt: now, updatedAt: now),
  ];

  static final promotions = <PromotionModel>[
    PromotionModel(id: 'happy-hour', title: 'Happy Hour - Giam 30%', description: 'Cac loai cocktail tu 16:00 - 18:00', discountType: 'percent', discountValue: 30, startTime: now, endTime: now.add(const Duration(days: 7)), iconType: 'martini'),
    PromotionModel(id: 'birthday-dessert', title: 'Tang Trang Mieng', description: 'Danh cho ban dat truoc sinh nhat', discountType: 'fixed', discountValue: 125000, startTime: now, endTime: now.add(const Duration(days: 30)), iconType: 'cake'),
  ];

  static final tables = <RestaurantTableModel2>[
    const RestaurantTableModel2(id: 't1', tableName: 'T1', capacity: 4, status: 'occupied', positionX: 70, positionY: 110),
    const RestaurantTableModel2(id: 't2', tableName: 'T2', capacity: 2, status: 'available', positionX: 150, positionY: 110),
    const RestaurantTableModel2(id: 't3', tableName: 'T3', capacity: 6, status: 'reserved', positionX: 250, positionY: 110, shape: 'rect'),
    const RestaurantTableModel2(id: 't4', tableName: 'T4', capacity: 4, status: 'available', positionX: 70, positionY: 245, shape: 'rect'),
    const RestaurantTableModel2(id: 't5', tableName: 'T5', capacity: 2, status: 'occupied', positionX: 180, positionY: 245, shape: 'rect'),
    const RestaurantTableModel2(id: 't6', tableName: 'T6', capacity: 6, status: 'reserved', positionX: 150, positionY: 355),
  ];

  static final bookings = <BookingModel2>[
    BookingModel2(id: 'b1', userId: 'demo-customer', customerName: 'Nguyen Van A', customerPhone: '090 123 4567', tableId: 't2', numberOfGuests: 2, bookingDate: now, bookingTime: '19:00', note: 'Cua so', status: 'confirmed', createdAt: now, updatedAt: now),
    BookingModel2(id: 'b2', userId: 'demo-customer', customerName: 'Nguyen Van A', customerPhone: '090 123 4567', tableId: 't4', numberOfGuests: 4, bookingDate: now.subtract(const Duration(days: 3)), bookingTime: '20:00', note: 'Phong rieng', status: 'completed', createdAt: now, updatedAt: now),
    BookingModel2(id: 'b3', userId: 'guest', customerName: 'Eleanor Vance', customerPhone: '091 222 3333', tableId: 't1', numberOfGuests: 4, bookingDate: now, bookingTime: '19:30', note: '', status: 'pending', createdAt: now, updatedAt: now),
    BookingModel2(id: 'b4', userId: 'guest', customerName: 'Marcus Thorne', customerPhone: '091 555 7777', tableId: 't3', numberOfGuests: 2, bookingDate: now.add(const Duration(days: 1)), bookingTime: '20:00', note: 'VIP Guest', status: 'pending', createdAt: now, updatedAt: now),
  ];

  static final orders = <OrderModel2>[
    OrderModel2(id: 'o1', userId: 'demo-customer', items: [CartItemModel(itemId: 'ribeye', name: 'Bo bit tet than ngoai', price: 450000, quantity: 1, imageUrl: menuItems[1].imageUrl, addedAt: now)], subtotal: 450000, discount: 0, totalAmount: 450000, status: 'completed', paymentStatus: 'paid', createdAt: now, completedAt: now),
    OrderModel2(id: 'o2', userId: 'demo-customer', items: [CartItemModel(itemId: 'wine', name: 'Ruou vang do Cabernet Sauvignon', price: 150000, quantity: 1, imageUrl: menuItems[7].imageUrl, addedAt: now)], subtotal: 150000, discount: 0, totalAmount: 150000, status: 'completed', paymentStatus: 'paid', createdAt: now, completedAt: now),
  ];
}
