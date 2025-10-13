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
      imageUrl: "c:gatserve\assets\images\vegi.jpg"),
  Food(
      id: 'f3',
      title: 'Fried Egg',
      description: 'Sunny side up eggs',
      price: 15.06,
      imageUrl:
          "https://www.google.com/url?sa=i&url=https%3A%2F%2Fellegourmet.ca%2Fhow-to-make-perfect-fried-egg%2F&psig=AOvVaw0AptjAOlBFb_cIGr1fasnT&ust=1760362749517000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCLjAjLTknpADFQAAAAAdAAAAABAE"),
];
