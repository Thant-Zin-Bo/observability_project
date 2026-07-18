# GCP Incident-Ready Observability Platform

**Status:** Planning  
**Owner:** Thant Zin Bo  
**Repository:** `https://github.com/Thant-Zin-Bo/gcp-incident-ready-observability-platform`  
**Target roles:** SRE Engineer, Observability Engineer, Platform Operations Engineer, Cloud Operations Engineer  
**Start date:** July 2026  
**Target completion:** October 2026  
**Version:** 0.1  

---

## 1. Executive Summary

This project demonstrates a production-style observability platform for a containerized Python API deployed on Google Cloud Platform (GCP).

Terraform provisions the cloud infrastructure. Ansible configures the virtual machine and deploys the application. The application is instrumented with OpenTelemetry and sends metrics, logs, and traces through Grafana Alloy to Grafana Cloud. Grafana dashboards, alerts, runbooks, and post-incident reviews provide an incident-ready operational workflow.

The purpose is to build recent, independently demonstrable hands-on experience in infrastructure as code, cloud operations, configuration management, observability, alerting, troubleshooting, and operational documentation.

---

## 2. Problem Statement

Small services can fail in ways that are difficult to diagnose without clear operational visibility. Common failure patterns include high latency, increased HTTP errors, unavailable dependencies, application crashes, resource exhaustion, and incorrect configuration changes.

Without correlated metrics, logs, and traces, an engineer may detect an issue late and spend too long identifying its root cause. Manual and undocumented deployment processes also make systems harder to reproduce, maintain, and recover.

This project addresses these problems by creating a reproducible cloud environment with structured observability, actionable alerts, controlled failure scenarios, and documented response procedures.

---

## 3. Project Goals

The project will:

- Provision GCP infrastructure reproducibly using Terraform.
- Use Git and pull-request workflow to manage infrastructure, application, configuration, dashboards, alert rules, and documentation.
- Configure a Compute Engine virtual machine with idempotent Ansible playbooks.
- Deploy a containerized Python/FastAPI application.
- Instrument the application with OpenTelemetry.
- Collect metrics, structured logs, and traces.
- Send telemetry to Grafana Cloud through Grafana Alloy.
- Build dashboards for service health, traffic, errors, latency, and resource saturation.
- Configure actionable alerts for service unavailability, high error rate, and high latency.
- Simulate controlled incidents and document detection, investigation, mitigation, verification, and prevention.
- Publish runbooks, an architecture diagram, technical decisions, and a post-incident review.
- Demonstrate a clean infrastructure teardown process to control cloud costs.

---

## 4. Non-Goals

The first release will not include:

- A production service for external users.
- Multi-region high availability or disaster recovery.
- A large Kubernetes or GKE environment.
- A full security information and event management solution.
- A full CI/CD deployment pipeline with automated production releases.
- A custom machine-learning anomaly-detection model.
- Enterprise compliance certification or a complete ISO 27001 implementation.
- Load testing at production scale.

These features may be considered as future enhancements after the minimum viable platform is complete.

---

## 5. Success Criteria

The first release is complete when all conditions below are met.

### Infrastructure and deployment

- [ ] `terraform fmt`, `terraform validate`, and `terraform plan` complete successfully.
- [ ] Terraform provisions the required GCP infrastructure.
- [ ] Terraform remote state is stored outside the Git repository.
- [ ] Ansible configures the VM successfully.
- [ ] Ansible playbooks can run twice without making unexpected changes.
- [ ] The FastAPI application is deployed as a container and responds to the health check.
- [ ] The environment can be removed cleanly using Terraform.

### Observability

- [ ] Grafana displays service and host metrics.
- [ ] Grafana displays structured application logs.
- [ ] Grafana displays traces for API requests.
- [ ] A dashboard shows availability, traffic, error rate, p95 latency, and saturation.
- [ ] A service-down alert is tested successfully.
- [ ] A high-error-rate alert is tested successfully.
- [ ] A high-latency alert is tested successfully.
- [ ] Each alert includes a link to its runbook.

### Operational readiness

- [ ] Three controlled incident scenarios are documented and demonstrated.
- [ ] At least three runbooks are committed to the repository.
- [ ] One detailed post-incident review is committed to the repository.
- [ ] A new user can run the local environment using README instructions.
- [ ] A five-minute demo video shows deployment, alerting, investigation, recovery, and documentation.

---

## 6. Requirements

### 6.1 Functional Requirements

| ID | Requirement |
|---|---|
| FR-01 | The application must provide `/health` and `/metrics` endpoints. |
| FR-02 | The application must provide controlled fault endpoints for latency, errors, and dependency failure. |
| FR-03 | Terraform must provision VPC networking, subnet, firewall rules, Compute Engine VM, service account, and remote state storage. |
| FR-04 | Ansible must install required packages, Docker, Docker Compose, Grafana Alloy, and application configuration. |
| FR-05 | Grafana Alloy must forward application and host telemetry to Grafana Cloud. |
| FR-06 | Grafana must show dashboards for Golden Signals and host health. |
| FR-07 | Alert rules must detect service-down, high-error-rate, and high-latency conditions. |
| FR-08 | GitHub Actions must validate Terraform formatting and configuration. |
| FR-09 | GitHub Actions must run Ansible linting. |
| FR-10 | The project must include runbooks and one post-incident review. |

### 6.2 Non-Functional Requirements

| ID | Requirement |
|---|---|
| NFR-01 | The project must be reproducible from a new GCP project. |
| NFR-02 | No secret, token, service-account key, Terraform state file, or `.env` file may be committed to Git. |
| NFR-03 | The GCP service account must use least-privilege access. |
| NFR-04 | SSH access must not be open to the public internet. |
| NFR-05 | The platform must use one small Compute Engine VM for the first release. |
| NFR-06 | A GCP budget alert must be configured before provisioning resources. |
| NFR-07 | Documentation must explain installation, verification, incident simulation, and teardown. |
| NFR-08 | The project must use version-controlled configuration for dashboards and alerts where practical. |

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
                    +-- Explore
                    +-- Alerting
                    +-- Incident investigation
```

### 7.2 Architecture Principle

Terraform provisions cloud resources. Ansible configures the operating system and deploys application services. Docker runs the application. Grafana Alloy collects and forwards telemetry. Grafana Cloud provides dashboards, correlation, querying, and alerting.

This separation demonstrates that infrastructure provisioning and configuration management are related but distinct responsibilities.

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
| Observability platform | Grafana Cloud | Dashboards, data exploration, correlation, and alerting |
| CI validation | GitHub Actions | Runs Terraform validation and Ansible linting |
| Documentation | Markdown | Explains architecture, decisions, operations, incidents, and learning |

---

## 9. Technology Decisions

| Decision Area | Selected Technology | Rationale |
|---|---|---|
| Cloud platform | GCP | Builds practical GCP experience and supports the cloud portion of the portfolio. |
| Infrastructure provisioning | Terraform | Enables repeatable infrastructure, version control, planning, drift awareness, and supports Terraform Associate learning. |
| Configuration management | Ansible | Demonstrates idempotent VM configuration after infrastructure provisioning. |
| Initial compute approach | One Compute Engine VM | Keeps cost and complexity low while demonstrating real cloud operations. |
| Application framework | Python/FastAPI | Matches current Python and ML background and is easy to instrument. |
| Telemetry format | OpenTelemetry | Provides vendor-neutral metrics, logs, and traces instrumentation. |
| Telemetry collector | Grafana Alloy | Provides a modern Grafana-compatible telemetry pipeline. |
| Observability backend | Grafana Cloud | Supports logs, metrics, traces, dashboards, alerts, and data correlation. |
| Version control platform | GitHub | Makes code, documentation, commit history, pull requests, and CI visible to recruiters. |
| Container platform | Docker Compose | Provides a simple, reproducible deployment method before a Kubernetes extension. |

---

## 10. Project Phases

| Phase | Name | Main Outcome | Evidence |
|---|---|---|---|
| 0 | Project design | Scope, architecture, success criteria, decisions, risk controls | Design document, ADRs, diagram |
| 1 | Local application | Containerized FastAPI service with health, metrics, logs, traces, and controlled faults | Source code, tests, Dockerfile |
| 2 | Local observability | Local dashboards, alerts, logs, metrics, and traces | Docker Compose, dashboard JSON, alert rules |
| 3 | GCP infrastructure | Reproducible GCP environment | Terraform modules, plan output, architecture update |
| 4 | Configuration management | VM configured and application deployed repeatedly | Ansible roles, dynamic inventory, idempotence evidence |
| 5 | Grafana Cloud | GCP telemetry, dashboards, alerts, and investigation in Grafana Cloud | Screenshots, dashboard export, alert testing |
| 6 | Incident readiness | Controlled incidents, runbooks, and postmortem | Runbooks, postmortem, demo video |
| 7 | Optional Kubernetes | Migration to local Kubernetes or GKE | Kubernetes manifests and troubleshooting notes |

---

## 11. Application Design

### 11.1 Application Name

`order-api`

### 11.2 Purpose

The `order-api` is a simple FastAPI service used to generate normal and failure conditions for observability testing. It does not represent a real business system. Its purpose is to create measurable traffic, logs, traces, alerts, and incident scenarios.

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

### 12.2 Metrics

The platform will collect:

- Application request rate
- Application error rate
- Application request duration
- Application process CPU and memory
- Container status
- VM CPU, memory, disk, and network usage
- Grafana Alloy health and exporter failures

### 12.3 Logs

Application logs must be structured JSON and include:

```json
{
  "timestamp": "2026-07-17T10:00:00Z",
  "level": "ERROR",
  "service": "order-api",
  "environment": "dev",
  "request_id": "example-request-id",
  "trace_id": "example-trace-id",
  "method": "GET",
  "path": "/orders/123",
  "status_code": 500,
  "message": "Dependency connection failed"
}
```

### 12.4 Traces

The platform will create traces for:

- Incoming HTTP request
- Application business logic
- Mock dependency call
- Failure or latency simulation
- Error response

### 12.5 Dashboards

The first dashboard set will include:

| Dashboard | Purpose |
|---|---|
| Order API Overview | Golden Signals for the FastAPI application |
| Order API Incident Investigation | Error logs, traces, affected endpoints, and recent deployments |
| Compute Engine Host Health | CPU, memory, disk, network, and process health |
| Grafana Alloy Health | Collector process, queue, export failures, and resource use |

### 12.6 Alerts

| Alert | Severity | Condition | Runbook |
|---|---|---|---|
| OrderApiDown | Critical | Health check or `up` metric fails for 2 minutes | `docs/runbooks/service-down.md` |
| HighHttpErrorRate | Warning/Critical | HTTP 5xx rate exceeds 5% for 5 minutes | `docs/runbooks/high-error-rate.md` |
| HighP95Latency | Warning | p95 latency exceeds 1 second for 5 minutes | `docs/runbooks/high-latency.md` |
| AlloyExportFailure | Warning | Telemetry exporter failures detected | `docs/runbooks/telemetry-pipeline.md` |

---

## 13. Incident Scenarios

### 13.1 Scenario One: Service Unavailable

| Item | Description |
|---|---|
| Trigger | Stop the application container |
| Expected detection | `OrderApiDown` alert |
| Investigation | Alert -> Grafana dashboard -> VM/container status -> application logs |
| Mitigation | Restart or redeploy application container |
| Verification | Health endpoint returns HTTP 200 and alert resolves |
| Prevention | Container restart policy, health check, deployment verification |

### 13.2 Scenario Two: High Latency

| Item | Description |
|---|---|
| Trigger | Enable a 3-second delay for a selected API endpoint |
| Expected detection | `HighP95Latency` alert |
| Investigation | Dashboard -> affected endpoint -> trace -> slow span -> related logs |
| Mitigation | Disable simulation or deploy corrected application configuration |
| Verification | p95 latency returns below threshold and alert resolves |
| Prevention | Latency SLO, load testing, review of slow dependency calls |

### 13.3 Scenario Three: High Error Rate

| Item | Description |
|---|---|
| Trigger | Enable controlled HTTP 500 response from a selected endpoint |
| Expected detection | `HighHttpErrorRate` alert |
| Investigation | Error-rate panel -> logs -> trace exception -> application configuration |
| Mitigation | Disable simulation or correct configuration |
| Verification | HTTP 5xx percentage returns below threshold |
| Prevention | Automated validation, error handling, alert tuning |

### 13.4 Scenario Four: Dependency Failure

This scenario is optional for Version 1 and required for Version 2.

| Item | Description |
|---|---|
| Trigger | Stop or misconfigure a mock dependency |
| Expected detection | Health or error-rate alert |
| Investigation | Trace reveals failed dependency call; logs identify connection issue |
| Mitigation | Restore dependency or correct connection configuration |
| Verification | Dependency request succeeds and service health recovers |
| Prevention | Dependency health check and configuration validation |

---

## 14. Security Design

### 14.1 Identity and Access

- Use a dedicated GCP service account for the Compute Engine VM.
- Apply least-privilege IAM roles.
- Do not use personal credentials in automation.
- Prefer short-lived or workload identity approaches where practical.
- Do not commit service-account key files.

### 14.2 Network Security

- Use a dedicated VPC and subnet.
- Allow only required inbound ports.
- Do not expose SSH to `0.0.0.0/0`.
- Restrict SSH to a known IP address or use Identity-Aware Proxy when configured.
- Allow only necessary outbound traffic for operating system updates and Grafana Cloud telemetry export.

### 14.3 Secret Management

- Keep Grafana Cloud tokens in local environment variables, Ansible Vault, or GitHub secrets.
- Commit `.env.example`, not `.env`.
- Add `*.tfstate`, `*.tfvars`, `.env`, `*.pem`, and credential files to `.gitignore`.
- Rotate any token that is accidentally exposed.

### 14.4 Security Validation

- Review Terraform plan before applying changes.
- Use GitHub secret scanning where available.
- Run `ansible-lint`.
- Use a dependency scanner as a later enhancement.

---

## 15. Cost Management

### 15.1 Cost Controls

- Use one small Compute Engine VM.
- Configure a GCP budget alert before provisioning resources.
- Use a dedicated project when possible.
- Stop or destroy infrastructure when not actively demonstrating the project.
- Use `terraform destroy` after major testing sessions.
- Review GCP billing weekly.

### 15.2 Expected Cost Risks

| Risk | Control |
|---|---|
| VM runs continuously | Use small instance and destroy when inactive |
| Logging/telemetry volume grows | Generate limited load and use Grafana Cloud free-tier limits carefully |
| Storage cost from Terraform state | Use small state bucket with lifecycle policy |
| Accidental additional resources | Review Terraform plan and use budget alerts |
| Forgotten test resources | Use labels and a teardown checklist |

### 15.3 Teardown Procedure

```bash
cd terraform/environments/dev
terraform destroy
```

After teardown:

1. Confirm Compute Engine VM is removed.
2. Confirm external IP resources are removed.
3. Confirm no unexpected load balancer, disk, or snapshot resources remain.
4. Review billing console.
5. Keep remote state storage only if needed for future deployment; otherwise remove it manually after confirming no state is required.

---

## 16. Git Workflow

### 16.1 Branching Strategy

```text
main
feature/project-design
feature/local-api
feature/local-observability
feature/terraform-gcp
feature/ansible-configuration
feature/grafana-cloud
feature/incident-runbooks
```

### 16.2 Commit Convention

Use small, meaningful commits.

Examples:

```text
docs: add project architecture and success criteria
feat(api): add health and order endpoints
feat(metrics): expose request count and latency metrics
feat(terraform): provision GCP network and compute module
feat(ansible): add Docker installation role
feat(observability): add high error rate alert
docs(runbook): add high latency investigation procedure
```

### 16.3 Pull Request Template

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

## Rollback
How can this change be reverted safely?

## Evidence
Attach terminal output, screenshots, dashboard links, or test results when relevant.
```

---

## 17. CI Validation

### 17.1 Initial Workflows

| Workflow | Trigger | Validation |
|---|---|---|
| Terraform validation | Pull request affecting `terraform/**` | `terraform fmt -check`, `terraform init`, `terraform validate` |
| Ansible lint | Pull request affecting `ansible/**` | `ansible-lint` |
| Python tests | Pull request affecting `app/**` | Unit tests and linting |
| Secret scan | Pull request and push | Detect accidentally committed secrets |

### 17.2 CI Non-Goals

CI will validate code and configuration first. It will not automatically provision GCP resources or deploy production-like infrastructure in Version 1.

---

## 18. Documentation Plan

| Document | Purpose |
|---|---|
| `README.md` | Quick start, project value, architecture summary, local run instructions |
| `docs/project-design.md` | Full project scope, requirements, design, phases, risks |
| `docs/architecture.md` | Diagram, data flow, network, component explanations |
| `docs/roadmap.md` | Detailed milestones and backlog |
| `docs/risks-and-costs.md` | Cost controls, security risks, operational risks |
| `docs/adr/` | Architecture Decision Records |
| `docs/runbooks/` | Step-by-step incident response procedures |
| `docs/postmortems/` | Blameless incident review and prevention actions |
| `docs/screenshots/` | Sanitized evidence of dashboards, alerts, and deployment |
| `docs/demo-script.md` | Five-minute demo narrative for recruiters and interviews |

---

## 19. Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Project becomes too broad | Delayed completion | Keep Version 1 to one VM and one application |
| GCP cost increases unexpectedly | Financial cost | Set budget alert, use small VM, destroy infrastructure regularly |
| Secrets committed to Git | Security exposure | `.gitignore`, GitHub secrets, environment variables, secret scanning |
| Terraform or Ansible complexity blocks progress | Slow progress | Complete each phase locally and independently before continuing |
| Telemetry does not reach Grafana Cloud | Observability unavailable | Test local stack, validate tokens and network egress, monitor Alloy health |
| Alerts create noise | Poor incident experience | Use sustained thresholds, test carefully, link alerts to runbooks |
| Project looks like copied tutorial | Weak portfolio value | Write original ADRs, runbooks, postmortem, diagrams, and incident analysis |
| Incomplete technical explanation in interview | Hiring risk | Rehearse architecture, failure scenarios, trade-offs, and troubleshooting flow |

---

## 20. Learning Objectives

By completing the project, I will be able to demonstrate:

- Git branching, pull requests, code review structure, and CI validation.
- Terraform providers, modules, variables, outputs, state, plan, apply, destroy, and GCP infrastructure provisioning.
- GCP VPC, firewall, service account, Compute Engine, Cloud Storage state management, and basic cost controls.
- Ansible inventory, roles, playbooks, templates, variables, idempotence, and linting.
- Docker image creation and containerized application deployment.
- Python/FastAPI service development and metrics instrumentation.
- OpenTelemetry instrumentation for metrics, logs, and traces.
- Grafana Alloy setup and telemetry pipeline troubleshooting.
- Grafana dashboards, queries, alerts, alert tuning, and incident investigation.
- Runbook creation, post-incident review, and prevention-oriented operational improvement.

---

## 21. Future Enhancements

After Version 1, possible enhancements include:

- Deploy the application to local Kubernetes using `kind` or `k3d`.
- Deploy to GKE after cost and complexity review.
- Add Kubernetes dashboards and alerts.
- Add Terraform-managed Grafana dashboards, alert rules, or SLO resources.
- Add GitHub Actions deployment workflow after approval.
- Add SLOs and error budget reporting.
- Add synthetic monitoring.
- Add automated rollback from failed health checks.
- Add Elastic/ELK comparison or log-export integration.
- Add an AIOps component that groups alerts, summarizes incidents, or detects anomalous metrics using Python.
- Add security hardening, vulnerability scanning, and policy-as-code.
- Add a second environment, such as `staging`, using Terraform variables and separate state.

---

## 22. Demonstration Script

The final project demo should take approximately five minutes.

1. Show the GitHub repository and architecture diagram.
2. Show Terraform modules and a completed GCP deployment.
3. Show Ansible playbooks and idempotent configuration output.
4. Show the FastAPI service health endpoint.
5. Show Grafana dashboard with service metrics, logs, and traces.
6. Trigger a controlled latency or error incident.
7. Show the alert firing.
8. Investigate from metric to trace and log evidence.
9. Apply mitigation and show recovery.
10. Open the corresponding runbook and post-incident review.
11. Explain how to destroy infrastructure and control cost.

---

## 23. Definition of Done

Version 1 is done when:

- The environment is reproducible from documented steps.
- The GCP infrastructure is provisioned using Terraform.
- The VM is configured and application deployed using Ansible.
- The application generates metrics, logs, and traces.
- Grafana Cloud shows the full telemetry pipeline.
- Alerts detect three controlled incidents.
- Runbooks and a postmortem prove operational readiness.
- A recruiter can inspect the GitHub repository and understand the architecture, decisions, evidence, and technical contribution.
