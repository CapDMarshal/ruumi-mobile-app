# RUUMI Property Listing (Flutter)

This project implements the RUUMI Draft-to-Publish property listing flow using the provided API contract and Figma references. It focuses on robust data handling, draft persistence, and safe error handling.

## Requirements

- Flutter SDK 3.x
- Dart SDK 3.x

## Setup

1. Install dependencies:

```bash
flutter pub get
```

2. Generate code (Freezed, Riverpod, JSON):

```bash
dart run build_runner build -d
```

## Run

```bash
flutter run
```

## Architecture and State Management

- Architecture: Feature-first
- State management: Riverpod (with code generation)
- Networking: Dio
- Local storage: SharedPreferences
- Routing: go_router

Core layers:

- core/network: Dio client and interceptors
- core/storage: Local storage service for draft resumption
- core/routing: go_router setup
- features/property_listing/data: API models and repository

## Draft-to-Publish Flow

1. Step 1: Fetch property types (GET /property-types)
2. Create draft (POST /listings) to get listing.id
3. Steps 2-5: Partial updates (PATCH /listings/{id})
4. Publish (POST /listings/{id}/publish)

## Draft Resumption (Force-Close Scenario)

How it is handled:

- listing.id and the current step are saved in SharedPreferences after each successful API call.
- On app startup, the draft state is restored and the user is routed to the last saved step.

How it was tested:

1. Complete Step 1 and proceed to Step 3.
2. Force-close the app from the OS task switcher.
3. Reopen the app and confirm it resumes at Step 3 with the stored listing.id.

## Error and Validation Handling

- Loading state is shown during API calls.
- Network timeouts and request failures are caught and surfaced to the user.
- API validation rules are respected:
	- If latitude is provided, longitude is also required.
	- base_price must be > 0.
- Publish 422 error is captured and displayed to the user (for example: "Minimum 5 photos required").

## API References

- Base URL: https://propertylisting-oyjm.onrender.com/
- Swagger UI: https://propertylisting-oyjm.onrender.com/docs
- Figma: https://www.figma.com/design/R5I1Oy75M0iU2KwXCSdwZR/Landlord-Listing-RUUMI

## Screenshots

Add your screenshots to this section. Recommended path:

```
docs/screenshots/
```

Then reference them here, for example:

```
![Step 1](docs/screenshots/step-1.png)
![Step 2](docs/screenshots/step-2.png)
![Step 3](docs/screenshots/step-3.png)
![Step 4](docs/screenshots/step-4.png)
![Step 5](docs/screenshots/step-5.png)
```
