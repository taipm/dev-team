# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of this project seriously. If you discover a security vulnerability, please follow these steps:

### DO NOT

- Open a public GitHub issue
- Discuss the vulnerability publicly before it's fixed
- Share details on social media or forums

### DO

1. **Email us** at: taipm@microai.club
2. **Include** in your report:
   - Description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact assessment
   - Suggested fix (if you have one)
   - Your contact information for follow-up

### What to Expect

| Stage | Timeframe |
|-------|-----------|
| Acknowledgment | Within 48 hours |
| Initial Assessment | Within 7 days |
| Status Update | Every 7 days until resolved |

### Resolution Timeline by Severity

| Severity | Target Resolution |
|----------|-------------------|
| Critical | 24-48 hours |
| High | 7 days |
| Medium | 30 days |
| Low | 90 days |

## Safe Harbor

We support responsible disclosure. If you follow these guidelines, we will:

- Not pursue legal action against you
- Work with you to understand and resolve the issue promptly
- Acknowledge your contribution (with your permission) when the fix is released
- Keep you informed about the progress

## Security Best Practices for Contributors

When contributing to this project, please:

1. **Never commit secrets or credentials** - Use environment variables
2. **Keep dependencies updated** - Review Dependabot PRs promptly
3. **Follow secure coding guidelines** - OWASP Top 10 awareness
4. **Review code for security issues** - Before submitting PRs
5. **Use signed commits** - Verify code authenticity

## Security Features

This repository implements the following security measures:

- [x] Secret scanning via pre-commit hooks
- [x] Dependency vulnerability scanning (Dependabot)
- [x] Branch protection on main branch
- [x] Required code reviews for PRs
- [ ] CI/CD security checks (not applicable - documentation repo)

## Contact

For security-related questions that are not vulnerabilities, please contact:

- **Maintainer**: @taipm
- **See also**: CODEOWNERS file

---

*Last updated: 2026-01-02*
