# Observability Questions
<!-- category: observability -->
<!-- icon: 📊 -->
<!-- author: discovery-team -->
<!-- created: 2026-01-02 -->

## Mô tả

Bộ câu hỏi về Observability - logging, monitoring, tracing, alerting.
Đây là category **bị thiếu** trong question-bank gốc.

---

## Câu hỏi

### 1. Logging Infrastructure
<!-- id: obs-01 -->
<!-- depth: 1 -->

**Câu hỏi:** Hệ thống logging được cấu hình như thế nào? Sử dụng library nào?

**Tìm ở đâu:**
- `**/log*` - Log-related files
- `**/logger*` - Logger configurations
- `**/*.yaml` - Config files có thể chứa log settings
- `go.mod` hoặc `package.json` - Dependencies

**Keywords:** log, logger, logging, slog, zap, logrus, winston, pino, log4j

---

### 2. Log Levels & Formats
<!-- id: obs-02 -->
<!-- depth: 2 -->
<!-- depends: obs-01 -->

**Câu hỏi:** Các log levels được sử dụng? Format output (JSON, text)?

**Tìm ở đâu:**
- `**/log*`
- `**/config*`

**Keywords:** debug, info, warn, error, fatal, level, format, json, structured

---

### 3. Metrics Collection
<!-- id: obs-03 -->
<!-- depth: 2 -->

**Câu hỏi:** Có thu thập metrics không? Sử dụng tool nào (Prometheus, StatsD, etc.)?

**Tìm ở đâu:**
- `**/metrics*`
- `**/prometheus*`
- `**/statsd*`
- `**/*.yaml` - Config files

**Keywords:** metrics, prometheus, statsd, counter, gauge, histogram, grafana

---

### 4. Distributed Tracing
<!-- id: obs-04 -->
<!-- depth: 2 -->

**Câu hỏi:** Có implement distributed tracing không? (OpenTelemetry, Jaeger, Zipkin)?

**Tìm ở đâu:**
- `**/trace*`
- `**/tracing*`
- `**/otel*`
- `**/jaeger*`

**Keywords:** trace, tracing, span, opentelemetry, otel, jaeger, zipkin, correlation

---

### 5. Health Checks
<!-- id: obs-05 -->
<!-- depth: 1 -->

**Câu hỏi:** Có health check endpoints không? Liveness vs Readiness?

**Tìm ở đâu:**
- `**/health*`
- `**/ready*`
- `**/live*`
- `**/*handler*`
- `**/routes*`

**Keywords:** health, healthy, ready, readiness, live, liveness, ping, status

---

### 6. Alerting Configuration
<!-- id: obs-06 -->
<!-- depth: 3 -->
<!-- depends: obs-03 -->

**Câu hỏi:** Alerting được cấu hình như thế nào? Thresholds? Escalation?

**Tìm ở đâu:**
- `**/alert*`
- `**/*.rules`
- `**/prometheus*`
- `**/*-alerts.yaml`

**Keywords:** alert, alerting, threshold, notification, pagerduty, slack, escalation

---

### 7. Error Tracking
<!-- id: obs-07 -->
<!-- depth: 2 -->

**Câu hỏi:** Có sử dụng error tracking service không? (Sentry, Rollbar, etc.)

**Tìm ở đâu:**
- `**/sentry*`
- `**/error*`
- `**/*.config*`

**Keywords:** sentry, rollbar, bugsnag, error tracking, exception, crash

---

### 8. Dashboard & Visualization
<!-- id: obs-08 -->
<!-- depth: 2 -->
<!-- depends: obs-03 -->

**Câu hỏi:** Có dashboards cho monitoring không? Grafana? Custom?

**Tìm ở đâu:**
- `**/dashboard*`
- `**/grafana*`
- `**/*.json` - Dashboard definitions

**Keywords:** dashboard, grafana, kibana, visualization, panel

---

*Bộ câu hỏi này bổ sung cho question-bank.yaml, focus vào Observability.*
