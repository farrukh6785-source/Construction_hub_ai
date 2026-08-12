import 'package:flutter/material.dart';

/// -----------------------------------------------------------------
/// Every model below is a plain, dependency-free Dart class. When a
/// real backend is connected, these map almost 1:1 onto Firestore
/// documents / REST payloads — only the repository layer changes.
/// -----------------------------------------------------------------

enum ProjectStatus { planning, running, delayed, completed, onHold }

extension ProjectStatusX on ProjectStatus {
  String get label => switch (this) {
        ProjectStatus.planning => 'Planning',
        ProjectStatus.running => 'Running',
        ProjectStatus.delayed => 'Delayed',
        ProjectStatus.completed => 'Completed',
        ProjectStatus.onHold => 'On Hold',
      };

  Color get color => switch (this) {
        ProjectStatus.planning => const Color(0xFF3B82C4),
        ProjectStatus.running => const Color(0xFF2E9E5B),
        ProjectStatus.delayed => const Color(0xFFD8453C),
        ProjectStatus.completed => const Color(0xFF5B6472),
        ProjectStatus.onHold => const Color(0xFFE0A72E),
      };
}

class ProjectModel {
  ProjectModel({
    required this.id,
    required this.name,
    required this.client,
    required this.location,
    required this.status,
    required this.progress,
    required this.budget,
    required this.spent,
    required this.startDate,
    required this.endDate,
    required this.manager,
    required this.workersOnSite,
  });

  final String id;
  final String name;
  final String client;
  final String location;
  final ProjectStatus status;
  final double progress; // 0..1
  final double budget;
  final double spent;
  final DateTime startDate;
  final DateTime endDate;
  final String manager;
  final int workersOnSite;

  double get budgetRemaining => budget - spent;
}

enum TaskPriority { low, medium, high, urgent }

extension TaskPriorityX on TaskPriority {
  String get label => switch (this) {
        TaskPriority.low => 'Low',
        TaskPriority.medium => 'Medium',
        TaskPriority.high => 'High',
        TaskPriority.urgent => 'Urgent',
      };

  Color get color => switch (this) {
        TaskPriority.low => const Color(0xFF3B82C4),
        TaskPriority.medium => const Color(0xFFE0A72E),
        TaskPriority.high => const Color(0xFFCC8620),
        TaskPriority.urgent => const Color(0xFFD8453C),
      };
}

enum TaskStatus { todo, inProgress, review, done }

extension TaskStatusX on TaskStatus {
  String get label => switch (this) {
        TaskStatus.todo => 'To Do',
        TaskStatus.inProgress => 'In Progress',
        TaskStatus.review => 'In Review',
        TaskStatus.done => 'Done',
      };
}

class TaskModel {
  TaskModel({
    required this.id,
    required this.title,
    required this.projectName,
    required this.assignee,
    required this.priority,
    required this.status,
    required this.dueDate,
    this.description = '',
  });

  final String id;
  final String title;
  final String projectName;
  final String assignee;
  final TaskPriority priority;
  TaskStatus status;
  final DateTime dueDate;
  final String description;
}

class WorkerModel {
  WorkerModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.dailyWage,
    required this.attendanceRate,
    required this.status,
    required this.joinedDate,
  });

  final String id;
  final String name;
  final String role;
  final String phone;
  final double dailyWage;
  final double attendanceRate; // 0..1
  final String status; // Present / Absent / On Leave
  final DateTime joinedDate;
}

class AttendanceRecord {
  AttendanceRecord({
    required this.workerName,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.method,
    required this.status,
  });
  final String workerName;
  final DateTime date;
  final String checkIn;
  final String checkOut;
  final String method; // QR / Manual / GPS
  final String status; // Present / Late / Absent
}

enum StockLevel { ok, low, critical }

class InventoryItem {
  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.currentStock,
    required this.minStock,
    required this.unit,
    required this.unitPrice,
    required this.supplier,
    required this.warehouse,
  });

  final String id;
  final String name;
  final String category;
  final double currentStock;
  final double minStock;
  final String unit;
  final double unitPrice;
  final String supplier;
  final String warehouse;

  StockLevel get level {
    if (currentStock <= minStock * 0.5) return StockLevel.critical;
    if (currentStock <= minStock) return StockLevel.low;
    return StockLevel.ok;
  }
}

class EquipmentModel {
  EquipmentModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.assignedProject,
    required this.lastService,
    required this.nextService,
    required this.fuelLevel,
  });
  final String id;
  final String name;
  final String type;
  final String status; // Available / In Use / Maintenance
  final String assignedProject;
  final DateTime lastService;
  final DateTime nextService;
  final double fuelLevel; // 0..1
}

class SupplierModel {
  SupplierModel({
    required this.id,
    required this.name,
    required this.category,
    required this.contactPerson,
    required this.phone,
    required this.rating,
    required this.totalOrders,
  });
  final String id;
  final String name;
  final String category;
  final String contactPerson;
  final String phone;
  final double rating;
  final int totalOrders;
}

class PurchaseRequest {
  PurchaseRequest({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.requestedBy,
    required this.project,
    required this.status,
    required this.date,
  });
  final String id;
  final String itemName;
  final int quantity;
  final String requestedBy;
  final String project;
  final String status; // Pending / Approved / Rejected / Ordered
  final DateTime date;
}

class ClientModel {
  ClientModel({
    required this.id,
    required this.name,
    required this.company,
    required this.email,
    required this.phone,
    required this.activeProjects,
    required this.totalBilled,
    required this.totalPaid,
  });
  final String id;
  final String name;
  final String company;
  final String email;
  final String phone;
  final int activeProjects;
  final double totalBilled;
  final double totalPaid;

  double get outstanding => totalBilled - totalPaid;
}

enum ExpenseCategory { labor, material, fuel, machinery, utilities, misc }

extension ExpenseCategoryX on ExpenseCategory {
  String get label => switch (this) {
        ExpenseCategory.labor => 'Labor',
        ExpenseCategory.material => 'Material',
        ExpenseCategory.fuel => 'Fuel',
        ExpenseCategory.machinery => 'Machinery',
        ExpenseCategory.utilities => 'Utilities',
        ExpenseCategory.misc => 'Miscellaneous',
      };

  Color get color => switch (this) {
        ExpenseCategory.labor => const Color(0xFF1C4E80),
        ExpenseCategory.material => const Color(0xFFF2A93B),
        ExpenseCategory.fuel => const Color(0xFFD8453C),
        ExpenseCategory.machinery => const Color(0xFF2E9E5B),
        ExpenseCategory.utilities => const Color(0xFF3B82C4),
        ExpenseCategory.misc => const Color(0xFF9AA5B1),
      };
}

class ExpenseModel {
  ExpenseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.project,
    required this.date,
  });
  final String id;
  final String title;
  final ExpenseCategory category;
  final double amount;
  final String project;
  final DateTime date;
}

class DocumentModel {
  DocumentModel({
    required this.id,
    required this.name,
    required this.type,
    required this.project,
    required this.uploadedBy,
    required this.date,
    required this.sizeKb,
  });
  final String id;
  final String name;
  final String type; // Contract / Drawing / Invoice / Permit / Report
  final String project;
  final String uploadedBy;
  final DateTime date;
  final int sizeKb;
}

class GalleryAlbum {
  GalleryAlbum({
    required this.id,
    required this.title,
    required this.project,
    required this.photoCount,
    required this.coverColor,
  });
  final String id;
  final String title;
  final String project;
  final int photoCount;
  final Color coverColor;
}

class AppNotification {
  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.read = false,
  });
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final String type; // task / budget / stock / delay / client / ai
  bool read;
}

class AIInsight {
  AIInsight({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.icon,
  });
  final String id;
  final String title;
  final String description;
  final String severity; // info / warning / critical
  final IconData icon;
}

class ChatMessage {
  ChatMessage({required this.text, required this.isUser, required this.time});
  final String text;
  final bool isUser;
  final DateTime time;
}

class ReportTypeModel {
  ReportTypeModel({required this.id, required this.title, required this.icon, required this.description});
  final String id;
  final String title;
  final IconData icon;
  final String description;
}

class SiteLocationModel {
  SiteLocationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.lat,
    required this.lng,
  });
  final String id;
  final String name;
  final String address;
  final String type; // Project / Supplier / Equipment
  final double lat;
  final double lng;
}
