import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 10,
  duration: '2m',
  thresholds: {
    http_req_duration: ['p(90)<800', 'p(95)<1200'],
    http_req_failed: ['rate<0.01'],
  },
};

const BASE = __ENV.BASE_URL || 'http://localhost:8080';
const HEADERS = {
  Accept: 'application/json',
  'Content-Type': 'application/json',
};

export default function () {
  // Products catalog
  const products = http.get(`${BASE}/api/products`, { headers: HEADERS });
  check(products, {
    'products 200': (r) => r.status === 200,
  });

  // Shops active
  const shops = http.get(`${BASE}/api/v1/shops/active?page=0&size=20`, { headers: HEADERS });
  check(shops, {
    'shops 200': (r) => r.status === 200,
  });

  // Reviews (product id dummy UUID replace if needed)
  const reviews = http.get(`${BASE}/api/v1/reviews/product/00000000-0000-0000-0000-000000000001`, {
    headers: HEADERS,
  });
  check(reviews, {
    'reviews 200|404': (r) => r.status === 200 || r.status === 404,
  });

  sleep(1);
}





