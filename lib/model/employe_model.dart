// To parse this JSON data, do
//
//     final employees = employeesFromJson(jsonString);

import 'dart:convert';

Employees employeesFromJson(String str) => Employees.fromJson(json.decode(str));

String employeesToJson(Employees data) => json.encode(data.toJson());

class Employees {
    int? status;
    String? message;
    List<Employee>? employeelist;

    Employees({
        this.status,
        this.message,
        this.employeelist,
    });

    factory Employees.fromJson(Map<String, dynamic> json) => Employees(
        status: json["status"],
        message: json["message"],
        employeelist: json["data"] == null ? [] : List<Employee>.from(json["data"]!.map((x) => Employee.fromJson(x))), 
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": employeelist == null ? [] : List<dynamic>.from(employeelist!.map((x) => x.toJson())),
    };
}

class Employee {
    int? id;
    String? name;
    String? role;

    Employee({
        this.id,
        this.name,
        this.role,
    });

    factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json["name"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role": role,
    };
}
