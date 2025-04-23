class Service {
  final String name;
  final String image;
  final String description;

  Service({required this.name, required this.image, required this.description});
}

List<Service> services = [
  Service(
    name: 'Soil Testing',
    image: 'assets/images/services/seeds.jpg',
    description: 'Soil testing is essential to determine the nutrients and health of soil for optimal farming...',
  ),
  Service(
    name: 'Crop Advisory',
    image: 'assets/images/services/seeds.jpg',
    description: 'Crop advisory provides expert insights on crop planning, disease prevention, and seasonal guidance...',
  ),
  // Add more...
];
