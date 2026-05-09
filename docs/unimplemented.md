# Unimplemented / Remaining Tasks

This file lists remaining work, prioritized and grouped so you can pick next improvements.

1) High priority
- Photo upload: integrate `image_picker` / native file picker, compress images, and implement multipart upload to `POST /listings/{id}/photos` or the correct endpoint. Wire progress UI and persist server IDs to the draft.
- Publish error handling: parse API 422 responses and show field-level errors or a descriptive dialog (e.g., "Minimum 5 photos required"). Ensure `ListingRepository` surfaces 422 details to the UI.

2) Medium priority
- Persist UI selections: send amenities, furnished state, booking settings, discounts properly in `PATCH /listings/{id}` payloads.
- Photos UX: thumbnails, reorder, delete, local caching before upload.
- Form validation: unify validators and surface errors inline (title length, price > 0, property_size > 0).

3) Low priority / polish
- E2E tests: add integration tests (Flutter Driver / integration_test) for Draft resume and Publish scenarios.
- Unit tests: providers, repository (mock Dio), and model serialization tests.
- Accessibility: semantic labels, contrast checks, screen reader flow for multi-step UI.
- Localization: extract strings and add support for i18n.

4) Ops / CI
- CI pipeline: run `flutter analyze`, `flutter test`, and `dart run build_runner test` on PRs.
- Release notes and build instructions for iOS/Android (App Store / Play Store) and Windows builds.

5) Optional improvements
- Offline-first: cache partial updates locally and sync when online.
- Image CDN and background upload worker for large photo sets.

If you'd like I can start implementing items in order of priority — I recommend starting with photo picking + upload, then publish 422 error UI.
