import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock_models.dart';

/// One seeded, in-memory "database" for the whole app. Every module
/// reads from here through Riverpod providers below. Mutating methods
/// (addProject, updateTaskStatus, ...) call notifyListeners() so every
/// screen watching stays in sync — the same shape a real repository
/// backed by Firestore streams would have, just without a network.
class MockDataService extends ChangeNotifier {
  MockDataService() {
    _seed();
  }

  late List<ProjectModel> projects;
  late List<TaskModel> tasks;
  late List<WorkerModel> workers;
  late List<AttendanceRecord> attendance;
  late List<InventoryItem> inventory;
  late List<EquipmentModel> equipment;
  late List<SupplierModel> suppliers;
  late List<PurchaseRequest> purchaseRequests;
  late List<ClientModel> clients;
  late List<ExpenseModel> expenses;
  late List<DocumentModel> documents;
  late List<GalleryAlbum> albums;
  late List<AppNotification> notifications;
  late List<AIInsight> aiInsights;
  late List<ReportTypeModel> reportTypes;
  late List<SiteLocationModel> locations;
  final List<ChatMessage> chatMessages = [];

  void _seed() {
    final now = DateTime.now();

    projects = [
      ProjectModel(
        id: 'P-001',
        name: 'Skyline Residency Tower',
        client: 'Farrukh Raza',
        location: 'Gulberg, Lahore',
        status: ProjectStatus.running,
        progress: 0.62,
        budget: 850000000,
        spent: 512000000,
        startDate: now.subtract(const Duration(days: 210)),
        endDate: now.add(const Duration(days: 240)),
        manager: 'Bilal Ahmed',
        workersOnSite: 84,
      ),
      ProjectModel(
        id: 'P-002',
        name: 'Riverfront Commercial Plaza',
        client: 'Al-Noor Group',
        location: 'DHA Phase 6, Lahore',
        status: ProjectStatus.delayed,
        progress: 0.34,
        budget: 420000000,
        spent: 198000000,
        startDate: now.subtract(const Duration(days: 150)),
        endDate: now.add(const Duration(days: 60)),
        manager: 'Sara Khan',
        workersOnSite: 41,
      ),
      ProjectModel(
        id: 'P-003',
        name: 'Greenfield Industrial Warehouse',
        client: 'Mushi Khan',
        location: 'Sundar Estate, Lahore',
        status: ProjectStatus.planning,
        progress: 0.08,
        budget: 260000000,
        spent: 12000000,
        startDate: now.add(const Duration(days: 20)),
        endDate: now.add(const Duration(days: 320)),
        manager: 'Usman Tariq',
        workersOnSite: 6,
      ),
      ProjectModel(
        id: 'P-004',
        name: 'Cedar Heights Villas — Phase 2',
        client: 'John Raza',
        location: 'Bahria Town, Lahore',
        status: ProjectStatus.completed,
        progress: 1.0,
        budget: 175000000,
        spent: 168500000,
        startDate: now.subtract(const Duration(days: 420)),
        endDate: now.subtract(const Duration(days: 15)),
        manager: 'Bilal Ahmed',
        workersOnSite: 0,
      ),
      ProjectModel(
        id: 'P-005',
        name: 'Northgate Overpass Widening',
        client: 'Punjab Highways Authority',
        location: 'Ferozepur Road, Lahore',
        status: ProjectStatus.onHold,
        progress: 0.45,
        budget: 610000000,
        spent: 270000000,
        startDate: now.subtract(const Duration(days: 300)),
        endDate: now.add(const Duration(days: 90)),
        manager: 'Sara Khan',
        workersOnSite: 12,
      ),
    ];

    tasks = [
      TaskModel(id: 'T-101', title: 'Pour foundation slab — Block C', projectName: 'Skyline Residency Tower', assignee: 'Imran Malik', priority: TaskPriority.high, status: TaskStatus.inProgress, dueDate: now.add(const Duration(days: 2)), description: 'Coordinate concrete delivery with 3 mixer trucks, ensure rebar inspection is signed off first.'),
      TaskModel(id: 'T-102', title: 'Electrical conduit rough-in — Floor 8', projectName: 'Skyline Residency Tower', assignee: 'Faisal Raza', priority: TaskPriority.medium, status: TaskStatus.todo, dueDate: now.add(const Duration(days: 5))),
      TaskModel(id: 'T-103', title: 'Facade glass panel install', projectName: 'Riverfront Commercial Plaza', assignee: 'Zainab Sheikh', priority: TaskPriority.urgent, status: TaskStatus.review, dueDate: now.add(const Duration(days: 1)), description: 'Blocked on crane availability — coordinate with equipment module.'),
      TaskModel(id: 'T-104', title: 'Site survey & soil testing', projectName: 'Greenfield Industrial Warehouse', assignee: 'Usman Tariq', priority: TaskPriority.low, status: TaskStatus.done, dueDate: now.subtract(const Duration(days: 3))),
      TaskModel(id: 'T-105', title: 'HVAC ductwork — Basement', projectName: 'Riverfront Commercial Plaza', assignee: 'Ahsan Iqbal', priority: TaskPriority.medium, status: TaskStatus.inProgress, dueDate: now.add(const Duration(days: 7))),
      TaskModel(id: 'T-106', title: 'Safety audit — full site', projectName: 'Northgate Overpass Widening', assignee: 'Sara Khan', priority: TaskPriority.high, status: TaskStatus.todo, dueDate: now.add(const Duration(days: 3))),
    ];

    workers = [
      WorkerModel(id: 'W-01', name: 'Imran Malik', role: 'Mason Foreman', phone: '0300-1234567', dailyWage: 2400, attendanceRate: 0.96, status: 'Present', joinedDate: now.subtract(const Duration(days: 640))),
      WorkerModel(id: 'W-02', name: 'Faisal Raza', role: 'Electrician', phone: '0301-2345678', dailyWage: 2100, attendanceRate: 0.91, status: 'Present', joinedDate: now.subtract(const Duration(days: 400))),
      WorkerModel(id: 'W-03', name: 'Zainab Sheikh', role: 'Site Engineer', phone: '0302-3456789', dailyWage: 4200, attendanceRate: 0.98, status: 'Present', joinedDate: now.subtract(const Duration(days: 900))),
      WorkerModel(id: 'W-04', name: 'Ahsan Iqbal', role: 'Plumber', phone: '0303-4567890', dailyWage: 1900, attendanceRate: 0.84, status: 'On Leave', joinedDate: now.subtract(const Duration(days: 260))),
      WorkerModel(id: 'W-05', name: 'Kamran Ali', role: 'Laborer', phone: '0304-5678901', dailyWage: 1400, attendanceRate: 0.79, status: 'Absent', joinedDate: now.subtract(const Duration(days: 120))),
      WorkerModel(id: 'W-06', name: 'Hina Younis', role: 'Surveyor', phone: '0305-6789012', dailyWage: 2600, attendanceRate: 0.93, status: 'Present', joinedDate: now.subtract(const Duration(days: 510))),
    ];

    attendance = List.generate(6, (i) {
      final w = workers[i];
      return AttendanceRecord(
        workerName: w.name,
        date: now,
        checkIn: w.status == 'Absent' ? '--' : '07:${(10 + i * 3).toString().padLeft(2, '0')} AM',
        checkOut: w.status == 'Absent' ? '--' : '05:${(15 + i * 2).toString().padLeft(2, '0')} PM',
        method: ['QR', 'Manual', 'GPS'][i % 3],
        status: w.status == 'Absent' ? 'Absent' : (i == 3 ? 'Late' : 'Present'),
      );
    });

    inventory = [
      InventoryItem(id: 'INV-01', name: 'Portland Cement (50kg)', category: 'Cement', currentStock: 1840, minStock: 1000, unit: 'bags', unitPrice: 1450, supplier: 'Lucky Cement Distributors', warehouse: 'Site Warehouse A'),
      InventoryItem(id: 'INV-02', name: 'Deformed Steel Bar 12mm', category: 'Steel', currentStock: 320, minStock: 500, unit: 'tons', unitPrice: 268000, supplier: 'Amreli Steels', warehouse: 'Site Warehouse A'),
      InventoryItem(id: 'INV-03', name: 'Red Clay Bricks', category: 'Bricks', currentStock: 92000, minStock: 40000, unit: 'pcs', unitPrice: 14, supplier: 'Ravi Brick Works', warehouse: 'Site Warehouse B'),
      InventoryItem(id: 'INV-04', name: 'River Sand', category: 'Sand', currentStock: 180, minStock: 300, unit: 'tons', unitPrice: 3200, supplier: 'Chenab Aggregates', warehouse: 'Site Warehouse B'),
      InventoryItem(id: 'INV-05', name: 'Weather Shield Emulsion Paint', category: 'Paint', currentStock: 45, minStock: 100, unit: 'drums', unitPrice: 18500, supplier: 'ICI Paints', warehouse: 'Central Store'),
      InventoryItem(id: 'INV-06', name: 'PVC Conduit Pipe 25mm', category: 'Electrical', currentStock: 2600, minStock: 800, unit: 'meters', unitPrice: 95, supplier: 'Pakistan Cables', warehouse: 'Central Store'),
      InventoryItem(id: 'INV-07', name: 'CPVC Plumbing Pipe 1"', category: 'Plumbing', currentStock: 210, minStock: 250, unit: 'meters', unitPrice: 340, supplier: 'Dadex Eternit', warehouse: 'Central Store'),
      InventoryItem(id: 'INV-08', name: 'Structural Bolts M16', category: 'Hardware', currentStock: 5400, minStock: 2000, unit: 'pcs', unitPrice: 65, supplier: 'National Hardware Co.', warehouse: 'Site Warehouse A'),
    ];

    equipment = [
      EquipmentModel(id: 'EQ-01', name: 'Tower Crane TC-04', type: 'Crane', status: 'In Use', assignedProject: 'Skyline Residency Tower', lastService: now.subtract(const Duration(days: 40)), nextService: now.add(const Duration(days: 20)), fuelLevel: 0.0),
      EquipmentModel(id: 'EQ-02', name: 'CAT 320 Excavator', type: 'Excavator', status: 'In Use', assignedProject: 'Riverfront Commercial Plaza', lastService: now.subtract(const Duration(days: 15)), nextService: now.add(const Duration(days: 45)), fuelLevel: 0.62),
      EquipmentModel(id: 'EQ-03', name: 'Concrete Mixer Truck #3', type: 'Mixer', status: 'Available', assignedProject: '—', lastService: now.subtract(const Duration(days: 5)), nextService: now.add(const Duration(days: 55)), fuelLevel: 0.88),
      EquipmentModel(id: 'EQ-04', name: 'Bulldozer D6', type: 'Bulldozer', status: 'Maintenance', assignedProject: '—', lastService: now.subtract(const Duration(days: 2)), nextService: now.add(const Duration(days: 2)), fuelLevel: 0.3),
      EquipmentModel(id: 'EQ-05', name: 'Diesel Generator 250kVA', type: 'Generator', status: 'In Use', assignedProject: 'Northgate Overpass Widening', lastService: now.subtract(const Duration(days: 60)), nextService: now.add(const Duration(days: 10)), fuelLevel: 0.44),
      EquipmentModel(id: 'EQ-06', name: 'Dump Truck #7', type: 'Truck', status: 'Available', assignedProject: '—', lastService: now.subtract(const Duration(days: 20)), nextService: now.add(const Duration(days: 40)), fuelLevel: 0.71),
    ];

    suppliers = [
      SupplierModel(id: 'SUP-01', name: 'Lucky Cement Distributors', category: 'Cement', contactPerson: 'Adeel Farooq', phone: '042-111222333', rating: 4.6, totalOrders: 128),
      SupplierModel(id: 'SUP-02', name: 'Amreli Steels', category: 'Steel', contactPerson: 'Nadia Chaudhry', phone: '042-111333444', rating: 4.8, totalOrders: 94),
      SupplierModel(id: 'SUP-03', name: 'Ravi Brick Works', category: 'Bricks', contactPerson: 'Shahzad Iqbal', phone: '0321-9988776', rating: 4.2, totalOrders: 61),
      SupplierModel(id: 'SUP-04', name: 'ICI Paints', category: 'Paint', contactPerson: 'Mehreen Aslam', phone: '042-111444555', rating: 4.5, totalOrders: 37),
      SupplierModel(id: 'SUP-05', name: 'Pakistan Cables', category: 'Electrical', contactPerson: 'Waqas Hassan', phone: '042-111555666', rating: 4.4, totalOrders: 52),
    ];

    purchaseRequests = [
      PurchaseRequest(id: 'PR-501', itemName: 'Deformed Steel Bar 12mm — 200 tons', quantity: 200, requestedBy: 'Zainab Sheikh', project: 'Riverfront Commercial Plaza', status: 'Pending', date: now.subtract(const Duration(days: 1))),
      PurchaseRequest(id: 'PR-502', itemName: 'River Sand — 150 tons', quantity: 150, requestedBy: 'Imran Malik', project: 'Skyline Residency Tower', status: 'Approved', date: now.subtract(const Duration(days: 3))),
      PurchaseRequest(id: 'PR-503', itemName: 'Weather Shield Paint — 60 drums', quantity: 60, requestedBy: 'Ahsan Iqbal', project: 'Cedar Heights Villas — Phase 2', status: 'Ordered', date: now.subtract(const Duration(days: 6))),
      PurchaseRequest(id: 'PR-504', itemName: 'CPVC Pipe 1" — 500 meters', quantity: 500, requestedBy: 'Faisal Raza', project: 'Skyline Residency Tower', status: 'Rejected', date: now.subtract(const Duration(days: 8))),
    ];

    clients = [
      ClientModel(id: 'CL-01', name: 'Meridian Holdings', company: 'Meridian Holdings Pvt Ltd', email: 'contact@meridianholdings.com', phone: '042-35678901', activeProjects: 1, totalBilled: 512000000, totalPaid: 480000000),
      ClientModel(id: 'CL-02', name: 'Al-Noor Group', company: 'Al-Noor Group of Companies', email: 'projects@alnoorgroup.com', phone: '042-35789012', activeProjects: 1, totalBilled: 198000000, totalPaid: 160000000),
      ClientModel(id: 'CL-03', name: 'Atlas Logistics', company: 'Atlas Logistics International', email: 'info@atlaslogistics.pk', phone: '042-35890123', activeProjects: 1, totalBilled: 12000000, totalPaid: 12000000),
      ClientModel(id: 'CL-04', name: 'Punjab Highways Authority', company: 'Government of Punjab', email: 'pha.projects@punjab.gov.pk', phone: '042-99201234', activeProjects: 1, totalBilled: 270000000, totalPaid: 245000000),
    ];

    expenses = [
      ExpenseModel(id: 'EX-01', title: 'Weekly labor wages', category: ExpenseCategory.labor, amount: 4200000, project: 'Skyline Residency Tower', date: now.subtract(const Duration(days: 2))),
      ExpenseModel(id: 'EX-02', title: 'Steel bar procurement', category: ExpenseCategory.material, amount: 18500000, project: 'Riverfront Commercial Plaza', date: now.subtract(const Duration(days: 5))),
      ExpenseModel(id: 'EX-03', title: 'Diesel refuel — generators', category: ExpenseCategory.fuel, amount: 620000, project: 'Northgate Overpass Widening', date: now.subtract(const Duration(days: 1))),
      ExpenseModel(id: 'EX-04', title: 'Crane maintenance service', category: ExpenseCategory.machinery, amount: 340000, project: 'Skyline Residency Tower', date: now.subtract(const Duration(days: 9))),
      ExpenseModel(id: 'EX-05', title: 'Site electricity & water', category: ExpenseCategory.utilities, amount: 185000, project: 'Riverfront Commercial Plaza', date: now.subtract(const Duration(days: 3))),
      ExpenseModel(id: 'EX-06', title: 'Site office supplies', category: ExpenseCategory.misc, amount: 42000, project: 'Greenfield Industrial Warehouse', date: now.subtract(const Duration(days: 4))),
      ExpenseModel(id: 'EX-07', title: 'Cement bulk order', category: ExpenseCategory.material, amount: 9200000, project: 'Skyline Residency Tower', date: now.subtract(const Duration(days: 12))),
    ];

    documents = [
      DocumentModel(id: 'DOC-01', name: 'Skyline Tower — Construction Contract.pdf', type: 'Contract', project: 'Skyline Residency Tower', uploadedBy: 'Bilal Ahmed', date: now.subtract(const Duration(days: 200)), sizeKb: 2400),
      DocumentModel(id: 'DOC-02', name: 'Floor 8 Electrical Drawing Rev C.dwg', type: 'Drawing', project: 'Skyline Residency Tower', uploadedBy: 'Faisal Raza', date: now.subtract(const Duration(days: 12)), sizeKb: 8600),
      DocumentModel(id: 'DOC-03', name: 'Steel Bar Invoice — Amreli.pdf', type: 'Invoice', project: 'Riverfront Commercial Plaza', uploadedBy: 'Sara Khan', date: now.subtract(const Duration(days: 5)), sizeKb: 340),
      DocumentModel(id: 'DOC-04', name: 'Municipal Building Permit.pdf', type: 'Permit', project: 'Greenfield Industrial Warehouse', uploadedBy: 'Usman Tariq', date: now.subtract(const Duration(days: 30)), sizeKb: 1200),
      DocumentModel(id: 'DOC-05', name: 'Weekly Safety Inspection Report.pdf', type: 'Report', project: 'Northgate Overpass Widening', uploadedBy: 'Sara Khan', date: now.subtract(const Duration(days: 2)), sizeKb: 980),
    ];

    albums = [
      GalleryAlbum(id: 'AL-01', title: 'Foundation Works', project: 'Skyline Residency Tower', photoCount: 46, coverColor: const Color(0xFF1C4E80)),
      GalleryAlbum(id: 'AL-02', title: 'Facade Progress', project: 'Riverfront Commercial Plaza', photoCount: 28, coverColor: const Color(0xFFF2A93B)),
      GalleryAlbum(id: 'AL-03', title: 'Site Survey & Drone Shots', project: 'Greenfield Industrial Warehouse', photoCount: 15, coverColor: const Color(0xFF2E9E5B)),
      GalleryAlbum(id: 'AL-04', title: 'Handover Walkthrough', project: 'Cedar Heights Villas — Phase 2', photoCount: 62, coverColor: const Color(0xFFD8453C)),
    ];

    notifications = [
      AppNotification(id: 'N-01', title: 'Task assigned', body: 'You were assigned "Facade glass panel install".', time: now.subtract(const Duration(minutes: 20)), type: 'task'),
      AppNotification(id: 'N-02', title: 'Budget alert', body: 'Riverfront Commercial Plaza has used 47% of budget at 34% progress.', time: now.subtract(const Duration(hours: 2)), type: 'budget'),
      AppNotification(id: 'N-03', title: 'Low stock', body: 'River Sand is below minimum stock (180/300 tons).', time: now.subtract(const Duration(hours: 5)), type: 'stock'),
      AppNotification(id: 'N-04', title: 'Project delay predicted', body: 'AI forecasts a 12-day delay on Riverfront Commercial Plaza.', time: now.subtract(const Duration(hours: 8)), type: 'delay', read: true),
      AppNotification(id: 'N-05', title: 'Client message', body: 'Meridian Holdings sent a new message about Floor 8 fit-out.', time: now.subtract(const Duration(days: 1)), type: 'client', read: true),
      AppNotification(id: 'N-06', title: 'Equipment service due', body: 'Bulldozer D6 is due for maintenance in 2 days.', time: now.subtract(const Duration(days: 1, hours: 4)), type: 'stock', read: true),
    ];

    aiInsights = [
      AIInsight(id: 'AI-01', title: 'Delay risk: Riverfront Commercial Plaza', description: 'Facade procurement lag and crane contention suggest a 10–14 day slip against the current milestone schedule.', severity: 'critical', icon: Icons.trending_down_rounded),
      AIInsight(id: 'AI-02', title: 'Budget forecast on track', description: 'Skyline Residency Tower is projected to finish within 3% of approved budget at current burn rate.', severity: 'info', icon: Icons.savings_outlined),
      AIInsight(id: 'AI-03', title: 'Material reorder suggested', description: 'Steel bar 12mm and river sand will fall below safety stock within 9 days at current consumption.', severity: 'warning', icon: Icons.inventory_2_outlined),
      AIInsight(id: 'AI-04', title: 'Labor productivity up 6%', description: 'Mason crews on Skyline Residency Tower are completing slab pours 6% faster than last month\'s average.', severity: 'info', icon: Icons.trending_up_rounded),
    ];

    reportTypes = [
      ReportTypeModel(id: 'RT-01', title: 'Attendance Report', icon: Icons.fingerprint, description: 'Daily/monthly attendance by worker and project'),
      ReportTypeModel(id: 'RT-02', title: 'Project Progress Report', icon: Icons.timeline_outlined, description: 'Milestones, delays, and completion by project'),
      ReportTypeModel(id: 'RT-03', title: 'Budget & Expense Report', icon: Icons.account_balance_wallet_outlined, description: 'Spend vs. budget across all active projects'),
      ReportTypeModel(id: 'RT-04', title: 'Inventory Report', icon: Icons.inventory_2_outlined, description: 'Stock levels, movement, and low-stock items'),
      ReportTypeModel(id: 'RT-05', title: 'Equipment Utilization', icon: Icons.precision_manufacturing_outlined, description: 'Usage hours, service schedule, and downtime'),
      ReportTypeModel(id: 'RT-06', title: 'Client Billing Report', icon: Icons.receipt_long_outlined, description: 'Invoices, payments, and outstanding balances'),
    ];

    locations = [
      SiteLocationModel(id: 'L-01', name: 'Skyline Residency Tower', address: 'Gulberg, Lahore', type: 'Project', lat: 31.5204, lng: 74.3587),
      SiteLocationModel(id: 'L-02', name: 'Riverfront Commercial Plaza', address: 'DHA Phase 6, Lahore', type: 'Project', lat: 31.4697, lng: 74.4142),
      SiteLocationModel(id: 'L-03', name: 'Lucky Cement Distributors', address: 'Multan Road, Lahore', type: 'Supplier', lat: 31.4504, lng: 74.2856),
      SiteLocationModel(id: 'L-04', name: 'Tower Crane TC-04', address: 'On-site — Skyline Tower', type: 'Equipment', lat: 31.5210, lng: 74.3590),
    ];
  }

  // ---- Mutations (all in-memory, all notify listeners) ----

  void addProject(ProjectModel project) {
    projects = [project, ...projects];
    notifyListeners();
  }

  void addTask(TaskModel task) {
    tasks = [task, ...tasks];
    notifyListeners();
  }

  void updateTaskStatus(String taskId, TaskStatus status) {
    final task = tasks.firstWhere((t) => t.id == taskId);
    task.status = status;
    notifyListeners();
  }

  void addPurchaseRequest(PurchaseRequest request) {
    purchaseRequests = [request, ...purchaseRequests];
    notifyListeners();
  }

  void markNotificationRead(String id) {
    final n = notifications.firstWhere((n) => n.id == id);
    n.read = true;
    notifyListeners();
  }

  void markAllNotificationsRead() {
    for (final n in notifications) {
      n.read = true;
    }
    notifyListeners();
  }

  void sendChatMessage(String text) {
    chatMessages.add(ChatMessage(text: text, isUser: true, time: DateTime.now()));
    notifyListeners();
    // Mock "AI" reply — canned but topic-aware, no network call.
    Future.delayed(const Duration(milliseconds: 700), () {
      chatMessages.add(ChatMessage(text: _mockAiReply(text), isUser: false, time: DateTime.now()));
      notifyListeners();
    });
  }

  String _mockAiReply(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains('delay')) {
      return 'Based on current progress, Riverfront Commercial Plaza is the highest delay risk — facade procurement and crane scheduling are the main bottlenecks. Want me to draft a mitigation plan?';
    }
    if (lower.contains('budget') || lower.contains('cost')) {
      return 'Across all active projects you\'ve spent PKR 992M of PKR 2.15B approved budget (46%). Skyline Residency Tower is tracking closest to plan.';
    }
    if (lower.contains('stock') || lower.contains('material')) {
      return 'River Sand and Steel Bar 12mm are both trending toward low stock within 9 days. I\'d suggest raising a purchase request for both this week.';
    }
    return 'Got it — I\'ve noted that. In the full build, this would call Gemini with your live project data to give a grounded answer instead of this canned one.';
  }

  int get lowStockCount => inventory.where((i) => i.level != StockLevel.ok).length;
  int get runningProjectsCount => projects.where((p) => p.status == ProjectStatus.running).length;
  int get delayedProjectsCount => projects.where((p) => p.status == ProjectStatus.delayed).length;
  int get completedProjectsCount => projects.where((p) => p.status == ProjectStatus.completed).length;
  double get totalBudget => projects.fold(0, (sum, p) => sum + p.budget);
  double get totalSpent => projects.fold(0, (sum, p) => sum + p.spent);
  int get unreadNotificationsCount => notifications.where((n) => !n.read).length;
}

final mockDataProvider = ChangeNotifierProvider<MockDataService>((ref) => MockDataService());