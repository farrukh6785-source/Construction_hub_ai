# ConstructionHub AI — Full App (Mock Data, Android + Web)

A complete, navigable build of every module from the original spec,
running entirely on **in-memory mock data** — no Firebase, no backend,
no API keys, nothing to configure beyond `flutter create .`.

## What's in this build

**66 Dart files, ~6,300 lines.** Every module has a real, working
screen wired to shared mock data (`lib/mock/mock_data_service.dart`) —
not static images or dead buttons:

| Module | What works |
|---|---|
| Splash / Onboarding / Auth | Full flow: login, register, forgot password, 2-step phone login, sign out, delete account |
| Company Setup | Real form, gates entry into the app until completed |
| Dashboard | KPI cards, weekly progress chart, AI insights, running projects — all role-agnostic live data |
| Projects | List with search/status filters, create-project form, detail screen with Overview/Tasks/Documents/Gallery tabs |
| Tasks | List with status filters, create-task sheet, inline status changes |
| Attendance | Mock QR/GPS check-in, today's attendance list |
| Labor | Worker directory with attendance rate, wage, status |
| Inventory | Stock levels with low/critical highlighting, category filters |
| Equipment | Status, fuel level, service schedule |
| Procurement | Purchase requests with approval-workflow status, create-request sheet |
| Suppliers | Directory with ratings and order history |
| Clients | List + detail with billing/outstanding balance and linked projects |
| Expenses | Category pie chart + expense list |
| Documents | Type filters, mock download action |
| Site Gallery | Photo albums (colored placeholders — see note below) |
| AI Assistant | Working chat UI with canned, topic-aware mock replies + standing insights |
| Maps | Location list for projects/suppliers/equipment (see note below) |
| Notifications | Unread badges, mark-as-read / mark-all-read |
| Reports | 6 report types, mock export menu (PDF/Excel/CSV) |
| Analytics | Revenue vs. expense line chart, project status breakdown |
| Profile / Settings | Real user info, theme switch (light/dark/system persisted), language/currency selectors, delete account confirmation |
| Search | Live search across projects, workers, clients, suppliers, materials, documents |

Every list/detail screen reads from and (where relevant — Projects,
Tasks, Purchase Requests, Notifications) writes to the single shared
`MockDataService`, so actions taken in one screen are reflected
everywhere else immediately, the same way a real backend would behave.

## Two things are intentionally list-based instead of native widgets

- **Maps** — an embedded map needs a Google Maps API key configured
  per-platform. Instead, the module shows the same location data
  (project sites, suppliers, equipment) as a browsable, filterable
  list. Swap in `google_maps_flutter` + a key later with no data-layer
  changes needed.
- **Site Gallery / photo capture** — no device camera/photo-library
  access is wired up (`image_picker`/`camera` are commented out in
  `pubspec.yaml`), so albums show as colored placeholder tiles with
  real counts/titles rather than actual photos.

Both are called out in-app (a snackbar on tap) rather than silently
faking functionality.

## Running it

```bash
flutter create . --platforms=android,web --org com.yourcompany
flutter pub get
flutter run -d chrome     # Web
flutter run -d android    # Android (device/emulator required)
```

No environment variables, `.env` files, or backend to stand up —
sign up with any email/8+ character password and the whole app is
immediately explorable with realistic construction-company data
(5 projects, 6 workers, 8 inventory items, 6 pieces of equipment,
5 suppliers, 4 clients, 7 expenses, and so on).

## Architecture

Same clean-architecture shape as before — `core/` (theme, router,
shared widgets), `features/<module>/presentation/` — except every
module now reads from `lib/mock/mock_data_service.dart` instead of a
repository interface. That's the one deliberate shortcut in this
build: real modules would each get their own `domain`/`data` layer
like Auth already has, backed by a repository interface, with this
mock service as the *stub implementation* behind that interface.
Promoting a module from "reads mock service directly" to "behind a
repository interface" is a small, mechanical refactor per module
whenever you're ready to connect a real backend.

## Where things are

- `lib/mock/mock_models.dart` — every data model (Project, Task,
  Worker, InventoryItem, Equipment, Supplier, Client, Expense,
  Document, Notification, AI Insight, ...)
- `lib/mock/mock_data_service.dart` — seeded data + the handful of
  mutating actions (add project, update task status, mark notification
  read, send chat message, ...), exposed as a `ChangeNotifierProvider`
  so every screen watching it stays in sync
- `lib/core/router/app_router.dart` — every route, plus the
  splash → onboarding → auth → company-setup → app redirect logic
- `lib/core/widgets/app_shell.dart` — the responsive nav (rail on
  wide/web layouts, drawer on mobile) wrapping all 18 primary modules
- `lib/core/widgets/module_list_scaffold.dart` — the shared
  search/filter/list/FAB shape reused by most modules

## Connecting a real backend later

Nothing here is locked into staying mock. The pattern to follow is
already built for Auth (`features/auth/`): define a `domain/`
repository interface, keep this mock service (or a new stub) as one
implementation of it, add a Firebase/REST implementation as a second,
and swap the provider. Repeat per module as you're ready.
