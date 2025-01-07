# 🚀 DDEV CiviCRM CLI Tools Add-on
[![Tests for `ddev-civicrm-cli-tools`](https://github.com/vinugawade/ddev-civicrm-cli-tools/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/vinugawade/ddev-civicrm-cli-tools/actions/workflows/tests.yml)

This DDEV add-on provides seamless integration of essential CiviCRM CLI tools within your DDEV-managed projects. The add-on simplifies the use of tools like `civistrings`, `civix`, `coworker`, and `cv`, enhancing the developer experience for CiviCRM projects integrated with CMS platforms such as Drupal and Backdrop.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Repository Structure](#repository-structure)
- [Contributing](#contributing)
- [Maintainer](#maintainer)
- [Acknowledgments](#acknowledgments)

---

## Features

- **Simplified Command Execution**: Easily run CiviCRM CLI tools directly through DDEV commands.
- **Wide Compatibility**: Works seamlessly with Drupal (9, 10, 11), Backdrop, and CiviCRM installations.
- **Error Handling**: Provides clear and actionable error messages for missing dependencies or setup issues.
- **Tested Environment**: Includes automated BATS tests to validate functionality, ensuring stability and reliability.
- **Support for Multi-Context Projects**: Works across local development and production environments with minimal configuration.

---

## Installation

### Prerequisites

- DDEV version 1.19+.
- PHP 7.4 or higher.
- Composer installed in your environment.
- CiviCRM integrated with a supported CMS (Drupal or Backdrop).

### Steps

1. **Download the Add-on**:
   ```bash
   ddev get vinugawade/ddev-civicrm-cli-tools
   ```

2. **Restart Your DDEV Project**:
   ```bash
   ddev restart
   ```

3. **Install Required Dependencies**:
   ```bash
   ddev composer require civicrm/cli-tools
   ```

4. **Verify Installation**:
   Run any CLI command to ensure proper setup:
   ```bash
   ddev cv --version
   ```

## Usage

The add-on exposes the following commands:

### 1. `ddev civistrings`

Execute the `civistrings` tool inside the web container.

- **Alias**: `cvstr`
- **Examples**:
  ```bash
  ddev civistrings -o myfile.pot myfolder
  ddev civistrings --version
  ```

### 2. `ddev civix`

Execute the `civix` tool inside the web container.

- **Alias**: `cvx`
- **Examples**:
  ```bash
  ddev civix build:zip
  ddev civix upgrade
  ```

### 3. `ddev coworker`

Execute the `coworker` tool inside the web container.

- **Alias**: `cowkr`
- **Examples**:
  ```bash
  ddev coworker list
  ddev coworker debug
  ```

### 4. `ddev cv`

Execute the `cv` tool inside the web container.

- **Alias**: `cv`
- **Examples**:
  ```bash
  ddev cv flush
  ddev cv upgrade:db
  ```

## Repository Structure

```shell
.
├── LICENSE             # License for the project.
├── README.md           # Documentation for the add-on.
├── commands            # Directory containing CLI command stubs.
│   └── web
│       ├── civistrings # Stub for civistrings command.
│       ├── civix       # Stub for civix command.
│       ├── coworker    # Stub for coworker command.
│       └── cv          # Stub for cv command.
├── install.yaml        # Configuration for DDEV add-on installation.
└── tests               # Automated tests for the add-on.
    ├── test.bats       # Main test file for the add-on.
    └── testdata        # Sample data for testing.
        └── composer.json # Sample composer configuration.
```

---

## Contributing

Contributions are welcome! To get started:

1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add your message here"
   ```
4. Push to your fork and submit a pull request.

### Testing

The add-on includes automated tests written in [BATS](https://github.com/bats-core/bats-core).

#### Running Tests

1. Navigate to the add-on directory:
   ```bash
   cd <ddev-civicrm-cli-tools add-on path>/tests
   ```
2. Run the tests:
   ```bash
   bats test.bats
   ```

## Maintainer

👤 **Vinay Gawade**, Connect with me:

- [GitHub](https://github.com/vinugawade)
- [Drupal](https://www.drupal.org/u/vinaygawade)
- [LinkedIn](https://www.linkedin.com/in/vinu-gawade)

## Acknowledgments

Special thanks to the `CiviCRM` and `DDEV` communities for their tools and support!
