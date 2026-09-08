# AhmedBaba E-commerce Platform
**Global B2B Trade Ecosystem - Premium 1688 Clone**

AhmedBaba is an enterprise-grade B2B e-commerce platform built to completely mimic the sophisticated supplychain, catalog, and escrow structures of Alibaba/1688.

## System Architecture

The ecosystem relies on three distinct layers ensuring massive scalability and fault-tolerance:

1. **Frontend Flutter Mobile Application (Client Layer)**
   - **Framework:** Flutter (Dart)
   - **UI/UX Strategy:** 100% high-fidelity clone of Alibaba with features like Master Data Feeds, Verified Badge Badges, Bulk Tiered Pricing, and RFQ generation.
   - **State Management:** BLoC (Business Logic Component).
   - **Routing:** Deep nesting, Auth-protected shells.

2. **Backend Services Layer (Go Microservices)**
   - Decentralized architecture comprising separate microservices for `Catalog`, `Orders` (Escrow), `Auth`, `Logistics`, and `Notifications`.
   - **Internal Comms Protocol:** gRPC via Protocol Buffers.
   - **Datastores:** 
     - **PostgreSQL / GORM** for ACID transactional records (Orders, Wallets).
     - **MongoDB** for unstructured Catalog items.
     - **Elasticsearch** (planned) for rapid full-text product searching.

3. **API Gateway & Admin Panel (Node.js & Next.js)**
   - **API Gateway:** Central orchestration layer proxying HTTP requests into fast internal gRPC procedures.
   - **Admin Dashboard:** Next.js based control room monitoring active escrow accounts, RFQs, and live 1688 data synchronization intervals.

## Getting Started

### 1. Requirements
Ensure the following are installed and configured:
- Flutter SDK (v3.0+)
- Go (v1.20+)
- Node.js (v18+)
- Docker & Docker Compose (for infrastructure)

### 2. Booting up the Infrastructure (Database / Brokers)
Run the core infrastructure via Docker Compose:
```bash
docker-compose up -d
```

### 3. Launching Microservices
Navigate into the respective microservice directory and utilize the Go run command. Example for Catalog Service:
```bash
cd services/catalog_service
go run cmd/server/main.go
```

### 4. Running the Flutter App
Initialize flutter dependencies and build the release environment:
```bash
flutter pub get
flutter run --release
# To build an APK for Android users
flutter build apk --release
```

### Note on 1688 API Constraints
This branch is built relying on third-party 1688 APIs (like RapidAPI proxies) because the official 1688 Open SDK has severe geographic and business registration lockouts for international requests. To enable live sync, update your API token configuration inside the Admin Panel.

## Features at a Glance:
- **Smart Product Feed**: Tiered MoQ (Minimum Order Quantity) Pricing.
- **Escrow Mechanics**: Secure, locked transaction vaults releasing funds only upon confirmed delivery milestones.
- **Negotiation Inbox**: Direct chat with verified sellers.
- **RFQ System**: Allow global buyers to request custom quotations with target prices.

**Developed internally for DVM Japan / Zoja Brands Ecosystem.**
