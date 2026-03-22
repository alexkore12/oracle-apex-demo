# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | ✅                 |

## Reporting a Vulnerability

If you discover a security vulnerability within this Oracle APEX application, please send an e-mail to the maintainer. All security vulnerabilities will be promptly addressed.

## Security Best Practices for Oracle APEX

### Authentication

- Use strong authentication mechanisms
- Implement session timeout
- Enable CSRF protection
- Use secure cookie settings

### Authorization

- Implement proper authorization schemes
- Follow principle of least privilege
- Use APEX ACL for fine-grained access
- Validate user roles on every request

### Input Validation

- Validate all user inputs
- Use APEX_ITEM functions safely
- Sanitize dynamic SQL
- Avoid SQL injection

### Data Protection

- Encrypt sensitive data at rest
- Use Oracle Data Redaction
- Implement row-level security
- Enable audit logging

### Database Security

- Apply Oracle security patches
- Use least privilege for database users
- Enable database auditing
- Protect against PL/SQL injection

### APEX Security Settings

- Enable Session State Protection
- Use Authorization schemes
- Implement Custom Authentication
- Configure Security Attributes

## Security Checklist

- [ ] Authentication mechanism in place
- [ ] Authorization schemes configured
- [ ] Session timeout enabled
- [ ] CSRF protection enabled
- [ ] Input validation implemented
- [ ] SQL injection prevention
- [ ] Sensitive data encrypted
- [ ] Audit logging enabled
- [ ] Security patches applied
- [ ] Weak credentials replaced

---

*Last updated: 2026-03-22*
