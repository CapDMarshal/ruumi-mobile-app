# Frontend Planning - RUUMI Listing Flow

This document outlines the frontend plan for the Draft-to-Publish listing flow.

## Step Map (Route + Step Index)

- Step 0: Listings page (CTA: Get Started)
- Step 1: Listing Type (house, villa, etc.)
- Step 2: Location + Address (map/pin, street, city, postal)
- Step 3: Property Details (capacity, beds, baths, size)
- Step 4: Furnished (yes/no + optional details)
- Step 5: Amenities (tags/checkboxes)
- Step 6: Photos (add photo grid, minimum requirement)
- Step 7: Property Title
- Step 8: Description
- Step 9: Booking Settings (approve manually or instant book)
- Step 10: Price (base price)
- Step 11: Discount Coupons
- Step 12: Review + Upload/Publish

## State Model (Single Draft State)

- listingId (string)
- currentStep (int)
- data (partial draft payload)
  - propertyTypeId, spaceType
  - latitude, longitude
  - addressLine1, city, postalCode
  - maxGuests, bedrooms, bathrooms, propertySize
  - title, description
  - bookingType (string)
  - basePrice (double)
  - furnished (bool), furnishedDetails (optional, UI only)
  - amenities (list of string ids, UI only)
  - photos (list of local paths + uploaded urls, UI only)
  - discountCoupons (list, UI only)
- isLoading (bool)
- errorMessage (string or null)

## Draft Persistence

- Save listingId + currentStep to SharedPreferences after each successful API call.
- On app start, restore and route to the last saved step.

## API Calls Per Step

- Step 1: GET /property-types (options)
- After Step 1 Next: POST /listings (create draft and store listingId)
- Step 2+ Each Next: PATCH /listings/{id} (only changed fields)
- Final: POST /listings/{id}/publish

## API Mapping Per Step (from OpenAPI schema)

Payloads are based on ListingCreate and ListingUpdate:

- Step 1: Listing Type
  - Create draft (POST /listings)
    - property_type_id (string)
    - space_type (string)

- Step 2: Location + Address
  - Update draft (PATCH /listings/{id})
    - latitude (number)
    - longitude (number)
    - address_line_1 (string)
    - city (string)
    - postal_code (string)

- Step 3: Property Details
  - Update draft
    - max_guests (int)
    - bedrooms (int)
    - bathrooms (number)
    - property_size (int)

- Step 4: Furnished
  - UI only (no API field)

- Step 5: Amenities
  - UI only (no API field)

- Step 6: Photos
  - UI only (no API field in current schema; backend may validate at publish)

- Step 7: Property Title
  - Update draft
    - title (string)

- Step 8: Description
  - Update draft
    - description (string)

- Step 9: Booking Settings
  - Update draft
    - booking_type (string) // approve manually or instant book

- Step 10: Price
  - Update draft
    - base_price (number, must be > 0)

- Step 11: Discount Coupons
  - UI only (no API field)

- Step 12: Review + Upload/Publish
  - Publish (POST /listings/{id}/publish)

## Validation + UI Feedback

- If latitude is set, require longitude.
- base_price > 0.
- Publish can return 422 with detail message. Show Snackbar or Dialog.
- Show loading overlays during API calls. Disable Next on invalid forms.

## UI Building Blocks

- StepScaffold: title, progress, content slot, bottom CTA.
- DraftStepController: handles Next/Back, API calls, persistence.
- Shared form field widgets with validation.
- Media picker component for photos.
