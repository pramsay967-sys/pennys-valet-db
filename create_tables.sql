-- Penny's Valet — database creation script
-- Run this once to create all 7 tables

CREATE TABLE staff (
  staff_id         INTEGER PRIMARY KEY AUTOINCREMENT,
  name            TEXT NOT NULL,
  phone           TEXT,
  role            TEXT DEFAULT 'technician',
  active          INTEGER DEFAULT 1
);

CREATE TABLE client (
  client_id        INTEGER PRIMARY KEY AUTOINCREMENT,
  first_name      TEXT NOT NULL,
  last_name       TEXT NOT NULL,
  phone           TEXT,
  email           TEXT,
  address_line1   TEXT,
  parish          TEXT NOT NULL,
  preferred_contact TEXT DEFAULT 'phone',
  notes           TEXT,
  created_date    TEXT DEFAULT (date('now'))
);

CREATE TABLE vehicle (
  vehicle_id      INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id       INTEGER NOT NULL,
  registration   TEXT NOT NULL,
  make            TEXT,
  model           TEXT,
  colour          TEXT,
  vehicle_size    TEXT DEFAULT 'standard',
  is_primary      INTEGER DEFAULT 1,
  FOREIGN KEY (client_id) REFERENCES client(client_id)
);

CREATE TABLE service (
  service_id      INTEGER PRIMARY KEY AUTOINCREMENT,
  service_name    TEXT NOT NULL,
  duration_mins   INTEGER NOT NULL,
  price           REAL NOT NULL,
  vehicle_size    TEXT DEFAULT 'standard'
);

CREATE TABLE package (
  package_id      INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id       INTEGER NOT NULL,
  service_id      INTEGER NOT NULL,
  start_date      TEXT NOT NULL,
  end_date        TEXT NOT NULL,
  total_visits    INTEGER NOT NULL,
  visits_used     INTEGER DEFAULT 0,
  status          TEXT DEFAULT 'active',
  frequency       TEXT,
  FOREIGN KEY (client_id) REFERENCES client(client_id),
  FOREIGN KEY (service_id) REFERENCES service(service_id)
);

CREATE TABLE appointment (
  appointment_id  INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id       INTEGER NOT NULL,
  vehicle_id      INTEGER NOT NULL,
  service_id      INTEGER NOT NULL,
  package_id      INTEGER,
  appointment_date TEXT NOT NULL,
  appointment_time TEXT NOT NULL,
  parish          TEXT NOT NULL,
  status          TEXT DEFAULT 'confirmed',
  staff_id        INTEGER,
  weather_flag    INTEGER DEFAULT 0,
  notes           TEXT,
  FOREIGN KEY (client_id) REFERENCES client(client_id),
  FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id),
  FOREIGN KEY (service_id) REFERENCES service(service_id),
  FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE weather_event (
  event_id             INTEGER PRIMARY KEY AUTOINCREMENT,
  event_date           TEXT NOT NULL,
  severity             TEXT,
  action_taken         TEXT,
  appointments_affected INTEGER DEFAULT 0
);

-- Insert Penny's real services (from the website)
INSERT INTO service (service_name, duration_mins, price, vehicle_size) VALUES
  ('Full valet with interior shampoo', 240, 250.00, 'standard'),
  ('Full valet — standard vehicle', 90, 97.00, 'standard'),
  ('Full valet — larger vehicle', 120, 130.00, 'large'),
  ('Package visit — 6 valets standard', 60, 269.00, 'standard'),
  ('Package visit — 6 valets larger', 90, 333.00, 'large');

-- Insert staff
INSERT INTO staff (name, phone, role, active) VALUES
  ('Penny', '07797731731', 'owner', 1),
  ('Staff Member 2', '', 'technician', 1);