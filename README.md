# Linux Security Audit using Lynis — Custom Security Tests

## Project Overview

This project extends the Lynis security auditing tool with two custom security tests. The tests examine password aging policy and SSH server configuration, helping identify settings that may require security review.

The project was developed and tested using Ubuntu on Windows Subsystem for Linux (WSL).

## Objectives

- Understand how Lynis performs Linux security audits.
- Examine the structure of custom Lynis test scripts.
- Develop two custom security checks.
- Integrate the tests into Lynis using the `tests_custom` file.
- Execute the audit and analyze the results.

## Tools and Technologies

- Ubuntu on WSL 2
- Lynis 3.1.6
- Shell scripting
- OpenSSH server configuration
- Linux command-line utilities

## Custom Security Tests

### 1. CUST-1010 — Password Policy Audit

**Purpose:** Examine the `PASS_MAX_DAYS` setting in `/etc/login.defs`.

The script checks whether the setting is present and contains a valid numeric value. It reports a warning when the value falls outside the project's selected range of 1–90 days.

**Observed result:**

`PASS_MAX_DAYS=99999`

The test reported that the value was outside the selected range.

**Security relevance:** A very high maximum password age can permit passwords to remain unchanged for a long time. The setting in `/etc/login.defs` primarily establishes defaults for newly created accounts; it does not establish the actual password-aging configuration of every existing account.

### 2. CUST-1020 — SSH Security Audit

**Purpose:** Examine the effective SSH server settings for root login and password authentication.

The test uses `sshd -T` to read effective configuration values, including applicable configuration defaults and included settings.

**Observed results:**

- `permitrootlogin prohibit-password`
- `passwordauthentication yes`

The test reported both settings for review.

**Security relevance:** `prohibit-password` prevents root login using password authentication but can allow root login using SSH keys. The `passwordauthentication yes` setting means SSH password authentication is enabled in the effective configuration.

## Integration with Lynis

The two tests are registered in the combined `tests_custom` file located at:

`/usr/share/lynis/include/tests_custom`

The custom test IDs are:

- `CUST-1010`
- `CUST-1020`

The integrated file was loaded by Lynis, and both tests executed during the system audit.

## Execution

Run the audit with:

```bash
sudo lynis audit system
```

Review the custom test findings in the log:

```bash
sudo grep -E 'CUST-1010|CUST-1020' /var/log/lynis.log
```

## Project Structure

```text
lynis-custom-security-audit/
├── README.md
├── scripts/
│   ├── CUST-1010-password-policy.sh
│   └── CUST-1020-ssh-security.sh
├── lynis/
│   └── tests_custom
└── evidence/
    └── lynis_custom_results.txt
```

- `scripts/` contains the two standalone audit scripts.
- `lynis/tests_custom` contains the combined file used by Lynis.
- `evidence/` contains the captured custom test log findings.

## Testing and Validation

The shell syntax checks passed for both standalone scripts and the combined `tests_custom` file. Both custom test IDs were present in the integration file, and the Lynis log confirmed that both tests executed.

The results identify configuration settings for review; they do not establish that the entire operating system is secure.

## Learning Outcomes

Through this project, I learned how to:

- Use Lynis for Linux security auditing.
- Read and understand shell scripts.
- Create custom security checks.
- Inspect password policy and SSH configuration.
- Register custom tests and integrate them into Lynis.
- Validate scripts and interpret audit findings.

## Repository

GitHub: **[Insert your repository URL here]**

## Conclusion

This project demonstrates how Lynis can be extended with custom security tests to examine selected Linux security configurations. The two tests provide additional visibility into password aging policy and SSH authentication settings, while illustrating the practical process of developing, integrating, testing, and documenting security audit scripts.

## Acknowledgements

I acknowledge the Lynis project and its documentation for providing the security auditing framework and reference material used during this project.
