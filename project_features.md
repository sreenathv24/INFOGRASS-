# 🏢 Asset Management System — Full Feature & Technology Overview

## 🗂️ Project Structure

```
ASSET MANAGEMENT/
├── asset-management-backend/   → Spring Boot (Java 21)
├── asset-management-frontend/  → React 19 + Vite
└── docker-compose.yml          → Containerized deployment
```

---

## 🔧 Backend — Technology Stack

| Category | Technology |
|---|---|
| **Framework** | Spring Boot 3.2.5 |
| **Language** | Java 21 |
| **Database (Primary)** | MySQL |
| **Database (Dev/Test)** | H2 (in-memory) |
| **ORM** | Spring Data JPA / Hibernate |
| **Security** | Spring Security + JWT (JJWT 0.11.5) |
| **Authentication (External)** | Firebase Admin SDK 9.2.0 |
| **DB Migrations** | Flyway (flyway-core + flyway-mysql) |
| **API Docs** | SpringDoc OpenAPI / Swagger UI 2.5.0 |
| **Caching** | Spring Cache (AOP-backed) |
| **QR Code Generation** | Google ZXing 3.5.3 |
| **PDF Export** | iText 7 (kernel + layout) |
| **Excel Export** | Apache POI 5.2.5 (poi + poi-ooxml) |
| **Code Reduction** | Lombok 1.18.36 |
| **Build Tool** | Maven (with Frontend Maven Plugin) |
| **Dev Tools** | Spring Boot DevTools |

---

## 🎨 Frontend — Technology Stack

| Category | Technology |
|---|---|
| **Framework** | React 19 + Vite 8 |
| **Routing** | React Router DOM v7 |
| **Styling** | Tailwind CSS v3 + PostCSS |
| **HTTP Client** | Axios v1.15 |
| **Charts & Analytics** | Recharts v3 |
| **Forms & Validation** | React Hook Form v7 + Yup + @hookform/resolvers |
| **Notifications / Toasts** | React Hot Toast v2 |
| **Icons** | Lucide React v1.8 |
| **QR Code Display** | react-qr-code v2 |
| **PDF Export (Client-side)** | jsPDF v4 + jspdf-autotable |
| **Excel Export (Client-side)** | SheetJS / xlsx v0.18 |
| **File Download** | file-saver v2 |
| **Date Utilities** | date-fns v4 |

---

## 🚀 Core Features

### 🔐 1. Authentication & Authorization
- JWT-based stateless authentication
- Firebase Authentication integration (Google/Social login support)
- Role-Based Access Control (RBAC) — `Role` entity
- Custom security filter chain (`Filter/` package)
- Spring Security config with protected routes

---

### 📦 2. Asset Management (Full CRUD)
- Create, read, update, delete assets (`AssetController`, `AssetService`)
- Asset categorization (`AssetCategory` entity)
- Asset model tracking (`AssetModel` entity)
- Asset history/audit trail (`AssetHistory` entity)
- Full-text search & filtering via JPA Specifications (`Specification/`)
- **QR Code generation** per asset (ZXing backend + `react-qr-code` frontend)
- Document attachment support (`Document` entity, `FileStorageService`)

---

### 👤 3. Employee Management
- Full employee CRUD (`EmployeeController`, `EmployeeService`)
- Department management (`DepartmentController`, `Department` entity)
- Link employees to departments and asset assignments

---

### 🔄 4. Asset Assignment & Tracking
- Assign/unassign assets to employees (`AssignmentController`)
- Assignment history tracking (`Assignment` entity)
- Location management for assets (`LocationController`, `Location` entity)
- Activity logging (`ActivityLog` entity)

---

### 🔧 5. Maintenance Management
- Schedule and track maintenance tasks (`MaintenanceController`)
- Maintenance scheduling (`MaintenanceSchedule` entity)
- Maintenance history (`Maintenance` entity)
- Automated scheduling via Spring `@Scheduler` (`Scheduler/` package)

---

### 💰 6. Financial Tracking
- **Depreciation calculation** (`DepreciationController`, `DepreciationService`)
- Depreciation schedules (`DepreciationSchedule` entity)
- Insurance management (`InsuranceController`, `InsuranceService`)
- Insurance claims tracking (`InsuranceClaim` entity)
- Contract management (`ContractController`, `ContractService`)
- Project cost allocation (`ProjectController`, `ProjectService`)
- Supplier management (`SupplierController`)

---

### ✅ 7. Approval Workflows
- Multi-step approval flows (`ApprovalController`, `ApprovalWorkflow` entity)
- Approval request tracking (`Approval` entity)
- Event-driven processing (`Event/` package)

---

### 📊 8. Dashboard & Analytics
- Real-time KPI dashboard (`DashboardController`, `DashboardService`)
- Charts: bar, line, pie via **Recharts**
- Asset status breakdowns, cost summaries, maintenance stats

---

### 📋 9. Audit & Compliance
- Full audit trail (`AuditController` implicitly via `Audit` entity)
- Discrepancy tracking (`AuditDiscrepancy` entity)
- Activity log for all user actions

---

### 📢 10. Notifications
- In-app notification system (`NotificationController`, `NotificationService`)
- `Notification` entity with read/unread state
- Triggered by system events (assignments, maintenance due, approvals)

---

### 📄 11. Reports & Exports
- Server-side report generation (`ReportController`, `ReportService`)
- **PDF export** — iText 7 (backend) + jsPDF (frontend)
- **Excel export** — Apache POI (backend) + SheetJS/xlsx (frontend)
- Custom report filters by date range, category, department

---

### 🌐 12. API & Developer Experience
- Full **Swagger/OpenAPI** documentation at `/swagger-ui.html`
- RESTful API design with DTO pattern (`Dto/` package)
- Global exception handling (`Exception/` package)
- Input validation via Spring Validation + Yup (frontend)
- Object mapping layer (`Mapper/` package)

---

### 🐳 13. Deployment & DevOps
- **Docker Compose** for full-stack containerized deployment
- **Frontend Maven Plugin** — builds React app inside Maven lifecycle
- React `dist/` auto-copied into Spring Boot `static/` resources
- Single JAR deployment (Spring Boot serves both API + React SPA)

---

## 📄 Data Entities (27 Total)

| Entity | Purpose |
|---|---|
| `User` | System user accounts |
| `Role` | RBAC roles |
| `Employee` | Employee records |
| `Department` | Organizational departments |
| `Asset` | Core asset records |
| `AssetCategory` | Asset categorization |
| `AssetModel` | Manufacturer/model info |
| `AssetHistory` | Change history per asset |
| `Assignment` | Asset-to-employee assignments |
| `Location` | Physical locations |
| `Maintenance` | Maintenance records |
| `MaintenanceSchedule` | Recurring maintenance plans |
| `Depreciation` | Depreciation calculations |
| `DepreciationSchedule` | Scheduled depreciation entries |
| `Insurance` | Insurance policies |
| `InsuranceClaim` | Filed insurance claims |
| `Contract` | Vendor/service contracts |
| `Supplier` | Supplier/vendor records |
| `Project` | Projects for cost allocation |
| `License` | Software licenses |
| `Approval` | Approval requests |
| `ApprovalWorkflow` | Workflow definitions |
| `Audit` | Audit records |
| `AuditDiscrepancy` | Audit discrepancies found |
| `Notification` | User notifications |
| `Document` | Attached documents |
| `ActivityLog` | System activity log |

---

## 🖥️ Frontend Pages (13 Modules)

| Module | Page(s) |
|---|---|
| `auth/` | Login, Register |
| `dashboard/` | Main Dashboard with KPIs & Charts |
| `assets/` | Asset List, Detail, Add/Edit |
| `assignments/` | Assignment List, Assign Asset |
| `employees/` | Employee List, Detail, Add/Edit |
| `maintenance/` | Maintenance List, Schedule |
| `financial/` | Depreciation, Insurance, Contracts |
| `approvals/` | Approval Queue, Review |
| `audits/` | Audit List, Audit Detail |
| `locations/` | Location Management |
| `notifications/` | Notification Center |
| `reports/` | Report Builder + Export |
| `settings/` | System & User Settings |
