class Transaction {
  final String id;
  final String title;
  final String description;
  final String Category;
  final double amount;
  final DateTime date;
  final double lat;
  final double long;

  Transaction(
      {required this.id,
      required this.title,
      required this.description,
      required this.Category,
      required this.amount,
      required this.date,
      this.lat = 0.0,
      this.long = 0.0,
      });
}
