class OrderItemFullModel {
  final String name;
  final String price;
  final DateTime createTime;

  OrderItemFullModel(this.name, this.price, this.createTime);

  OrderItemFullModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        price = json['price'],
        createTime = DateTime.parse(json['createTime']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'createTime': createTime.toIso8601String(),
      };
}
