import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 5,
  duration: '3m',
  thresholds: {
    http_req_duration: ['p(90)<1000', 'p(95)<1500'],
    http_req_failed: ['rate<0.02'],
  },
};

const BASE = __ENV.BASE_URL || 'http://localhost:8080';
const HEADERS = {
  Accept: 'application/json',
  'Content-Type': 'application/json',
};

// Dummy payloads; adjust IDs to real ones in your data set
const USER_ID = __ENV.USER_ID || '00000000-0000-0000-0000-000000000001';
const PRODUCT_ID = __ENV.PRODUCT_ID || '00000000-0000-0000-0000-000000000001';

export default function () {
  // Step 1: Fetch product detail (snapshot)
  const prod = http.get(`${BASE}/api/products/${PRODUCT_ID}`, { headers: HEADERS });
  check(prod, {
    'product 200|404': (r) => r.status === 200 || r.status === 404,
  });

  // Step 2: Create order (simplified payload)
  const payload = JSON.stringify({
    userId: USER_ID,
    orderItems: [
      {
        productId: PRODUCT_ID,
        quantity: 1,
      },
    ],
    shippingAddress: 'Test Street',
    city: 'Test City',
    zipCode: '00000',
    phoneNumber: '0000000000',
  });

  const res = http.post(`${BASE}/api/orders`, payload, { headers: HEADERS });
  check(res, {
    'order create 200|201|400|404': (r) =>
      r.status === 200 || r.status === 201 || r.status === 400 || r.status === 404,
  });

  sleep(1);
}





