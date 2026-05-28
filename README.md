# Penny's Valet — Business Automation & Database System

> A real-world project to automate and modernise a 25-year-old mobile car valeting business in Jersey, Channel Islands. Built as part of a career transition into data and software development.

---

## The Business Problem

Penny's Valet has operated successfully for over 25 years but relies entirely on manual processes:

- Client information spread across a phone contacts list, paper diary, and memory
- Regular package clients (3-month bookings) tracked informally with no renewal alerts
- Weather cancellations handled by calling or texting each client individually
- Appointments not grouped by parish, meaning unnecessary travel time daily
- No invoicing automation — all billing done manually
- No visibility of business performance (revenue trends, weather impact, busy periods)

**The goal of this project is to replace all of the above with a structured, automated system — built in four stages.**

---

## Project Stages

| Stage | Focus | Status |
|-------|-------|--------|
| 1 | Booking system & diary automation | In progress |
| 2 | New website | Planned |
| 3 | Accounts & invoicing | Planned |
| 4 | Marketing automation | Planned |

---

## Stage 1 — Booking System & Database

### What I built

A relational database in SQLite that replaces the scattered manual records with a single structured system.

**7 tables designed from scratch:**

| Table | Purpose |
|-------|---------|
| `client` | Every customer — name, address, parish, preferred contact method |
| `vehicle` | Vehicles per client — registration, size, make/model/colour |
| `service` | Price list — every service with duration and price |
| `package` | Regular 3-month subscriptions — visit tracking and renewal alerts |
| `appointment` | Every booking — links client, vehicle, service, staff and parish |
| `staff` | Team members — designed to scale as the business grows |
| `weather_event` | Logs every weather disruption — builds into revenue impact data over time |

### Key design decisions

**Parish is stored on every appointment.** Jersey has 12 parishes. By storing parish on each booking, the diary can be sorted to cluster appointments geographically — cutting daily travel time significantly. This came directly from analysing the business process using Lean Six Sigma mapping techniques.

**Vehicle size drives duration and price automatically.** Rather than Penny manually calculating the right price per booking, the service table stores duration and price per vehicle size. The correct values are looked up automatically when a booking is made.

**Package visits_used vs total_visits.** When `visits_used = total_visits`, an automation trigger fires a renewal reminder. No more chasing clients manually.

**weather_flag on every appointment.** Every cancellation caused by weather is logged. After 12 months this becomes a dataset — showing exactly which months lose the most revenue, justifying deposit policies or weather surcharges.

**Staff table built to scale.** Currently two staff members. Adding a third is one INSERT statement. All appointment history is preserved when staff change.

### SQL queries built

```sql
-- Sort the day's diary by parish to minimise travel
SELECT first_name, last_name, phone, parish, appointment_time, service_name
FROM appointment
JOIN client USING (client_id)
JOIN service USING (service_id)
WHERE appointment_date = date('now')
ORDER BY parish, appointment_time;

-- Find all packages due for renewal
SELECT first_name, last_name, phone, preferred_contact,
       total_visits, visits_used, end_date
FROM package
JOIN client USING (client_id)
WHERE visits_used = total_visits
AND status = 'active';

-- Weather impact report — appointments affected per month
SELECT strftime('%Y-%m', event_date) AS month,
       SUM(appointments_affected) AS total_affected
FROM weather_event
GROUP BY month
ORDER BY month;

-- Count clients per parish
SELECT parish, COUNT(*) AS total_clients
FROM client
GROUP BY parish
ORDER BY total_clients DESC;
```

---

## Tools & Technologies

| Tool | Purpose |
|------|---------|
| SQLite | Database engine |
| DB Browser for SQLite | Visual database interface |
| Python (pandas) | Data manipulation — in progress |
| n8n | Workflow automation — weather alerts, reminders |
| Power BI | Business dashboard — planned for Stage 3 |
| Git & GitHub | Version control and portfolio |

---

## Skills Demonstrated

- **Relational database design** — normalised schema, primary and foreign keys, referential integrity
- **SQL** — SELECT, WHERE, JOIN, GROUP BY, ORDER BY, aggregate functions
- **Business process analysis** — Lean Six Sigma process mapping applied to identify automation opportunities
- **Real-world problem solving** — every design decision is driven by an actual business need, not a tutorial exercise
- **Version control** — Git workflow, commit discipline, .gitignore for data protection

---

## About This Project

This is a live project for a real trading business. The client data used in development is fictional. The `.db` file is excluded from this repository via `.gitignore` to protect any real data.

This project is part of a career development journey from Excel/Power BI analyst to data and automation developer.

---

## Project Structure

```
pennys-valet-db/
├── create_tables.sql      # Full database schema — all 7 tables
├── sample_data.sql        # Test data for development (fictional clients)
├── queries/
│   ├── diary_routing.sql  # Parish-sorted daily diary
│   ├── renewals.sql       # Package renewal alerts
│   └── weather_report.sql # Weather impact analysis
└── README.md
```

---

*Jersey, Channel Islands — Stage 1 of 4 in progress*
