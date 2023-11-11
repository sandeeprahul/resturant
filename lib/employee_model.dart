class Employee {
  final String id;
  final String name;
  final String designation;
  final String empPin;
  final String email;
  final String phone;
  final String joiningDate;
  final String resignationDate;
  final String address;
  final String bloodGroup;
  final String image;
  final String sorting;
  final String status;
  final String createdAt;
  final String updatedAt;

  Employee({
    required this.id,
    required this.name,
    required this.designation,
    required this.empPin,
    required this.email,
    required this.phone,
    required this.joiningDate,
    required this.resignationDate,
    required this.address,
    required this.bloodGroup,
    required this.image,
    required this.sorting,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      designation: json['designation'] ?? '',
      empPin: json['emp_pin'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      joiningDate: json['joining_date'] ?? '',
      resignationDate: json['resignation_date'] ?? '',
      address: json['address'] ?? '',
      bloodGroup: json['blood_group'] ?? '',
      image: json['image'] ?? '',
      sorting: json['sorting'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
