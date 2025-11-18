class Food {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Food({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

final sampleFoods = [
  Food(
    id: 'f1',
    title: 'Grilled Salmon',
    description: 'Delicious grilled salmon with sides',
    price: 96.00,
    imageUrl:
        'https://images.unsplash.com/photo-1546069901-eacef0df6022?auto=format&fit=crop&w=800&q=60',
  ),
  Food(
      id: 'f2',
      title: 'Meat Vegetable',
      description: 'Healthy meat with fresh veggies',
      price: 65.08,
      imageUrl: 'assets/images/vegi.jpg'),
  Food(
      id: 'f3',
      title: 'Fried Egg',
      description: 'Sunny side up eggs',
      price: 15.06,
      imageUrl: 'assets/images/friedegg.jpeg'),
  Food(
      id: 'f4',
      title: 'Poha',
      description: 'Sunny side up eggs',
      price: 15.06,
      imageUrl: 'assets/images/Poha-Recipe.jpg'),
  Food(
      id: 'f5',
      title: 'vegetable noddles',
      description: 'Sunny side up eggs',
      price: 15.06,
      imageUrl: 'assets/images/noddles.jpg'),
  Food(
      id: 'f6',
      title: 'maggie',
      description: 'Sunny side up eggs',
      price: 15.06,
      imageUrl: 'assets/images/maggie.webp'),
  Food(
      id: 'f7',
      title: 'Gobi rice',
      description: 'Sunny side up eggs',
      price: 15.06,
      imageUrl: 'assets/images/gobirice.jpeg'),
  Food(
      id: 'f8',
      title: 'panner parotha',
      description: 'Sunny side up eggs',
      price: 15.06,
      imageUrl: 'assets/images/paneer_paratha.jpg'),
  Food(
      id: 'f9',
      title: 'Alo parotha',
      description: 'Sunny side up eggs',
      price: 15.06,
      imageUrl: 'assets/images/Poha-Recipe.jpg'),
  Food(
      id: 'f3',
      title: 'idli',
      description: 'Sunny side up eggs',
      price: 15.06,
      imageUrl: 'assets/images/idli_sambar.jpg'),
  Food(
      id: 'f3',
      title: 'Masala Dosa',
      description: 'Sunny side up eggs',
      price: 15.06,
      imageUrl: 'assets/images/Masala_Dosa.jpg'),
];
