# Goal Description

Set up and build a Flutter application for the RUUMI "Create Property Listing" flow, satisfying the technical assessment requirements. The app must handle a multi-step "Draft-to-Publish" flow, ensure robust state management, resume drafts after app force-closes, and elegantly handle API validations and network errors.

## Technical Choices (Approved)

- **State Management**: `flutter_riverpod` (with code generation)
- **Local Storage**: `shared_preferences`
- **Networking**: `dio`
- **Routing**: `go_router`
- **Architecture**: Feature-first
- **Project Scope**: Setup the API data layer, local storage, and state management first. The user will handle UI based on Figma later.

## Proposed Architecture

### 1. Folder Structure (Feature-First)
```text
lib/
 ┣ core/
 ┃ ┣ network/        (Dio client, interceptors, error handling)
 ┃ ┣ storage/        (Local storage service for draft resumption via shared_preferences)
 ┃ ┣ routing/        (go_router setup)
 ┃ ┗ exceptions/     (Custom API Exceptions, 422 handlers)
 ┣ features/
 ┃ ┗ property_listing/
 ┃   ┣ data/
 ┃   ┃ ┣ models/     (Freezed + JSON Serializable API models)
 ┃   ┃ ┗ listing_repository.dart
 ┃   ┣ domain/       (Entities)
 ┃   ┗ presentation/ (Riverpod providers for state)
 ┣ main.dart
```

### 2. Dependencies to Install
- `flutter_riverpod`, `riverpod_annotation`, `dio`, `shared_preferences`, `go_router`, `freezed_annotation`, `json_annotation`
- Dev: `build_runner`, `riverpod_generator`, `freezed`, `json_serializable`

### 3. API Setup & Data Flow
- **Models**:
  - `PropertyTypeResponse`
  - `ListingCreate`, `ListingUpdate`
  - `ListingResponse`
- **Repository**:
  - `getPropertyTypes()` -> `GET /property-types`
  - `createListing(ListingCreate)` -> `POST /listings/`
  - `updateListing(String id, ListingUpdate)` -> `PATCH /listings/{id}`
  - `publishListing(String id)` -> `POST /listings/{id}/publish`
- **State Management (Riverpod)**:
  - `listingDraftProvider`: Manages the current drafting state (step, listing ID, partial data).
  - Integrates with `shared_preferences` to automatically save the draft progress and resume upon restart.

## Verification Plan
1. Ensure all `freezed` and `json_serializable` code generation runs successfully.
2. Verify the API repository methods map correctly to the API endpoints and JSON bodies.
3. Verify that `dio` is configured with the correct base URL (`https://propertylisting-oyjm.onrender.com/api/v1/`).
