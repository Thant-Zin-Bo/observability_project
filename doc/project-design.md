
# GCP Incident-Ready Observability Platform

**Status:** Planning  
**Owner:** Thant Zin Bo  
**Repository:** `https://github.com/Thant-Zin-Bo/gcp-incident-ready-observability-platform`  
**Target roles:** SRE Engineer, Observability Engineer, Platform Operations Engineer, Cloud Operations Engineer  
**Start date:** July 2026  
**Target completion:** October 2026  
**Version:** 0.2  

---

## 1. Executive Summary

This project demonstrates a production-style observability platform for a containerized Python API deployed on Google Cloud Platform (GCP).

Terraform provisions cloud infrastructure. Ansible configures a Compute Engine virtual machine and deploys the application. The application is instrumented with OpenTelemetry and sends metrics, logs, and traces through Grafana Alloy to Grafana Cloud.

Grafana dashboards, alerts, Service Level Objectives (SLOs), error-budget views, runbooks, controlled incident scenarios, and a post-incident review provide an incident-ready operational workflow.

The purpose is to build independently demonstrable hands-on experience in infrastructure as code, cloud operations, configuration management, observability, SLO-driven reliability, alerting, incident response, capacity planning, and operational documentation.

---

## 2. Problem Statement

Small services can fail in ways that are difficult to diagnose without clear operational visibility. Common failure patterns include high latency, increased HTTP errors, unavailable dependencies, application crashes, resource exhaustion, and incorrect configuration changes.

Without correlated metrics, logs, and traces, engineers may detect an issue late and spend too long identifying its root cause. Manual and undocumented deployment processes also make systems harder to reproduce, maintain, and recover.

This project addresses these problems by creating a reproducible cloud environment with structured observability, actionable alerts, defined reliability targets, controlled failure scenarios, and documented response procedures.

---

## 3. Project Goals

The project will:

- Provision GCP infrastructure reproducibly using Terraform
- Use Git and pull-request workflow to manage infrastructure, application, configuration, dashboards, alert rules, and documentation
- Configure a Compute Engine virtual machine with idempotent Ansible playbooks
- Deploy a containerized Python/FastAPI application
- Instrument the application with OpenTelemetry
- Collect metrics, structured logs, and traces
- Send telemetry to Grafana Cloud through Grafana Alloy
- Build dashboards for service health, traffic, errors, latency, saturation, and SLO status
- Configure actionable alerts for service unavailability, high error rate, high latency, and telemetry pipeline failures
- Define Service Level Indicators (SLIs), Service Level Objectives (SLOs), and error budgets for the application
- Demonstrate at least one alert based on error-budget burn rate
- Simulate controlled incidents and document detection, investigation, mitigation, verification, and prevention
- Perform a basic capacity experiment to connect traffic, resource usage, latency, cost, and reliability targets
- Publish runbooks, an architecture diagram, technical decisions, a post-incident review, and a recruiter-friendly project summary
- Demonstrate a clean infrastructure teardown process to control cloud costs

---

## 4. Non-Goals

The first release will not include:

- A production service for external users
- Multi-region high availability or disaster recovery
- A large Kubernetes or GKE environment
- A full security information and event management solution
- A full CI/CD pipeline with automated production releases
- A custom machine-learning anomaly-detection model
- Enterprise compliance certification or complete ISO 27001 implementation
- Load testing at production scale
- Automatic remediation of all alerts

These items may be considered as future enhancements after the minimum viable platform is complete.

---

## 5. Success Criteria

The first release is complete when all conditions below are met.

### 5.1 Infrastructure and Deployment

- [ ] `terraform fmt`, `terraform validate`, and `terraform plan` complete successfully
- [ ] Terraform provisions the required GCP infrastructure
- [ ] Terraform remote state is stored outside the Git repository
- [ ] GCP resources use labels such as environment, component, and owner
- [ ] Ansible configures the VM successfully
- [ ] Ansible playbooks can run twice without making unexpected changes
- [ ] The FastAPI application is deployed as a container and responds to health checks
- [ ] The environment can be removed cleanly using Terraform

### 5.2 Observability

- [ ] Grafana displays service and host metrics
- [ ] Grafana displays structured application logs
- [ ] Grafana displays traces for API requests
- [ ] A dashboard shows availability, traffic, error rate, p95 latency, and saturation
- [ ] Availability and latency SLOs are defined and documented
- [ ] Error-budget consumption is visible in Grafana or documented with Prometheus queries
- [ ] A service-down alert is tested successfully
- [ ] A high-error-rate alert is tested successfully
- [ ] A high-latency alert is tested successfully
- [ ] At least one alert is based on error-budget burn rate
- [ ] Each alert links to a relevant runbook
- [ ] Dashboard and alert definitions are version controlled where practical

### 5.3 Operational Readiness

- [ ] Three controlled incident scenarios are documented and demonstrated
- [ ] At least three runbooks are committed to the repository
- [ ] One detailed blameless post-incident review is committed to the repository
- [ ] A basic capacity experiment is completed and documented
- [ ] A new user can run the local environment using README instructions
- [ ] A five-minute demo video shows deployment, alerting, investigation, recovery, and documentation
- [ ] A recruiter can understand the purpose, architecture, skills, and evidence from the README

---

## 6. Requirements

### 6.1 Functional Requirements

| ID | Requirement |
|---|---|
| FR-01 | The application must provide `/health` and `/metrics` endpoints |
| FR-02 | The application must provide controlled fault endpoints for latency, errors, and dependency failure |
| FR-03 | Terraform must provision VPC networking, subnet, firewall rules, Compute Engine VM, service account, labels, and remote state storage |
| FR-04 | Ansible must install required packages, Docker, Docker Compose, Grafana Alloy, and application configuration |
| FR-05 | Grafana Alloy must forward application and host telemetry to Grafana Cloud |
| FR-06 | Grafana must show dashboards for Golden Signals, SLO status, and host health |
| FR-07 | Alert rules must detect service-down, high-error-rate, high-latency, and telemetry pipeline failure conditions |
| FR-08 | The project must define availability and latency SLOs and their corresponding SLIs |
| FR-09 | The project must display or calculate error-budget consumption |
| FR-10 | GitHub Actions must validate Terraform formatting and configuration |
| FR-11 | GitHub Actions must run Ansible linting |
| FR-12 | GitHub Actions must run Python unit tests and linting |
| FR-13 | GitHub Actions must include secret scanning |
| FR-14 | The project must include runbooks and one post-incident review |
| FR-15 | A basic capacity experiment must record traffic, resource usage, and latency at multiple load levels |

### 6.2 Non-Functional Requirements

| ID | Requirement |
|---|---|
| NFR-01 | The project must be reproducible from a new GCP project |
| NFR-02 | No secret, token, service-account key, Terraform state file, or `.env` file may be committed to Git |
| NFR-03 | The GCP service account must use least-privilege access |
| NFR-04 | SSH access must not be open to the public internet |
| NFR-05 | The platform must use one small Compute Engine VM for Version 1 |
| NFR-06 | A GCP budget alert must be configured before provisioning resources |
| NFR-07 | Documentation must explain installation, verification, incident simulation, SLOs, capacity experiment, and teardown |
| NFR-08 | The project must use version-controlled configuration for dashboards and alerts where practical |
| NFR-09 | The README must include a recruiter-facing summary of demonstrated SRE skills |
| NFR-10 | Documentation and screenshots must not expose tokens, private IP addresses, or sensitive environment details |

---

## 7. Architecture Overview

### 7.1 Logical Architecture

```text
Developer
    |
    v
GitHub Repository
    |
    +-- Pull Requests
    +-- GitHub Actions validation
    |
    +-- Terraform
    |      |
    |      v
    |   GCP Infrastructure
    |      |
    |      +-- VPC
    |      +-- Subnet
    |      +-- Firewall rules
    |      +-- Service account
    |      +-- Compute Engine VM
    |      +-- Cloud Storage remote state
    |
    +-- Ansible
           |
           v
     Compute Engine VM
           |
           +-- Docker and Docker Compose
           +-- FastAPI order-api
           +-- Grafana Alloy
           |
           +-- Metrics
           +-- Logs
           +-- Traces
                    |
                    v
              Grafana Cloud
                    |
                    +-- Dashboards
                    +-- SLO and error-budget views
                    +-- Explore
                    +-- Alerting
                    +-- Incident investigation
```

### 7.2 Architecture Principles

Terraform provisions cloud resources. Ansible configures the operating system and deploys application services. Docker runs the application. Grafana Alloy collects and forwards telemetry. Grafana Cloud provides dashboards, correlation, querying, alerting, and SLO visibility.

This separation demonstrates that infrastructure provisioning, configuration management, application deployment, and observability are related but distinct responsibilities.

The Version 1 architecture intentionally uses one VM to control cost and complexity. This design is not highly available; the single VM is also an intentional failure domain used for operational learning and incident simulation.

---

## 8. Components

| Component | Technology | Responsibility |
|---|---|---|
| Source control | Git and GitHub | Version control, branches, pull requests, issues, CI validation |
| Infrastructure as Code | Terraform | Provision and update GCP infrastructure reproducibly |
| Cloud provider | Google Cloud Platform | Provides networking, compute, identity, storage, and budget controls |
| Compute | Compute Engine | Runs application and telemetry components |
| Configuration management | Ansible | Configures VM, installs software, deploys application, applies templates |
| Application | Python and FastAPI | Provides API endpoints and produces telemetry |
| Container runtime | Docker and Docker Compose | Builds and runs application services |
| Telemetry standard | OpenTelemetry | Instruments and exports metrics, logs, and traces |
| Telemetry collector | Grafana Alloy | Receives, processes, and forwards telemetry |
| Observability platform | Grafana Cloud | Dashboards, data exploration, correlation, SLO views, and alerting |
| CI validation | GitHub Actions | Runs Terraform validation, Ansible linting, Python tests, and secret scanning |
| Documentation | Markdown | Explains architecture, decisions, operations, incidents, capacity, and learning |

---

## 9. Technology Decisions

| Decision Area | Selected Technology | Rationale |
|---|---|---|
| Cloud platform | GCP | Builds practical GCP experience and supports the cloud portion of the portfolio |
| Infrastructure provisioning | Terraform | Enables repeatable infrastructure, version control, planning, drift awareness, and modular design |
| Configuration management | Ansible | Demonstrates idempotent VM configuration after infrastructure provisioning |
| Initial compute approach | One Compute Engine VM | Keeps cost and complexity low while demonstrating real cloud operations |
| Application framework | Python/FastAPI | Matches Python experience, is lightweight, and is easy to instrument |
| Telemetry format | OpenTelemetry | Provides vendor-neutral metrics, logs, and traces instrumentation |
| Telemetry collector | Grafana Alloy | Provides a modern Grafana-compatible telemetry pipeline |
| Observability backend | Grafana Cloud | Supports logs, metrics, traces, dashboards, alerting, and data correlation |
| Version control platform | GitHub | Makes code, documentation, commit history, pull requests, and CI visible to recruiters |
| Container platform | Docker Compose | Provides a simple, reproducible deployment method before a Kubernetes extension |
| SLO approach | Availability and latency SLOs | Demonstrates reliability engineering beyond static metric thresholds |
| Load testing | `hey`, Locust, or Python script | Enables a small capacity experiment without introducing unnecessary complexity |

---

## 10. Project Phases

| Phase | Name | Main Outcome | Evidence |
|---|---|---|---|
| 0 | Project design | Scope, architecture, success criteria, decisions, risk controls | Design document, ADRs, diagram |
| 1 | Local application | Containerized FastAPI service with health, metrics, logs, traces, and controlled faults | Source code, tests, Dockerfile |
| 2 | Local observability | Local dashboards, alerts, logs, metrics, and traces | Docker Compose, dashboard JSON, alert rules |
| 3 | GCP infrastructure | Reproducible GCP environment | Terraform modules, plan output, architecture update |
| 4 | Configuration management | VM configured and application deployed repeatedly | Ansible roles, dynamic inventory, idempotence evidence |
| 5 | Grafana Cloud | GCP telemetry, dashboards, alerts, SLO views, and investigation in Grafana Cloud | Screenshots, dashboard export, alert testing |
| 6 | Incident readiness | Controlled incidents, runbooks, and postmortem | Runbooks, postmortem, demo video |
| 7 | Capacity experiment | Traffic, CPU, memory, latency, and cost trade-off analysis | `docs/capacity-notes.md`, screenshots, findings |
| 8 | Optional Kubernetes | Migration to local Kubernetes or GKE | Kubernetes manifests and troubleshooting notes |

---

## 11. Application Design

### 11.1 Application Name

`order-api`

### 11.2 Purpose

The `order-api` is a simple FastAPI service used to generate normal and failure conditions for observability and SLO testing.

It does not represent a real business system. Its purpose is to generate measurable traffic, logs, traces, alerts, capacity data, and incident scenarios.

### 11.3 Initial Endpoints

| Endpoint | Method | Purpose |
|---|---|---|
| `/health` | GET | Returns application health status |
| `/metrics` | GET | Exposes Prometheus metrics |
| `/orders/{id}` | GET | Simulates a normal business request |
| `/simulate-latency` | POST | Adds configurable artificial latency |
| `/simulate-error` | POST | Returns a controlled HTTP 500 error |
| `/simulate-dependency-failure` | POST | Simulates dependency connection failure |
| `/reset-simulation` | POST | Resets active fault simulations |

### 11.4 Application Telemetry

The application must emit:

- Request count by HTTP method, route, and status code
- Request duration histogram
- Error count
- Dependency-call duration and error status
- Structured JSON logs
- Request ID and trace ID in logs
- OpenTelemetry traces for incoming requests and dependency operations
- Deployment or application version information where practical

---

## 12. Observability Design

### 12.1 Golden Signals

| Signal | Indicator | Initial Target | Alert Condition |
|---|---|---|---|
| Availability | Health endpoint success rate | 99% during lab operation | Service unavailable for 2 minutes |
| Traffic | Requests per second | Establish a baseline | No initial alert |
| Errors | HTTP 5xx percentage | Less than 2% | More than 5% for 5 minutes |
| Latency | p95 request duration | Less than 500 ms | More than 1 second for 5 minutes |
| Saturation | CPU, memory, disk, and container health | Normal baseline | Alert before resource exhaustion |

### 12.2 Service Level Objectives

#### Availability SLO

| Field | Definition |
|---|---|
| Service | `order-api` |
| SLI | Percentage of successful health checks or successful HTTP responses |
| Target | 99% availability |
| Measurement window | Rolling 30 days |
| Error budget | 1% of checks or requests may fail during the measurement window |
| Exclusions | Planned local maintenance, explicitly tagged load tests, and controlled lab experiments when documented |
| Purpose | Demonstrates how service availability is measured and managed |

#### Latency SLO

| Field | Definition |
|---|---|
| Service | `order-api` |
| SLI | Percentage of valid requests completed in less than 500 ms |
| Target | 95% of requests complete in less than 500 ms |
| Measurement window | Rolling 30 days |
| Error budget | 5% of valid requests may exceed 500 ms |
| Exclusions | Controlled latency simulations and documented capacity tests |
| Purpose | Demonstrates user-focused performance monitoring |

### 12.3 Error-Budget Policy

The error budget is the allowed unreliability for the service during the SLO measurement window.

For Version 1:

- If the service is within its SLO, normal documentation and project changes may continue.
- If a controlled incident consumes a significant part of the error budget, a post-incident review must document the root cause, customer impact simulation, mitigation, and follow-up action.
- If an availability incident consumes more than 20% of the monthly error budget, at least one reliability improvement action must be created.
- Controlled tests must be clearly marked so that they can be explained during interviews and excluded from normal reliability reporting where appropriate.
- Error-budget burn-rate alerts are used to detect severe incidents faster than waiting for a full monthly SLO miss.

### 12.4 Metrics

The platform will collect:

- Application request rate
- Application error rate
- Application request duration
- Application process CPU and memory
- Container status and restart count
- VM CPU, memory, disk, and network usage
- Grafana Alloy health, queue status, exporter failures, and resource usage
- SLI, SLO, error-budget, and burn-rate metrics or derived dashboard queries

### 12.5 Logs

Application logs must be structured JSON and include:

```json
{
  "timestamp": "2026-07-17T10:00:00Z",
  "level": "ERROR",
  "service": "order-api",
  "environment": "dev",
  "version": "0.1.0",
  "request_id": "example-request-id",
  "trace_id": "example-trace-id",
  "method": "GET",
  "path": "/orders/123",
  "status_code": 500,
  "message": "Dependency connection failed"
}
```

### 12.6 Traces

The platform will create traces for:

- Incoming HTTP requests
- Application business logic
- Mock dependency calls
- Failure or latency simulations
- Error responses
- Exception details where safe and appropriate

### 12.7 Dashboards

The first dashboard set will include:

| Dashboard | Purpose |
|---|---|
| Order API Overview | Golden Signals for the FastAPI application |
| Order API SLO Overview | Availability SLO, latency SLO, error-budget consumption, and burn-rate status |
| Order API Incident Investigation | Error logs, traces, affected endpoints, and recent deployments |
| Compute Engine Host Health | CPU, memory, disk, network, container status, and process health |
| Grafana Alloy Health | Collector process, queue, export failures, and resource use |

### 12.8 Alerts

| Alert | Severity | Condition | Runbook |
|---|---|---|---|
| OrderApiDown | Critical | Health check or `up` metric fails for 2 minutes | `docs/runbooks/service-down.md` |
| HighHttpErrorRate | Warning/Critical | HTTP 5xx rate exceeds 5% for 5 minutes | `docs/runbooks/high-error-rate.md` |
| HighP95Latency | Warning | p95 latency exceeds 1 second for 5 minutes | `docs/runbooks/high-latency.md` |
| AvailabilityErrorBudgetBurn | Warning/Critical | Availability error budget is consumed at a high burn rate | `docs/runbooks/slo-error-budget.md` |
| AlloyExportFailure | Warning | Telemetry exporter failures detected | `docs/runbooks/telemetry-pipeline.md` |
| HostResourceSaturation | Warning | CPU, memory, or disk exceeds documented safe threshold | `docs/runbooks/host-saturation.md` |

---

## 13. Incident Scenarios

### 13.1 Scenario One: Service Unavailable

| Item | Description |
|---|---|
| Trigger | Stop the application container |
| Expected detection | `OrderApiDown` alert and availability error-budget burn |
| Investigation | Alert -> Grafana dashboard -> VM/container status -> application logs |
| Mitigation | Restart or redeploy application container |
| Verification | Health endpoint returns HTTP 200, alert resolves, and availability trend recovers |
| Prevention | Container restart policy, health check, deployment verification |

### 13.2 Scenario Two: High Latency

| Item | Description |
|---|---|
| Trigger | Enable a 3-second delay for a selected API endpoint |
| Expected detection | `HighP95Latency` alert and degraded latency SLO dashboard |
| Investigation | Dashboard -> affected endpoint -> trace -> slow span -> related logs |
| Mitigation | Disable simulation or deploy corrected application configuration |
| Verification | p95 latency returns below threshold and alert resolves |
| Prevention | Latency SLO, capacity testing, review of slow dependency calls |

### 13.3 Scenario Three: High Error Rate

| Item | Description |
|---|---|
| Trigger | Enable controlled HTTP 500 response from a selected endpoint |
| Expected detection | `HighHttpErrorRate` alert and increased error-budget consumption |
| Investigation | Error-rate panel -> logs -> trace exception -> application configuration |
| Mitigation | Disable simulation or correct configuration |
| Verification | HTTP 5xx percentage returns below threshold and alert resolves |
| Prevention | Automated validation, error handling, alert tuning |

### 13.4 Scenario Four: Dependency Failure

This scenario is optional for Version 1 and required for Version 2.

| Item | Description |
|---|---|
| Trigger | Stop or misconfigure a mock dependency |
| Expected detection | Health or error-rate alert |
| Investigation | Trace reveals failed dependency call; logs identify the connection issue |
| Mitigation | Restore dependency or correct connection configuration |
| Verification | Dependency request succeeds and service health recovers |
| Prevention | Dependency health check and configuration validation |

---

## 14. Capacity Experiment

### 14.1 Purpose

The capacity experiment demonstrates basic SRE performance analysis and the trade-off between traffic, latency, resource saturation, reliability, and cloud cost.

### 14.2 Method

1. Deploy the normal `order-api` environment.
2. Use `hey`, Locust, or a Python script to generate several traffic levels.
3. Record request rate, p95 latency, CPU usage, memory usage, error rate, and container restarts.
4. Capture results from Grafana dashboards.
5. Identify the point at which latency increases, errors occur, or the VM becomes saturated.
6. Document the findings in `docs/capacity-notes.md`.

### 14.3 Initial Test Levels

| Test level | Example traffic | Expected observation |
|---|---|---|
| Baseline | 1-5 requests per second | Normal latency and low resource use |
| Moderate | 10-20 requests per second | Establish normal operating range |
| Higher load | 30-50 requests per second | Identify CPU, memory, or latency trends |
| Stress test | Increase carefully until degradation | Identify saturation point and SLO impact |

### 14.4 Expected Evidence

- Screenshots or exported graphs of CPU, memory, request rate, error rate, and p95 latency
- A written explanation of the observed bottleneck
- A documented decision about whether the VM size is appropriate for the demonstration workload
- A short explanation of how capacity results influenced alert thresholds, SLOs, or future scaling decisions

---

## 15. Security Design

### 15.1 Identity and Access

- Use a dedicated GCP service account for the Compute Engine VM
- Apply least-privilege IAM roles
- Do not use personal credentials in automation
- Prefer short-lived credentials or workload identity approaches where practical
- Do not commit service-account key files
- Restrict access to the Terraform state bucket

### 15.2 Network Security

- Use a dedicated VPC and subnet
- Allow only required inbound ports
- Do not expose SSH to `0.0.0.0/0`
- Restrict SSH to a known IP address or use Identity-Aware Proxy when configured
- Allow only necessary outbound traffic for operating system updates and Grafana Cloud telemetry export

### 15.3 Secret Management

- Keep Grafana Cloud tokens in local environment variables, Ansible Vault, or GitHub secrets
- Commit `.env.example`, not `.env`
- Add `*.tfstate`, `*.tfvars`, `.env`, `.pem`, and credential files to `.gitignore`
- Rotate any token that is accidentally exposed
- Do not place secrets in screenshots, logs, pull requests, or demo video recordings

### 15.4 Security Validation

- Review Terraform plan before applying changes
- Use GitHub secret scanning
- Run `ansible-lint`
- Validate firewall rules and IAM roles manually before demo
- Add dependency scanning as a later enhancement

---

## 16. Cost Management

### 16.1 Cost Controls

- Use one small Compute Engine VM
- Configure a GCP budget alert before provisioning resources
- Use a dedicated GCP project when possible
- Use resource labels such as `environment=dev`, `component=order-api`, and `owner=thant-zin-bo`
- Stop or destroy infrastructure when not actively demonstrating the project
- Use `terraform destroy` after major testing sessions
- Review GCP billing weekly

### 16.2 Expected Cost Risks

| Risk | Control |
|---|---|
| VM runs continuously | Use a small instance and destroy when inactive |
| Logging or telemetry volume grows | Generate limited load and monitor Grafana Cloud free-tier limits |
| Terraform state storage cost | Use a small state bucket with lifecycle policy |
| Accidental additional resources | Review Terraform plan and use budget alerts |
| Forgotten test resources | Use labels and a teardown checklist |
| Larger VM selected without evidence | Use capacity experiment results to justify compute sizing |

### 16.3 Teardown Procedure

```bash
cd terraform/environments/dev
terraform destroy
```

After teardown:

1. Confirm the Compute Engine VM is removed.
2. Confirm external IP resources are removed.
3. Confirm no unexpected load balancer, disk, snapshot, or network resources remain.
4. Review the billing console.
5. Keep remote state storage only if needed for future deployment; otherwise remove it manually after confirming no state is required.

---

## 17. Git Workflow

### 17.1 Branching Strategy

```text
main
feature/project-design
feature/local-api
feature/local-observability
feature/terraform-gcp
feature/ansible-configuration
feature/grafana-cloud
feature/slo-error-budget
feature/incident-runbooks
feature/capacity-experiment
```

### 17.2 Commit Convention

Use small, meaningful commits.

Examples:

```text
docs: add project architecture and success criteria
feat(api): add health and order endpoints
feat(metrics): expose request count and latency metrics
feat(terraform): provision GCP network and compute module
feat(ansible): add Docker installation role
feat(observability): add high error rate alert
feat(slo): add availability and latency SLO dashboards
docs(runbook): add high latency investigation procedure
docs(capacity): add initial load test findings
```

### 17.3 Pull Request Template

Every pull request should include:

```markdown
## Purpose
What problem does this change solve?

## Changes
What was added, removed, or modified?

## Validation
How was the change tested?

## Security and cost impact
Does this change add permissions, network exposure, secrets, or cloud cost?

## SLO and operational impact
Does this change affect reliability targets, alerts, dashboards, or runbooks?

## Rollback
How can this change be reverted safely?

## Evidence
Attach terminal output, screenshots, dashboard links, or test results when relevant.
```

---

## 18. CI Validation

### 18.1 Initial Workflows

| Workflow | Trigger | Validation |
|---|---|---|
| Terraform validation | Pull request affecting `terraform/**` | `terraform fmt -check`, `terraform init`, `terraform validate` |
| Ansible lint | Pull request affecting `ansible/**` | `ansible-lint` |
| Python tests | Pull request affecting `app/**` | Unit tests and linting |
| Secret scan | Pull request and push | Detect accidentally committed secrets |
| Documentation check | Pull request affecting `docs/**` | Markdown linting or link validation where practical |

### 18.2 CI Non-Goals

CI validates code and configuration first. It does not automatically provision GCP resources or deploy production-like infrastructure in Version 1.

---

## 19. Documentation Plan

| Document | Purpose |
|---|---|
| `README.md` | Quick start, project value, architecture summary, local run instructions, demo links, and recruiter-facing SRE skills summary |
| `docs/project-design.md` | Full project scope, requirements, design, phases, risks, and success criteria |
| `docs/architecture.md` | Diagram, data flow, network boundaries, component explanations, and failure domains |
| `docs/roadmap.md` | Detailed milestones and backlog |
| `docs/risks-and-costs.md` | Cost controls, security risks, operational risks, and trade-offs |
| `docs/slo-design.md` | SLIs, SLOs, error budgets, burn-rate approach, exclusions, and alerting decisions |
| `docs/capacity-notes.md` | Capacity test method, results, graphs, bottlenecks, and cost/reliability trade-offs |
| `docs/adr/` | Architecture Decision Records |
| `docs/runbooks/` | Step-by-step incident response procedures |
| `docs/postmortems/` | Blameless incident reviews and prevention actions |
| `docs/screenshots/` | Sanitized evidence of dashboards, alerts, deployment, and recovery |
| `docs/demo-script.md` | Five-minute demo narrative for recruiters and interviews |
| `docs/sre-competencies.md` | Mapping of project artifacts to SRE skill areas |

---

## 20. Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Project becomes too broad | Delayed completion | Keep Version 1 to one VM and one application; defer Kubernetes and AIOps |
| GCP cost increases unexpectedly | Financial cost | Set budget alert, use small VM, use labels, and destroy infrastructure regularly |
| Secrets committed to Git | Security exposure | `.gitignore`, GitHub secrets, environment variables, Ansible Vault, and secret scanning |
| Terraform or Ansible complexity blocks progress | Slow progress | Complete each phase locally and independently before continuing |
| Telemetry does not reach Grafana Cloud | Observability unavailable | Test local stack, validate tokens and network egress, monitor Alloy health |
| Alerts create noise | Poor incident experience | Use sustained thresholds, test alerts, link runbooks, and introduce SLO-based burn-rate alerts |
| Single VM fails | Entire lab environment unavailable | Treat as an intentional Version 1 failure domain and document multi-instance design as future work |
| Load test causes unexpected cost or instability | Financial or operational cost | Use bounded traffic levels, time-box tests, and destroy resources after testing |
| Project looks like copied tutorial | Weak portfolio value | Write original ADRs, runbooks, postmortem, SLO rationale, capacity findings, and incident analysis |
| Incomplete technical explanation in interview | Hiring risk | Rehearse architecture, failure scenarios, SLO trade-offs, capacity findings, and troubleshooting flow |

---

## 21. SRE Competencies Demonstrated

By completing the project, the repository will demonstrate the ability to:

- Use Git branching, pull requests, code review structure, and CI validation in a professional workflow
- Provision GCP infrastructure using Terraform modules, variables, outputs, remote state, plan, apply, and destroy
- Configure VPC networking, firewall rules, Compute Engine, service accounts, Cloud Storage state management, labels, and basic cost controls
- Apply Ansible inventory, roles, playbooks, templates, variables, idempotence, and linting
- Build and deploy containerized applications using Docker and Docker Compose
- Develop a Python/FastAPI service with health endpoints, metrics, structured logs, and controlled fault injection
- Instrument metrics, logs, and traces using OpenTelemetry
- Configure and troubleshoot Grafana Alloy telemetry pipelines
- Build Grafana dashboards, queries, alerts, and incident investigation workflows
- Define SLIs, SLOs, error budgets, and basic burn-rate alerting
- Execute controlled incidents using metrics, logs, and traces to investigate root cause
- Write actionable runbooks and blameless post-incident reviews
- Perform a basic capacity experiment and communicate reliability, performance, and cost trade-offs
- Explain system design and operational decisions clearly in a technical interview

---

## 22. Future Enhancements

After Version 1, possible enhancements include:

- Deploy the application to local Kubernetes using `kind` or `k3d`
- Deploy to GKE after cost and complexity review
- Add Kubernetes dashboards and alerts
- Add Terraform-managed Grafana dashboards, alert rules, or SLO resources
- Add GitHub Actions deployment workflow after approval
- Add synthetic monitoring
- Add automated rollback from failed health checks
- Add Elastic/ELK comparison or log-export integration
- Add an AIOps component that groups alerts, summarizes incidents, or detects anomalous metrics using Python
- Add security hardening, vulnerability scanning, and policy-as-code
- Add a second environment such as `staging`, with Terraform variables and separate state
- Add multi-instance deployment and a load balancer to demonstrate availability improvements
- Add chaos experiments beyond controlled application endpoints

---

## 23. Demonstration Script

The final project demo should take approximately five minutes.

1. Show the GitHub repository and architecture diagram.
2. Explain the project problem statement and target SRE skills.
3. Show Terraform modules, remote state design, labels, and a completed GCP deployment.
4. Show Ansible playbooks and idempotent configuration output.
5. Show the FastAPI health endpoint and normal API request.
6. Show Grafana dashboards with metrics, logs, and traces.
7. Show availability and latency SLO dashboards, error budget, and burn-rate status.
8. Trigger a controlled latency or error incident.
9. Show the alert firing and explain the user-facing SLO impact.
10. Investigate from metric to trace and log evidence.
11. Apply mitigation and show recovery.
12. Open the corresponding runbook and post-incident review.
13. Show capacity experiment findings and explain cost/reliability trade-offs.
14. Explain how to destroy infrastructure and control cloud cost.

---

## 24. Definition of Done

Version 1 is done when:

- The environment is reproducible from documented steps.
- The GCP infrastructure is provisioned using Terraform.
- The VM is configured and application deployed using Ansible.
- The application generates metrics, logs, and traces.
- Grafana Cloud shows the complete telemetry pipeline.
- Availability and latency SLOs are defined, visualized, and documented.
- Error-budget consumption is visible or calculated from documented metrics.
- At least one error-budget burn-rate alert is implemented and tested.
- A capacity experiment is completed and documented.
- Alerts detect three controlled incidents.
- Runbooks and a blameless post-incident review prove operational readiness.
- The README allows a recruiter or hiring manager to quickly understand the architecture, evidence, and SRE competencies demonstrated.
