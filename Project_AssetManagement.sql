-- ======================================================
-- asset_management_full.sql
-- Combined schema + mock data (ordered, FK checks disabled during inserts)
-- Run on MySQL 8.0+
-- ======================================================

DROP DATABASE IF EXISTS asset_management_db;
CREATE DATABASE asset_management_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE asset_management_db;

-- temporarily disable FK checks for clean create & bulk insert
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

-- ======================================================
-- SCHEMA
-- create tables in dependency order
-- ======================================================

-- 1) organizations
CREATE TABLE organizations (
  org_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_code VARCHAR(50) NOT NULL,
  org_name VARCHAR(200) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_org_code (org_code),
  CHECK (status IN ('ACTIVE','INACTIVE'))
) ENGINE=InnoDB;

-- 2) locations
CREATE TABLE locations (
  location_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  location_code VARCHAR(50) NOT NULL,
  name VARCHAR(200) NOT NULL,
  address_line1 VARCHAR(200),
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100),
  postal_code VARCHAR(20),
  geo_point POINT NOT NULL SRID 4326,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_locations_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  UNIQUE KEY uq_loc_org_code (org_id, location_code),
  SPATIAL INDEX spx_locations_geopt (geo_point)
) ENGINE=InnoDB;

-- 3) storage_bins
CREATE TABLE storage_bins (
  bin_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  location_id BIGINT NOT NULL,
  bin_code VARCHAR(60) NOT NULL,
  type VARCHAR(20) NOT NULL DEFAULT 'GENERAL',
  capacity_units INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_bins_location FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE,
  UNIQUE KEY uq_bin_location_code (location_id, bin_code),
  CHECK (type IN ('GENERAL','CAGE','SECURE','HAZMAT')),
  CHECK (capacity_units >= 0)
) ENGINE=InnoDB;

-- 4) departments
CREATE TABLE departments (
  dept_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  dept_code VARCHAR(40) NOT NULL,
  dept_name VARCHAR(200) NOT NULL,
  parent_dept_id BIGINT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_dept_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  CONSTRAINT fk_dept_parent FOREIGN KEY (parent_dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL,
  UNIQUE KEY uq_dept_org_code (org_id, dept_code)
) ENGINE=InnoDB;

-- 5) employees
CREATE TABLE employees (
  employee_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  dept_id BIGINT NULL,
  employee_code VARCHAR(40) NOT NULL,
  full_name VARCHAR(200) NOT NULL,
  email VARCHAR(200) NOT NULL,
  phone VARCHAR(30),
  hire_date DATE,
  employment_type VARCHAR(20) NOT NULL DEFAULT 'FULL_TIME',
  status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
  manager_id BIGINT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_emp_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL,
  CONSTRAINT fk_emp_mgr FOREIGN KEY (manager_id) REFERENCES employees(employee_id) ON DELETE SET NULL,
  UNIQUE KEY uq_emp_org_code (org_id, employee_code),
  UNIQUE KEY uq_emp_org_email (org_id, email),
  CHECK (employment_type IN ('FULL_TIME','PART_TIME','CONTRACT','INTERN')),
  CHECK (status IN ('ACTIVE','INACTIVE','ON_LEAVE'))
) ENGINE=InnoDB;

-- 6) roles
CREATE TABLE roles (
  role_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  role_code VARCHAR(40) NOT NULL,
  role_name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_role_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  UNIQUE KEY uq_role_org_code (org_id, role_code)
) ENGINE=InnoDB;

-- 7) employee_roles
CREATE TABLE employee_roles (
  employee_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (employee_id, role_id),
  CONSTRAINT fk_er_emp FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
  CONSTRAINT fk_er_role FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8) user_accounts
CREATE TABLE user_accounts (
  user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  employee_id BIGINT NOT NULL,
  username VARCHAR(80) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  last_login_at DATETIME NULL,
  is_locked BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_user_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  CONSTRAINT fk_user_emp FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
  UNIQUE KEY uq_user_org_username (org_id, username)
) ENGINE=InnoDB;

-- 9) suppliers
CREATE TABLE suppliers (
  supplier_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  supplier_code VARCHAR(50) NOT NULL,
  name VARCHAR(200) NOT NULL,
  tax_id VARCHAR(100),
  email VARCHAR(200),
  phone VARCHAR(30),
  rating TINYINT NULL,
  address_json JSON NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_sup_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  UNIQUE KEY uq_sup_org_code (org_id, supplier_code),
  CHECK (rating BETWEEN 1 AND 5 OR rating IS NULL),
  CHECK (address_json IS NULL OR JSON_VALID(address_json))
) ENGINE=InnoDB;

-- 10) asset_categories
CREATE TABLE asset_categories (
  category_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  category_code VARCHAR(50) NOT NULL,
  name VARCHAR(200) NOT NULL,
  parent_category_id BIGINT NULL,
  useful_life_months INT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_cat_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  CONSTRAINT fk_cat_parent FOREIGN KEY (parent_category_id) REFERENCES asset_categories(category_id) ON DELETE SET NULL,
  UNIQUE KEY uq_cat_org_code (org_id, category_code),
  CHECK (useful_life_months IS NULL OR useful_life_months > 0)
) ENGINE=InnoDB;

-- 11) asset_models
CREATE TABLE asset_models (
  model_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  category_id BIGINT NOT NULL,
  model_code VARCHAR(80) NOT NULL,
  manufacturer VARCHAR(150) NOT NULL,
  model_name VARCHAR(200) NOT NULL,
  spec_json JSON NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_model_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  CONSTRAINT fk_model_cat FOREIGN KEY (category_id) REFERENCES asset_categories(category_id) ON DELETE RESTRICT,
  UNIQUE KEY uq_model_org_code (org_id, model_code),
  CHECK (spec_json IS NULL OR JSON_VALID(spec_json))
) ENGINE=InnoDB;

-- 12) assets
CREATE TABLE assets (
  asset_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  model_id BIGINT NULL,
  supplier_id BIGINT NULL,
  serial_number VARCHAR(150) NOT NULL,
  asset_tag VARCHAR(60) NOT NULL,
  purchase_date DATE,
  purchase_cost DECIMAL(14,2) NULL,
  currency CHAR(3) NULL DEFAULT 'INR',
  current_status VARCHAR(20) NOT NULL DEFAULT 'IN_STOCK',
  location_id BIGINT NULL,
  bin_id BIGINT NULL,
  custom_fields JSON NULL,
  warranty_end_date DATE NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_asset_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  CONSTRAINT fk_asset_model FOREIGN KEY (model_id) REFERENCES asset_models(model_id) ON DELETE RESTRICT,
  CONSTRAINT fk_asset_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL,
  CONSTRAINT fk_asset_location FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE SET NULL,
  CONSTRAINT fk_asset_bin FOREIGN KEY (bin_id) REFERENCES storage_bins(bin_id) ON DELETE SET NULL,
  UNIQUE KEY uq_asset_org_serial (org_id, serial_number),
  UNIQUE KEY uq_asset_org_tag (org_id, asset_tag),
  INDEX ix_asset_status (current_status),
  CHECK (current_status IN ('IN_STOCK','ASSIGNED','UNDER_MAINTENANCE','RETIRED','DISPOSED')),
  CHECK (custom_fields IS NULL OR JSON_VALID(custom_fields))
) ENGINE=InnoDB;

-- 13) asset_attribute_defs
CREATE TABLE asset_attribute_defs (
  attr_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  name VARCHAR(120) NOT NULL,
  data_type VARCHAR(20) NOT NULL,
  allowed_values JSON NULL,
  is_required BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_attr_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  UNIQUE KEY uq_attr_org_name (org_id, name),
  CHECK (data_type IN ('STRING','NUMBER','BOOLEAN','DATE','ENUM')),
  CHECK (allowed_values IS NULL OR JSON_VALID(allowed_values))
) ENGINE=InnoDB;

-- 14) asset_attribute_values
CREATE TABLE asset_attribute_values (
  asset_id BIGINT NOT NULL,
  attr_id BIGINT NOT NULL,
  string_val VARCHAR(500) NULL,
  number_val DECIMAL(18,6) NULL,
  bool_val BOOLEAN NULL,
  date_val DATE NULL,
  PRIMARY KEY (asset_id, attr_id),
  CONSTRAINT fk_aav_asset FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
  CONSTRAINT fk_aav_attr FOREIGN KEY (attr_id) REFERENCES asset_attribute_defs(attr_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 15) asset_documents
CREATE TABLE asset_documents (
  doc_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  asset_id BIGINT NOT NULL,
  doc_type VARCHAR(40) NOT NULL,
  title VARCHAR(250) NOT NULL,
  url VARCHAR(800) NULL,
  content_hash CHAR(64) NULL,
  uploaded_by BIGINT NULL,
  uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_doc_asset FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
  CONSTRAINT fk_doc_uploader FOREIGN KEY (uploaded_by) REFERENCES employees(employee_id) ON DELETE SET NULL,
  CHECK (doc_type IN ('INVOICE','WARRANTY','PHOTO','MANUAL','OTHER'))
) ENGINE=InnoDB;

-- 16) maintenance_vendors
CREATE TABLE maintenance_vendors (
  maint_vendor_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  vendor_code VARCHAR(60) NOT NULL,
  name VARCHAR(200) NOT NULL,
  contact_email VARCHAR(200),
  contact_phone VARCHAR(30),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_mv_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  UNIQUE KEY uq_mv_org_code (org_id, vendor_code)
) ENGINE=InnoDB;

-- 17) maintenance_contracts
CREATE TABLE maintenance_contracts (
  contract_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  maint_vendor_id BIGINT NOT NULL,
  contract_code VARCHAR(80) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  terms_json JSON NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_mc_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  CONSTRAINT fk_mc_vendor FOREIGN KEY (maint_vendor_id) REFERENCES maintenance_vendors(maint_vendor_id) ON DELETE RESTRICT,
  UNIQUE KEY uq_mc_org_code (org_id, contract_code),
  CHECK (terms_json IS NULL OR JSON_VALID(terms_json)),
  CHECK (end_date > start_date)
) ENGINE=InnoDB;

-- 18) work_orders
CREATE TABLE work_orders (
  wo_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  asset_id BIGINT NOT NULL,
  contract_id BIGINT NULL,
  requested_by BIGINT NOT NULL,
  assigned_to BIGINT NULL,
  priority VARCHAR(10) NOT NULL DEFAULT 'MEDIUM',
  status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
  title VARCHAR(250) NOT NULL,
  description TEXT,
  requested_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  due_date DATE NULL,
  closed_at TIMESTAMP NULL,
  CONSTRAINT fk_wo_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  CONSTRAINT fk_wo_asset FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
  CONSTRAINT fk_wo_contract FOREIGN KEY (contract_id) REFERENCES maintenance_contracts(contract_id) ON DELETE SET NULL,
  CONSTRAINT fk_wo_req FOREIGN KEY (requested_by) REFERENCES employees(employee_id) ON DELETE RESTRICT,
  CONSTRAINT fk_wo_assigned FOREIGN KEY (assigned_to) REFERENCES employees(employee_id) ON DELETE SET NULL,
  INDEX ix_wo_status (status),
  CHECK (priority IN ('LOW','MEDIUM','HIGH','CRITICAL')),
  CHECK (status IN ('OPEN','IN_PROGRESS','ON_HOLD','CLOSED'))
) ENGINE=InnoDB;

-- 19) work_order_tasks
CREATE TABLE work_order_tasks (
  wo_id BIGINT NOT NULL,
  task_seq INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
  estimated_hours DECIMAL(6,2) NULL,
  actual_hours DECIMAL(6,2) NULL,
  PRIMARY KEY (wo_id, task_seq),
  CONSTRAINT fk_wot_wo FOREIGN KEY (wo_id) REFERENCES work_orders(wo_id) ON DELETE CASCADE,
  CHECK (status IN ('PENDING','DOING','DONE')),
  CHECK (estimated_hours IS NULL OR estimated_hours >= 0),
  CHECK (actual_hours IS NULL OR actual_hours >= 0)
) ENGINE=InnoDB;

-- 20) asset_assignments
CREATE TABLE asset_assignments (
  assignment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  asset_id BIGINT NOT NULL,
  employee_id BIGINT NULL,
  dept_id BIGINT NULL,
  project_id BIGINT NULL,
  location_id BIGINT NULL,
  bin_id BIGINT NULL,
  assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  unassigned_at TIMESTAMP NULL,
  CONSTRAINT fk_asg_asset FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
  CONSTRAINT fk_asg_emp FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE SET NULL,
  CONSTRAINT fk_asg_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL,
  CONSTRAINT fk_asg_loc FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE SET NULL,
  CONSTRAINT fk_asg_bin FOREIGN KEY (bin_id) REFERENCES storage_bins(bin_id) ON DELETE SET NULL,
  CHECK (unassigned_at IS NULL OR unassigned_at > assigned_at)
) ENGINE=InnoDB;

-- 21) projects
CREATE TABLE projects (
  project_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  project_code VARCHAR(60) NOT NULL,
  name VARCHAR(250) NOT NULL,
  start_date DATE NULL,
  end_date DATE NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'PLANNED',
  CONSTRAINT fk_proj_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  UNIQUE KEY uq_proj_org_code (org_id, project_code),
  CHECK (status IN ('PLANNED','ACTIVE','ON_HOLD','COMPLETED','CANCELLED')),
  CHECK (end_date IS NULL OR start_date IS NULL OR end_date >= start_date)
) ENGINE=InnoDB;

-- 22) employee_projects
CREATE TABLE employee_projects (
  employee_id BIGINT NOT NULL,
  project_id BIGINT NOT NULL,
  role_in_project VARCHAR(80) NULL,
  joined_at DATE NULL,
  left_at DATE NULL,
  PRIMARY KEY (employee_id, project_id),
  CONSTRAINT fk_ep_emp FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE,
  CONSTRAINT fk_ep_proj FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
  CHECK (left_at IS NULL OR joined_at IS NULL OR left_at >= joined_at)
) ENGINE=InnoDB;

-- 23) purchase_orders
CREATE TABLE purchase_orders (
  po_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  supplier_id BIGINT NOT NULL,
  po_number VARCHAR(40) NOT NULL,
  order_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
  currency CHAR(3) NOT NULL DEFAULT 'INR',
  total_amount DECIMAL(14,2) NULL,
  CONSTRAINT fk_po_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  CONSTRAINT fk_po_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE RESTRICT,
  UNIQUE KEY uq_po_org_number (org_id, po_number),
  CHECK (status IN ('OPEN','PARTIALLY_RECEIVED','CLOSED','CANCELLED'))
) ENGINE=InnoDB;

-- 24) purchase_order_items
CREATE TABLE purchase_order_items (
  po_id BIGINT NOT NULL,
  line_no INT NOT NULL,
  model_id BIGINT NOT NULL,
  qty_ordered INT NOT NULL,
  unit_price DECIMAL(14,2) NOT NULL,
  qty_received INT NOT NULL DEFAULT 0,
  PRIMARY KEY (po_id, line_no),
  CONSTRAINT fk_poi_po FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id) ON DELETE CASCADE,
  CONSTRAINT fk_poi_model FOREIGN KEY (model_id) REFERENCES asset_models(model_id) ON DELETE RESTRICT,
  CHECK (qty_ordered > 0),
  CHECK (qty_received >= 0),
  CHECK (unit_price >= 0)
) ENGINE=InnoDB;

-- 25) invoices
CREATE TABLE invoices (
  invoice_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  supplier_id BIGINT NOT NULL,
  invoice_number VARCHAR(40) NOT NULL,
  invoice_date DATE NOT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'INR',
  total_amount DECIMAL(14,2) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
  CONSTRAINT fk_inv_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  CONSTRAINT fk_inv_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE RESTRICT,
  UNIQUE KEY uq_inv_org_number (org_id, invoice_number),
  CHECK (status IN ('OPEN','PAID','CANCELLED'))
) ENGINE=InnoDB;

-- 26) invoice_items
CREATE TABLE invoice_items (
  invoice_id BIGINT NOT NULL,
  line_no INT NOT NULL,
  asset_id BIGINT NULL,
  description VARCHAR(300) NOT NULL,
  qty INT NOT NULL,
  unit_price DECIMAL(14,2) NOT NULL,
  PRIMARY KEY (invoice_id, line_no),
  CONSTRAINT fk_invi_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id) ON DELETE CASCADE,
  CONSTRAINT fk_invi_asset FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE SET NULL,
  CHECK (qty > 0),
  CHECK (unit_price >= 0)
) ENGINE=InnoDB;

-- 27) software_licenses
CREATE TABLE software_licenses (
  license_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  product_name VARCHAR(200) NOT NULL,
  license_key VARCHAR(200) NOT NULL,
  seats_purchased INT NOT NULL,
  seats_in_use INT NOT NULL DEFAULT 0,
  valid_from DATE NOT NULL,
  valid_to DATE NULL,
  CONSTRAINT fk_lic_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  UNIQUE KEY uq_lic_org_key (org_id, license_key),
  CHECK (seats_purchased > 0),
  CHECK (seats_in_use >= 0 AND seats_in_use <= seats_purchased),
  CHECK (valid_to IS NULL OR valid_to >= valid_from)
) ENGINE=InnoDB;

-- 28) license_allocations
CREATE TABLE license_allocations (
  license_id BIGINT NOT NULL,
  allocation_id BIGINT NOT NULL,
  asset_id BIGINT NULL,
  employee_id BIGINT NULL,
  allocated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (license_id, allocation_id),
  CONSTRAINT fk_lalloc_license FOREIGN KEY (license_id) REFERENCES software_licenses(license_id) ON DELETE CASCADE,
  CONSTRAINT fk_lalloc_asset FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE SET NULL,
  CONSTRAINT fk_lalloc_emp FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 29) depreciation_policies
CREATE TABLE depreciation_policies (
  policy_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  name VARCHAR(100) NOT NULL,
  method VARCHAR(30) NOT NULL,
  useful_life_months INT NOT NULL,
  salvage_value_pct DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  CONSTRAINT fk_dp_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  UNIQUE KEY uq_dp_org_name (org_id, name),
  CHECK (method IN ('STRAIGHT_LINE','DOUBLE_DECLINING','SUM_OF_YEARS_DIGITS')),
  CHECK (useful_life_months > 0),
  CHECK (salvage_value_pct >= 0 AND salvage_value_pct < 100)
) ENGINE=InnoDB;

-- 30) depreciation_runs
CREATE TABLE depreciation_runs (
  run_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  asset_id BIGINT NOT NULL,
  policy_id BIGINT NOT NULL,
  period_start DATE NOT NULL,
  period_end DATE NOT NULL,
  depreciation_amt DECIMAL(14,2) NOT NULL,
  posted_at TIMESTAMP NULL,
  CONSTRAINT fk_dr_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  CONSTRAINT fk_dr_asset FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
  CONSTRAINT fk_dr_policy FOREIGN KEY (policy_id) REFERENCES depreciation_policies(policy_id) ON DELETE RESTRICT,
  UNIQUE KEY uq_dr_asset_period (asset_id, period_start, period_end),
  CHECK (period_end >= period_start),
  CHECK (depreciation_amt >= 0)
) ENGINE=InnoDB;

-- 31) asset_status_history
CREATE TABLE asset_status_history (
    history_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    asset_id BIGINT NOT NULL,
    old_status VARCHAR(20) NOT NULL,
    new_status VARCHAR(20) NOT NULL,
    change_date DATE NOT NULL,
    changed_by BIGINT NULL,
    notes VARCHAR(500),
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    FOREIGN KEY (changed_by) REFERENCES employees(employee_id) ON DELETE SET NULL,
    CHECK (old_status IN ('IN_STOCK','ASSIGNED','UNDER_MAINTENANCE','RETIRED','DISPOSED')),
    CHECK (new_status IN ('IN_STOCK','ASSIGNED','UNDER_MAINTENANCE','RETIRED','DISPOSED'))
) ENGINE=InnoDB;

-- 32) inventory_txns
CREATE TABLE inventory_txns (
  txn_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  org_id BIGINT NOT NULL,
  asset_id BIGINT NULL,
  location_id_from BIGINT NULL,
  bin_id_from BIGINT NULL,
  location_id_to BIGINT NULL,
  bin_id_to BIGINT NULL,
  txn_type VARCHAR(20) NOT NULL,
  qty INT NOT NULL DEFAULT 1,
  reference VARCHAR(100) NULL,
  txn_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_it_org FOREIGN KEY (org_id) REFERENCES organizations(org_id) ON DELETE CASCADE,
  CONSTRAINT fk_it_asset FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE SET NULL,
  CONSTRAINT fk_it_loc_from FOREIGN KEY (location_id_from) REFERENCES locations(location_id) ON DELETE SET NULL,
  CONSTRAINT fk_it_bin_from FOREIGN KEY (bin_id_from) REFERENCES storage_bins(bin_id) ON DELETE SET NULL,
  CONSTRAINT fk_it_loc_to FOREIGN KEY (location_id_to) REFERENCES locations(location_id) ON DELETE SET NULL,
  CONSTRAINT fk_it_bin_to FOREIGN KEY (bin_id_to) REFERENCES storage_bins(bin_id) ON DELETE SET NULL,
  INDEX ix_it_time (txn_time),
  CHECK (txn_type IN ('RECEIPT','TRANSFER','ISSUE','RETURN','DISPOSAL')),
  CHECK (qty <> 0)
) ENGINE=InnoDB;

-- 33) Helpful views
CREATE OR REPLACE VIEW v_asset_with_age AS
SELECT a.*,
       CASE WHEN a.purchase_date IS NULL THEN NULL
            ELSE DATEDIFF(CURDATE(), a.purchase_date)
       END AS asset_age_days
FROM assets a;

CREATE OR REPLACE VIEW v_asset_summary AS
SELECT a.asset_id,
       a.org_id,
       a.asset_tag,
       a.serial_number,
       a.current_status,
       am.manufacturer,
       am.model_name,
       ac.category_code,
       ac.name AS category_name,
       a.location_id,
       l.name AS location_name,
       a.bin_id,
       b.bin_code,
       a.purchase_date,
       a.purchase_cost,
       a.currency,
       a.warranty_end_date,
       CASE WHEN a.purchase_date IS NULL THEN NULL ELSE DATEDIFF(CURDATE(), a.purchase_date) END AS asset_age_days
FROM assets a
LEFT JOIN asset_models am ON am.model_id = a.model_id
LEFT JOIN asset_categories ac ON ac.category_id = am.category_id
LEFT JOIN locations l ON l.location_id = a.location_id
LEFT JOIN storage_bins b ON b.bin_id = a.bin_id;

-- Additional indexes
CREATE INDEX ix_emp_org_dept ON employees(org_id, dept_id);
CREATE INDEX ix_asset_org_model ON assets(org_id, model_id);
CREATE INDEX ix_po_order_date ON purchase_orders(order_date);
CREATE INDEX ix_dep_runs_asset ON depreciation_runs(asset_id);

-- ======================================================
-- MOCK DATA INSERTS
-- Inserted in dependency-safe order (org -> locations -> deps -> employees -> assets etc.)
-- ======================================================

-- ---------- organizations ----------
INSERT INTO organizations (org_id, org_code, org_name, status, created_at, updated_at)
VALUES
(1, 'ORG-ACME', 'Acme Industries', 'ACTIVE', NOW(), NOW());

-- ---------- locations ----------
INSERT INTO locations (location_id, org_id, location_code, name, address_line1, city, state, country, postal_code, geo_point, created_at, updated_at)
VALUES
(1, 1, 'LOC-BLR-01', 'Acme Bangalore', '123 Tech Park', 'Bengaluru', 'Karnataka', 'India', '560001', ST_GeomFromText('POINT(77.5946 12.9716)', 4326), NOW(), NOW()),
(2, 1, 'LOC-MUM-01', 'Acme Mumbai', '50 Business Street', 'Mumbai', 'Maharashtra', 'India', '400001', ST_GeomFromText('POINT(72.8777 19.0760)', 4326), NOW(), NOW()),
(3, 1, 'LOC-CHN-01', 'Acme Chennai', '15 Marina St', 'Chennai', 'Tamil Nadu', 'India', '600001', ST_GeomFromText('POINT(80.2707 13.0827)', 4326), NOW(), NOW()),
(4, 1, 'LOC-DEL-01', 'Acme Delhi', '100 Connaught Place', 'New Delhi', 'Delhi', 'India', '110001', ST_GeomFromText('POINT(77.2090 28.6139)', 4326), NOW(), NOW()),
(5, 1, 'LOC-PUN-01', 'Acme Pune', '88 Business Bay', 'Pune', 'Maharashtra', 'India', '411001', ST_GeomFromText('POINT(73.8567 18.5204)', 4326), NOW(), NOW()),
(6, 1, 'LOC-HYD-01', 'Acme Hyderabad', '5 Tech Road', 'Hyderabad', 'Telangana', 'India', '500001', ST_GeomFromText('POINT(78.4867 17.3850)', 4326), NOW(), NOW()),
(7, 1, 'LOC-KOL-01', 'Acme Kolkata', '20 Park St', 'Kolkata', 'West Bengal', 'India', '700016', ST_GeomFromText('POINT(88.3639 22.5726)', 4326), NOW(), NOW());

-- ---------- storage_bins ----------
INSERT INTO storage_bins (bin_id, location_id, bin_code, type, capacity_units, created_at, updated_at)
VALUES
(100, 1, 'BIN-A1', 'GENERAL', 50, NOW(), NOW()),
(101, 1, 'BIN-A2', 'CAGE', 20, NOW(), NOW()),
(102, 3, 'BIN-C1', 'GENERAL', 100, NOW(), NOW()),
(103, 3, 'BIN-C2', 'SECURE', 25, NOW(), NOW()),
(104, 4, 'BIN-D1', 'GENERAL', 60, NOW(), NOW()),
(105, 5, 'BIN-P1', 'HAZMAT', 10, NOW(), NOW()),
(106, 6, 'BIN-H1', 'CAGE', 30, NOW(), NOW());

-- ---------- departments ----------
INSERT INTO departments (dept_id, org_id, dept_code, dept_name, parent_dept_id, created_at, updated_at)
VALUES
(10, 1, 'IT', 'IT Department', NULL, NOW(), NOW()),
(11, 1, 'HR', 'Human Resources', NULL, NOW(), NOW()),
(12, 1, 'FIN', 'Finance', NULL, NOW(), NOW()),
(13, 1, 'OPS', 'Operations', NULL, NOW(), NOW()),
(14, 1, 'SALES', 'Sales', NULL, NOW(), NOW()),
(15, 1, 'QA', 'Quality Assurance', NULL, NOW(), NOW()),
(16, 1, 'RND', 'R&D', NULL, NOW(), NOW());

-- ---------- employees ----------
INSERT INTO employees (employee_id, org_id, dept_id, employee_code, full_name, email, phone, hire_date, employment_type, status, manager_id, created_at, updated_at)
VALUES
(1001, 1, 10, 'E1001', 'John Doe', 'john.doe@acme.com', '+91-9000000001', '2022-04-15', 'FULL_TIME', 'ACTIVE', NULL, NOW(), NOW()),
(1002, 1, 11, 'E1002', 'Jane Smith', 'jane.smith@acme.com', '+91-9000000002', '2023-01-10', 'FULL_TIME', 'ACTIVE', 1001, NOW(), NOW()),
(1003, 1, 12, 'E1003', 'Priya Kumar', 'priya.kumar@acme.com', '+91-9000000003', '2021-06-01', 'FULL_TIME', 'ACTIVE', 1001, NOW(), NOW()),
(1004, 1, 13, 'E1004', 'Rahul Verma', 'rahul.verma@acme.com', '+91-9000000004', '2022-09-10', 'FULL_TIME', 'ACTIVE', 1003, NOW(), NOW()),
(1005, 1, 14, 'E1005', 'Sneha Patel', 'sneha.patel@acme.com', '+91-9000000005', '2023-02-20', 'PART_TIME', 'ACTIVE', 1004, NOW(), NOW()),
(1006, 1, 15, 'E1006', 'Amit Shah', 'amit.shah@acme.com', '+91-9000000006', '2020-11-30', 'FULL_TIME', 'ON_LEAVE', 1003, NOW(), NOW()),
(1007, 1, 16, 'E1007', 'Neha Gupta', 'neha.gupta@acme.com', '+91-9000000007', '2024-03-01', 'CONTRACT', 'ACTIVE', 1004, NOW(), NOW());

-- ---------- roles ----------
INSERT INTO roles (role_id, org_id, role_code, role_name, created_at, updated_at)
VALUES
(201, 1, 'IT_ADMIN', 'IT Administrator', NOW(), NOW()),
(202, 1, 'ASSET_MGR', 'Asset Manager', NOW(), NOW()),
(203, 1, 'FIN_MGR', 'Finance Manager', NOW(), NOW()),
(204, 1, 'OPS_LEAD', 'Operations Lead', NOW(), NOW()),
(205, 1, 'SALES_REP', 'Sales Representative', NOW(), NOW()),
(206, 1, 'QA_ENGINEER', 'QA Engineer', NOW(), NOW()),
(207, 1, 'DEV_ENGINEER', 'Dev Engineer', NOW(), NOW());

-- ---------- employee_roles ----------
INSERT INTO employee_roles (employee_id, role_id, assigned_at)
VALUES
(1001, 201, NOW()),
(1002, 202, NOW()),
(1003, 203, NOW()),
(1004, 204, NOW()),
(1005, 205, NOW()),
(1006, 206, NOW()),
(1007, 207, NOW());

-- ---------- user_accounts ----------
INSERT INTO user_accounts (user_id, org_id, employee_id, username, password_hash, last_login_at, is_locked, created_at, updated_at)
VALUES
(3001, 1, 1001, 'jdoe', 'bcrypt$2y$samplehash', NOW(), FALSE, NOW(), NOW()),
(3002, 1, 1002, 'jsmith', 'bcrypt$2y$samplehash2', NULL, FALSE, NOW(), NOW()),
(3003, 1, 1003, 'pkumar', 'bcrypt$2y$hash3', NOW(), FALSE, NOW(), NOW()),
(3004, 1, 1004, 'rverma', 'bcrypt$2y$hash4', NULL, FALSE, NOW(), NOW()),
(3005, 1, 1005, 'spatel', 'bcrypt$2y$hash5', NULL, FALSE, NOW(), NOW()),
(3006, 1, 1006, 'ashah', 'bcrypt$2y$hash6', NULL, FALSE, NOW(), NOW()),
(3007, 1, 1007, 'ngupta', 'bcrypt$2y$hash7', NULL, FALSE, NOW(), NOW());

-- ---------- suppliers ----------
INSERT INTO suppliers (supplier_id, org_id, supplier_code, name, tax_id, email, phone, rating, address_json, created_at, updated_at)
VALUES
(4001, 1, 'SUP-DELL', 'Dell India', 'TAX-DEL-001', 'sales@dell.com', '+91-8000000001', 5, JSON_OBJECT('line1','Dell Campus','city','Bengaluru'), NOW(), NOW()),
(4002, 1, 'SUP-HP', 'HP India', 'TAX-HP-001', 'sales@hp.com', '+91-8000000002', 4, JSON_OBJECT('line1','HP Office','city','Mumbai'), NOW(), NOW()),
(4003, 1, 'SUP-LEN', 'Lenovo India', 'TAX-LEN-001', 'sales@lenovo.com', '+91-8000000003', 4, JSON_OBJECT('line1','Lenovo Office','city','Pune'), NOW(), NOW()),
(4004, 1, 'SUP-CPQ', 'Canon Printers Pvt', 'TAX-CPQ-001', 'contact@canon.com', '+91-8000000004', 4, JSON_OBJECT('line1','Canon Office','city','Chennai'), NOW(), NOW()),
(4005, 1, 'SUP-EPSON', 'Epson India', 'TAX-EP-001', 'sales@epson.com', '+91-8000000005', 4, JSON_OBJECT('line1','Epson Hub','city','Hyderabad'), NOW(), NOW()),
(4006, 1, 'SUP-CISCO', 'Cisco India', 'TAX-CSC-001', 'sales@cisco.com', '+91-8000000006', 5, JSON_OBJECT('line1','Cisco Campus','city','Bengaluru'), NOW(), NOW()),
(4007, 1, 'SUP-LOCAL', 'Local Tech Supplies', 'TAX-LOC-001', 'info@localtech.com', '+91-8000000007', 3, JSON_OBJECT('line1','Local Market','city','Kolkata'), NOW(), NOW());

-- ---------- asset_categories ----------
INSERT INTO asset_categories (category_id, org_id, category_code, name, parent_category_id, useful_life_months, created_at, updated_at)
VALUES
(5001, 1, 'LAPTOP', 'Laptop', NULL, 36, NOW(), NOW()),
(5002, 1, 'MONITOR', 'Monitor', NULL, 60, NOW(), NOW()),
(5003, 1, 'PRINTER', 'Printer', NULL, 48, NOW(), NOW()),
(5004, 1, 'SERVER', 'Server', NULL, 60, NOW(), NOW()),
(5005, 1, 'ROUTER', 'Router', NULL, 60, NOW(), NOW()),
(5006, 1, 'PHONE', 'VoIP Phone', NULL, 36, NOW(), NOW()),
(5007, 1, 'TABLET', 'Tablet', NULL, 24, NOW(), NOW());

-- ---------- asset_models ----------
INSERT INTO asset_models (model_id, org_id, category_id, model_code, manufacturer, model_name, spec_json, created_at, updated_at)
VALUES
(6001, 1, 5001, 'LAT5520', 'Dell', 'Dell Latitude 5520', JSON_OBJECT('CPU','Intel i7','RAM','16GB','Storage','512GB SSD','OS','Windows 11'), NOW(), NOW()),
(6002, 1, 5002, 'MON-24', 'Dell', 'Dell 24-inch Monitor', JSON_OBJECT('Size','24in','Resolution','1920x1080'), NOW(), NOW()),
(6003, 1, 5003, 'CAN-PRT-200', 'Canon', 'Canon ImageRunner 200', JSON_OBJECT('Type','Laser','Speed','25ppm'), NOW(), NOW()),
(6004, 1, 5004, 'HP-SRV-XL', 'HP', 'HP ProLiant DL380', JSON_OBJECT('CPU','Xeon','RAM','64GB'), NOW(), NOW()),
(6005, 1, 5005, 'CISCO-2901', 'Cisco', 'Cisco 2901 Router', JSON_OBJECT('Ports','8','Throughput','100Mbps'), NOW(), NOW()),
(6006, 1, 5006, 'POLY-CCX', 'Poly', 'Polycom VVX 311', JSON_OBJECT('Type','VoIP Phone'), NOW(), NOW()),
(6007, 1, 5007, 'IPAD-10', 'Apple', 'iPad 10', JSON_OBJECT('CPU','A14','RAM','4GB','Storage','64GB'), NOW(), NOW());

-- ---------- assets ----------
INSERT INTO assets (asset_id, org_id, model_id, supplier_id, serial_number, asset_tag, purchase_date, purchase_cost, currency, current_status, location_id, bin_id, custom_fields, warranty_end_date, created_at, updated_at)
VALUES
(7001, 1, 6001, 4001, 'SN-D-0001', 'AT-0001', '2024-01-15', 65000.00, 'INR', 'IN_STOCK', 1, 100, JSON_OBJECT('color','black'), '2026-01-15', NOW(), NOW()),
(7002, 1, 6002, 4002, 'SN-M-0001', 'AT-0002', '2023-11-01', 8000.00, 'INR', 'IN_STOCK', 1, 101, NULL, NULL, NOW(), NOW()),
(7003, 1, 6003, 4004, 'SN-C-0002', 'AT-0003', '2024-02-10', 45000.00, 'INR', 'IN_STOCK', 3, 102, JSON_OBJECT('color','white'), '2026-02-10', NOW(), NOW()),
(7004, 1, 6004, 4003, 'SN-S-0002', 'AT-0004', '2022-08-01', 250000.00, 'INR', 'ASSIGNED', 4, NULL, NULL, '2025-08-01', NOW(), NOW()),
(7005, 1, 6005, 4006, 'SN-R-0001', 'AT-0005', '2023-12-10', 75000.00, 'INR', 'UNDER_MAINTENANCE', 6, 106, JSON_OBJECT('note','under firmware upgrade'), '2025-12-10', NOW(), NOW()),
(7006, 1, 6006, 4007, 'SN-P-0001', 'AT-0006', '2024-03-05', 8000.00, 'INR', 'IN_STOCK', 5, 105, NULL, '2026-03-05', NOW(), NOW()),
(7007, 1, 6007, 4003, 'SN-T-0001', 'AT-0007', '2022-11-11', 30000.00, 'INR', 'RETIRED', 7, NULL, JSON_OBJECT('notes','replaced due to damage'), '2024-11-11', NOW(), NOW());

-- ---------- asset_attribute_defs ----------
INSERT INTO asset_attribute_defs (attr_id, org_id, name, data_type, allowed_values, is_required, created_at, updated_at)
VALUES
(8001, 1, 'OS', 'STRING', NULL, TRUE, NOW(), NOW()),
(8002, 1, 'RAM_GB', 'NUMBER', NULL, FALSE, NOW(), NOW()),
(8003, 1, 'WARRANTY_YEARS', 'NUMBER', NULL, FALSE, NOW(), NOW()),
(8004, 1, 'COLOR', 'STRING', NULL, FALSE, NOW(), NOW()),
(8005, 1, 'NETWORKED', 'BOOLEAN', NULL, FALSE, NOW(), NOW()),
(8006, 1, 'PURCHASE_LOCATION', 'STRING', NULL, FALSE, NOW(), NOW()),
(8007, 1, 'SERIAL_FORMAT', 'STRING', NULL, FALSE, NOW(), NOW());

-- ---------- asset_attribute_values ----------
INSERT INTO asset_attribute_values (asset_id, attr_id, string_val, number_val, bool_val, date_val)
VALUES
(7001, 8001, 'Windows 11', NULL, NULL, NULL),
(7001, 8002, NULL, 16.000000, NULL, NULL),
(7003, 8004, 'white', NULL, NULL, NULL),
(7004, 8003, NULL, 3.000000, NULL, NULL),
(7005, 8005, NULL, NULL, TRUE, NULL),
(7006, 8006, 'Acme Pune Store', NULL, NULL, NULL),
(7007, 8007, 'SN-T-####', NULL, NULL, NULL);

-- ---------- asset_documents ----------
INSERT INTO asset_documents (doc_id, asset_id, doc_type, title, url, content_hash, uploaded_by, uploaded_at)
VALUES
(9001, 7001, 'PHOTO', 'Laptop Front Photo', NULL, NULL, 1001, NOW()),
(9002, 7001, 'WARRANTY', 'Warranty PDF', NULL, NULL, 1001, NOW()),
(9003, 7003, 'MANUAL', 'Canon Manual', NULL, NULL, 1003, NOW()),
(9004, 7004, 'INVOICE', 'Server Invoice', NULL, NULL, 1004, NOW()),
(9005, 7005, 'PHOTO', 'Router Photo', NULL, NULL, 1005, NOW()),
(9006, 7006, 'WARRANTY', 'VoIP Warranty', NULL, NULL, 1006, NOW()),
(9007, 7007, 'OTHER', 'Tablet Disposal Note', NULL, NULL, 1007, NOW());

-- ---------- maintenance_vendors ----------
INSERT INTO maintenance_vendors (maint_vendor_id, org_id, vendor_code, name, contact_email, contact_phone, created_at, updated_at)
VALUES
(10001, 1, 'MV-TECH', 'Tech Maintainers', 'contact@techmaint.com', '+91-9000000010', NOW(), NOW()),
(10002, 1, 'MV-PRINT', 'PrinterCare Services', 'support@printercare.com', '+91-9000000020', NOW(), NOW()),
(10003, 1, 'MV-NET', 'NetSecure Systems', 'service@netsecure.com', '+91-9000000030', NOW(), NOW()),
(10004, 1, 'MV-SOFT', 'SoftManage Ltd.', 'help@softmanage.com', '+91-9000000040', NOW(), NOW()),
(10005, 1, 'MV-INFRA', 'InfraSupport Pvt Ltd.', 'infra@support.com', '+91-9000000050', NOW(), NOW()),
(10006, 1, 'MV-LOCAL', 'Local Maint Partner', 'local@partner.com', '+91-9000000051', NOW(), NOW());

-- ---------- maintenance_contracts ----------
INSERT INTO maintenance_contracts (contract_id, org_id, maint_vendor_id, contract_code, start_date, end_date, terms_json, created_at, updated_at)
VALUES
(11001, 1, 10001, 'MC-001', '2024-01-01', '2024-12-31', JSON_OBJECT('sla','48h'), NOW(), NOW()),
(11002, 1, 10002, 'MC-002', '2024-03-01', '2025-02-28', JSON_OBJECT('sla','72h','coverage','Printer maintenance'), NOW(), NOW()),
(11003, 1, 10003, 'MC-003', '2024-06-01', '2025-05-31', JSON_OBJECT('sla','24h','coverage','Server & Network'), NOW(), NOW()),
(11004, 1, 10004, 'MC-004', '2024-02-01', '2025-01-31', JSON_OBJECT('sla','96h','coverage','Software support'), NOW(), NOW()),
(11005, 1, 10005, 'MC-005', '2024-08-15', '2025-08-14', JSON_OBJECT('sla','12h','coverage','Infrastructure'), NOW(), NOW()),
(11006, 1, 10006, 'MC-006', '2023-01-01', '2023-12-31', JSON_OBJECT('sla','48h','coverage','Legacy devices'), NOW(), NOW());

-- ---------- work_orders ----------
INSERT INTO work_orders (wo_id, org_id, asset_id, contract_id, requested_by, assigned_to, priority, status, title, description, requested_at, due_date, closed_at)
VALUES
(12001, 1, 7001, 11001, 1001, NULL, 'HIGH', 'OPEN', 'Battery replacement', 'Replace laptop battery', NOW(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), NULL),
(12002, 1, 7002, 11002, 1002, 1001, 'MEDIUM', 'OPEN', 'Monitor Flickering', 'Display issue reported by HR', DATE_SUB(NOW(), INTERVAL 40 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY), NULL),
(12003, 1, 7001, 11003, 1001, NULL, 'HIGH', 'IN_PROGRESS', 'Laptop overheating', 'Fan replacement is needed', DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 2 DAY), NULL),
(12004, 1, 7002, 11004, 1002, 1001, 'LOW', 'CLOSED', 'Monitor Stand Broken', 'Stand replaced', DATE_SUB(NOW(), INTERVAL 60 DAY), DATE_SUB(NOW(), INTERVAL 50 DAY), DATE_SUB(NOW(), INTERVAL 45 DAY)),
(12005, 1, 7005, 11005, 1003, NULL, 'CRITICAL', 'OPEN', 'Network outage', 'Router down', DATE_SUB(NOW(), INTERVAL 2 HOUR), DATE_ADD(NOW(), INTERVAL 4 HOUR), NULL),
(12006, 1, 7003, 11006, 1004, 1004, 'MEDIUM', 'CLOSED', 'Printer jam', 'Cleared paper jam and tested', DATE_SUB(NOW(), INTERVAL 200 DAY), DATE_SUB(NOW(), INTERVAL 190 DAY), DATE_SUB(NOW(), INTERVAL 185 DAY));

-- ---------- work_order_tasks ----------
INSERT INTO work_order_tasks (wo_id, task_seq, title, status, estimated_hours, actual_hours)
VALUES
(12001, 1, 'Diagnose battery', 'PENDING', 1.0, NULL),
(12001, 2, 'Replace battery', 'PENDING', 0.5, NULL),
(12002, 1, 'Inspect monitor', 'PENDING', 0.5, NULL),
(12002, 2, 'Replace cable', 'PENDING', 0.2, NULL),
(12003, 1, 'Diagnose overheating', 'DOING', 1.5, 0.5),
(12003, 2, 'Replace fan', 'PENDING', 1.0, NULL),
(12005, 1, 'Restart router', 'PENDING', 0.25, NULL);

-- ---------- projects ----------
INSERT INTO projects (project_id, org_id, project_code, name, start_date, end_date, status)
VALUES
(13001, 1, 'PROJ-ALPHA', 'Alpha Deployment', '2024-05-01', NULL, 'ACTIVE'),
(13002, 1, 'PROJ-BETA', 'Beta Deployment', '2024-06-01', NULL, 'ACTIVE'),
(13003, 1, 'PROJ-GAMMA', 'Gamma Rollout', '2024-09-01', '2025-03-31', 'PLANNED'),
(13004, 1, 'PROJ-DELTA', 'Delta Migration', '2023-10-01', '2024-12-31', 'COMPLETED'),
(13005, 1, 'PROJ-OMEGA', 'Omega Research', '2025-01-01', NULL, 'ACTIVE'),
(13006, 1, 'PROJ-EPS', 'EPS Integration', '2024-11-01', NULL, 'ON_HOLD');

-- ---------- employee_projects ----------
INSERT INTO employee_projects (employee_id, project_id, role_in_project, joined_at, left_at)
VALUES
(1001, 13001, 'Developer', '2024-05-10', NULL),
(1003, 13002, 'Tester', '2024-06-10', NULL),
(1004, 13002, 'Ops Lead', '2024-06-15', NULL),
(1005, 13003, 'Sales Support', '2024-09-10', NULL),
(1006, 13004, 'QA', '2023-10-05', '2024-12-31'),
(1007, 13005, 'Researcher', '2025-01-15', NULL);

-- ---------- purchase_orders ----------
INSERT INTO purchase_orders (po_id, org_id, supplier_id, po_number, order_date, status, currency, total_amount)
VALUES
(15001, 1, 4001, 'PO-1001', '2024-08-01', 'OPEN', 'INR', 325000.00),
(15002, 1, 4003, 'PO-1002', '2024-09-01', 'OPEN', 'INR', 520000.00),
(15003, 1, 4004, 'PO-1003', '2024-07-15', 'PARTIALLY_RECEIVED', 'INR', 90000.00),
(15004, 1, 4005, 'PO-1004', '2024-05-20', 'CLOSED', 'INR', 120000.00),
(15005, 1, 4006, 'PO-1005', '2024-03-10', 'CANCELLED', 'INR', 450000.00),
(15006, 1, 4007, 'PO-1006', '2024-10-01', 'OPEN', 'INR', 150000.00);

-- ---------- purchase_order_items ----------
INSERT INTO purchase_order_items (po_id, line_no, model_id, qty_ordered, unit_price, qty_received) VALUES
(15001, 1, 6001, 5, 65000.00, 0),
(15002, 1, 6004, 2, 250000.00, 0),
(15002, 2, 6005, 3, 75000.00, 0),
(15003, 1, 6003, 5, 45000.00, 2),
(15004, 1, 6006, 10, 8000.00, 10),
(15006, 1, 6007, 5, 30000.00, 0);

-- ---------- invoices ----------
INSERT INTO invoices (invoice_id, org_id, supplier_id, invoice_number, invoice_date, currency, total_amount, status)
VALUES
(16001, 1, 4001, 'INV-1001', '2024-08-02', 'INR', 325000.00, 'OPEN'),
(16002, 1, 4003, 'INV-1002', '2024-09-05', 'INR', 520000.00, 'OPEN'),
(16003, 1, 4004, 'INV-1003', '2024-07-20', 'INR', 90000.00, 'PAID'),
(16004, 1, 4005, 'INV-1004', '2024-06-01', 'INR', 120000.00, 'PAID'),
(16005, 1, 4006, 'INV-1005', '2024-03-15', 'INR', 450000.00, 'CANCELLED'),
(16006, 1, 4007, 'INV-1006', '2024-10-05', 'INR', 150000.00, 'OPEN');

-- ---------- invoice_items ----------
INSERT INTO invoice_items (invoice_id, line_no, asset_id, description, qty, unit_price) VALUES
(16001, 1, 7001, 'Dell Latitude 5520', 1, 65000.00),
(16002, 1, NULL, 'Server Hardware', 2, 250000.00),
(16003, 1, NULL, 'Printer Supply', 5, 45000.00),
(16004, 1, 7004, 'VoIP Phones', 10, 8000.00),
(16005, 1, NULL, 'Network Switch', 1, 450000.00),
(16006, 1, NULL, 'Tablets', 5, 30000.00);

-- ---------- software_licenses ----------
INSERT INTO software_licenses (license_id, org_id, product_name, license_key, seats_purchased, seats_in_use, valid_from, valid_to)
VALUES
(17001, 1, 'Acme Office Suite', 'OFFICE-KEY-001', 10, 1, '2024-01-01', '2025-01-01'),
(17002, 1, 'Acme VPN', 'VPN-KEY-002', 50, 5, '2024-01-01', '2026-01-01'),
(17003, 1, 'Acme CRM', 'CRM-KEY-003', 25, 10, '2024-05-01', '2025-05-01'),
(17004, 1, 'Acme Dev Tools', 'DEV-KEY-004', 15, 2, '2024-02-01', '2025-02-01'),
(17005, 1, 'Antivirus Pro', 'AV-KEY-005', 100, 30, '2024-01-01', '2025-01-01'),
(17006, 1, 'Design Suite', 'DS-KEY-006', 10, 1, '2024-07-01', '2025-07-01');

-- ---------- license_allocations ----------
INSERT INTO license_allocations (license_id, allocation_id, asset_id, employee_id, allocated_at) VALUES
(17001, 1, 7001, 1001, NOW()),
(17002, 1, 7004, 1004, NOW()),
(17002, 2, NULL, 1005, NOW()),
(17003, 1, NULL, 1003, NOW()),
(17004, 1, 7006, 1006, NOW()),
(17005, 1, NULL, 1007, NOW());

-- ---------- depreciation_policies ----------
INSERT INTO depreciation_policies (policy_id, org_id, name, method, useful_life_months, salvage_value_pct)
VALUES
(18001, 1, 'Default Straight Line 36m', 'STRAIGHT_LINE', 36, 0.00),
(18002, 1, 'SL 60m', 'STRAIGHT_LINE', 60, 0.00),
(18003, 1, 'DD 36m', 'DOUBLE_DECLINING', 36, 5.00),
(18004, 1, 'SYD 48m', 'SUM_OF_YEARS_DIGITS', 48, 2.50),
(18005, 1, 'SL 24m', 'STRAIGHT_LINE', 24, 0.00),
(18006, 1, 'DD 120m', 'DOUBLE_DECLINING', 120, 1.00);

-- ---------- depreciation_runs ----------
INSERT INTO depreciation_runs (run_id, org_id, asset_id, policy_id, period_start, period_end, depreciation_amt, posted_at)
VALUES
(19001, 1, 7001, 18001, '2024-01-01', '2024-12-31', 5000.00, NOW()),
(19002, 1, 7003, 18002, '2024-01-01', '2024-12-31', 4000.00, NOW()),
(19003, 1, 7004, 18003, '2024-01-01', '2024-12-31', 12000.00, NOW()),
(19004, 1, 7005, 18004, '2024-01-01', '2024-12-31', 2000.00, NOW()),
(19005, 1, 7006, 18005, '2024-01-01', '2024-12-31', 600.00, NOW()),
(19006, 1, 7007, 18006, '2024-01-01', '2024-12-31', 2500.00, NOW());

-- ---------- asset_status_history ----------
INSERT INTO asset_status_history (history_id, asset_id, old_status, new_status, change_date, changed_by, notes) VALUES
(20001, 7001, 'IN_STOCK', 'ASSIGNED', '2024-09-01', 1001, 'Assigned to John Doe'),
(20002, 7003, 'IN_STOCK', 'ASSIGNED', DATE_SUB(CURDATE(), INTERVAL 30 DAY), 1003, 'Assigned to Priya Kumar'),
(20003, 7004, 'ASSIGNED', 'UNDER_MAINTENANCE', DATE_SUB(CURDATE(), INTERVAL 10 DAY), 1004, 'Reported overheating'),
(20004, 7005, 'IN_STOCK', 'UNDER_MAINTENANCE', DATE_SUB(CURDATE(), INTERVAL 20 DAY), 1005, 'Firmware update'),
(20005, 7006, 'IN_STOCK', 'ASSIGNED', DATE_SUB(CURDATE(), INTERVAL 5 DAY), 1006, 'Assigned to Amit Shah'),
(20006, 7007, 'ASSIGNED', 'RETIRED', DATE_SUB(CURDATE(), INTERVAL 400 DAY), 1007, 'End of life');

-- ---------- inventory_txns ----------
INSERT INTO inventory_txns (txn_id, org_id, asset_id, location_id_from, bin_id_from, location_id_to, bin_id_to, txn_type, qty, reference, txn_time) VALUES
(21001, 1, 7001, NULL, NULL, 1, 100, 'RECEIPT', 1, 'PO-1001', NOW()),
(21002, 1, 7003, NULL, NULL, 3, 102, 'RECEIPT', 1, 'PO-1002', NOW()),
(21003, 1, 7004, 1, 100, 4, NULL, 'TRANSFER', 1, 'TR-0001', NOW()),
(21004, 1, 7005, NULL, NULL, 6, 106, 'RECEIPT', 1, 'PO-1003', NOW()),
(21005, 1, 7006, NULL, NULL, 5, 105, 'RECEIPT', 1, 'PO-1004', NOW()),
(21006, 1, 7007, NULL, NULL, 7, NULL, 'DISPOSAL', 1, 'DISP-0001', NOW());

-- ---------- asset_assignments ----------
INSERT INTO asset_assignments (assignment_id, asset_id, employee_id, dept_id, project_id, location_id, bin_id, assigned_at, unassigned_at) VALUES
(14001, 7001, 1001, 10, NULL, 1, 100, NOW(), NULL),
(14002, 7003, 1003, 12, 13001, 3, 102, NOW(), NULL),
(14003, 7004, 1004, 13, 13001, 4, NULL, NOW(), NULL),
(14004, 7005, 1005, 14, NULL, 6, 106, NOW(), NULL),
(14005, 7006, 1006, 15, NULL, 5, 105, NOW(), NULL),
(14006, 7007, 1007, 16, NULL, 7, NULL, NOW(), NULL);

-- ======================================================
-- restore FK checks
-- ======================================================
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;

-- ======================================================
-- Quick verification queries:
-- SELECT COUNT(*) FROM organizations;
-- SELECT COUNT(*) FROM locations;
-- SELECT COUNT(*) FROM assets;
-- SELECT COUNT(*) FROM work_orders WHERE status <> 'CLOSED' AND requested_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
-- ======================================================
