---
name: security-review
description: OWASP-focused security audit of code changes. Use when reviewing code for vulnerabilities or before deploying to production.
allowed-tools: Read, Grep, Glob, Bash
context: fork
---

# Security Review

OWASP-focused security audit. Read-only — identify and report vulnerabilities without modifying code. Runs in a forked context to keep verbose analysis out of the main conversation.

## Scope

Determine what to review:
- If there are uncommitted changes, review those: `git diff` and `git diff --cached`
- If asked about specific files, review those files
- Otherwise, ask the user what to review

## OWASP Top 10 Checklist

### A01: Broken Access Control
- Missing authorization checks on endpoints or functions
- Insecure direct object references (IDOR) — user-controlled IDs without ownership verification
- Missing CORS configuration or overly permissive origins
- Path traversal via user-controlled file paths

### A02: Cryptographic Failures
- Secrets, API keys, or credentials hardcoded or logged
- Weak hashing algorithms (MD5, SHA1 for passwords)
- Missing encryption for sensitive data at rest or in transit

### A03: Injection
- SQL injection — string concatenation in queries instead of parameterized statements
- Command injection — user input in `os.system`, `subprocess`, `exec`, shell strings
- XSS — user input rendered without escaping in HTML/templates
- Template injection — user input in template strings

### A04: Insecure Design
- Missing rate limiting on authentication or sensitive endpoints
- Business logic flaws (race conditions in financial operations, TOCTOU)
- Missing input validation at system boundaries

### A05: Security Misconfiguration
- Debug mode enabled in production configs
- Default credentials or unnecessary services enabled
- Overly permissive file permissions or network access
- Missing security headers (CSP, HSTS, X-Frame-Options)

### A06: Vulnerable Components
- Known vulnerable dependency versions (check lockfiles)
- Unmaintained or deprecated libraries

### A07: Authentication Failures
- Weak password policies, missing MFA hooks
- Session fixation, missing session invalidation on logout
- JWT issues: missing expiry, weak signing, algorithm confusion

### A08: Data Integrity Failures
- Missing integrity checks on deserialized data
- Unsafe deserialization (pickle, yaml.load, eval)
- Missing signature verification on updates or deployments

### A09: Logging Failures
- Sensitive data in logs (passwords, tokens, PII)
- Missing audit logging for security-relevant actions
- Missing error handling that silently swallows failures

### A10: SSRF
- User-controlled URLs fetched server-side without allowlist
- Internal service URLs exposed or guessable

## Language-Specific Checks

### Python
- `eval()`, `exec()`, `pickle.loads()`, `yaml.load()` (use `yaml.safe_load`)
- `subprocess` with `shell=True` and user input
- `os.path.join` with user input (path traversal)
- SQL queries built with f-strings or `.format()`

### Kotlin
- XML parsing without disabling external entities (XXE)
- `Runtime.exec()` with user input
- Reflection-based deserialization without type restrictions
- Missing `@PreAuthorize` / `@Secured` on Spring endpoints

### TypeScript
- `innerHTML`, `dangerouslySetInnerHTML` with user content
- `eval()`, `Function()` constructor with dynamic input
- Missing CSRF protection on state-changing endpoints
- `JSON.parse` on untrusted input without validation

### Nix
- `import <nixpkgs>` (impure, breaks reproducibility)
- `builtins.fetchurl` without hash verification
- Secrets in Nix expressions (should use sops-nix file paths)
- Overly permissive `allowedReferences` or `sandbox = false`

## Output Format

```
## Security Review: [scope description]

### Findings

| Severity | Category | Location | Description |
|----------|----------|----------|-------------|
| CRITICAL | A03 | file:line | ... |
| HIGH     | A01 | file:line | ... |
| MEDIUM   | A05 | file:line | ... |
| LOW      | A09 | file:line | ... |

### Details

#### [CRITICAL] A03: SQL Injection in user_service.py:42
Description of the vulnerability and exploitation scenario.
**Remediation**: Specific fix recommendation.

### Summary
- Total findings: N (X critical, Y high, Z medium, W low)
- Overall risk assessment
- Priority remediation order
```
