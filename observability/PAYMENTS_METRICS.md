# Payments & Refunds Observability

Artifacts:
- Prometheus rules: `observability/prometheus/payment_rules.yml`
- Grafana dashboard: `observability/grafana/payments-dashboard.json`

Micrometer metrics (order-service):
- `orders_payment_success_count_total`, `orders_payment_fail_count_total`, `orders_payment_pending_count_total`
- `orders_refund_request_count_total`, `orders_refunded_count_total`
- `orders_status_change_count_total{to=...}`, `orders_created_count_total`, `orders_cancelled_count_total`, `orders_delivered_count_total`
- Timer: `orders_created_duration_seconds_*` (if needed for latency)

Key SLIs (suggested):
- Payment success rate = success / (success+fail)
- Refund success rate = refunded / (refunded+requests)
- Payment fail rate and volume (spikes)
- Order funnel: created → delivered vs cancelled

Prometheus
- Include `payment_rules.yml` in your Prometheus config (rule_files).
- Alerts:
  - PaymentSuccessRateLow (<0.9 for 10m)
  - PaymentFailureSpike (>0.1/s for 5m)
  - RefundSuccessRateLow (<0.8 for 10m)
  - PaymentTrafficDrop (volume near zero for 15m)

Grafana
- Import `observability/grafana/payments-dashboard.json`.
- Set datasource to Prometheus (`DS_PROMETHEUS` variable).

Adjustments
- Tweak thresholds per environment (dev vs prod).
- If metric names differ, check `/actuator/prometheus` to confirm the Micrometer naming in your deployment.***

