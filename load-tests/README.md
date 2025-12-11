# Load Tests

Quick smoke test with k6 to cover main read paths.

## Prerequisites
- k6 installed (https://k6.io)
- Services up via API Gateway (default: http://localhost:8080)

## Smoke test
```bash
cd load-tests
k6 run k6-smoke.js
# or with custom gateway URL
BASE_URL=http://localhost:8080 k6 run k6-smoke.js
```

## Checkout flow (simplified)
```bash
# set real IDs via env if available
BASE_URL=http://localhost:8080 \
USER_ID=00000000-0000-0000-0000-000000000001 \
PRODUCT_ID=00000000-0000-0000-0000-000000000001 \
k6 run k6-checkout.js
```

## What it hits
- GET /api/products
- GET /api/v1/shops/active?page=0&size=20
- GET /api/v1/reviews/product/{dummy-uuid}
  (Checkout script: GET /api/products/{id}, POST /api/orders)
  (Upload script: POST /api/v1/media/upload)

Thresholds:
- http_req_duration p(90)<800ms, p(95)<1200ms
- http_req_failed <1%

## Upload test (media-service)
```bash
BASE_URL=http://localhost:8080 \
USER_ID=00000000-0000-0000-0000-000000000001 \
k6 run k6-upload.js
```

