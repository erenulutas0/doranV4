import http from 'k6/http';
import { check, sleep } from 'k6';
import { randomString } from 'https://jslib.k6.io/k6-utils/1.4.0/index.js';

export const options = {
  vus: 3,
  duration: '2m',
  thresholds: {
    http_req_duration: ['p(90)<1500', 'p(95)<2000'],
    http_req_failed: ['rate<0.05'],
  },
};

const BASE = __ENV.BASE_URL || 'http://localhost:8080';
const USER_ID = __ENV.USER_ID || '00000000-0000-0000-0000-000000000001';

export default function () {
  const boundary = '----WebKitFormBoundary' + randomString(16);
  const payload = [
    `--${boundary}`,
    'Content-Disposition: form-data; name="file"; filename="test.txt"',
    'Content-Type: text/plain',
    '',
    'hello from k6 upload test',
    `--${boundary}`,
    `Content-Disposition: form-data; name="uploadedBy"`,
    '',
    USER_ID,
    `--${boundary}--`,
    '',
  ].join('\r\n');

  const res = http.post(`${BASE}/api/v1/media/upload`, payload, {
    headers: {
      'Content-Type': `multipart/form-data; boundary=${boundary}`,
    },
  });

  check(res, {
    'upload 201|200': (r) => r.status === 201 || r.status === 200,
  });

  sleep(1);
}





