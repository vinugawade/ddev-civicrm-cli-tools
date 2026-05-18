# 🚀 DDEV CiviCRM CLI Tools Add-on
[![Tests for `ddev-civicrm-cli-tools`](https://github.com/vinugawade/ddev-civicrm-cli-tools/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/vinugawade/ddev-civicrm-cli-tools/actions/workflows/tests.yml)

This DDEV add-on provides seamless integration of essential CiviCRM CLI tools within your DDEV-managed projects. It simplifies the use of tools like `civistrings`, `civix`, `coworker`, and `cv`, improving the developer experience for CiviCRM projects integrated with CMS platforms such as Drupal and Backdrop.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Repository Structure](#repository-structure)
- [Contributing](#contributing)
- [Maintainer](#maintainer)
- [Acknowledgments](#acknowledgments)

## Features

- **Simplified Command Execution**: Easily run CiviCRM CLI tools directly through DDEV commands.
- **Wide Compatibility**: Works with Drupal 9, 10, and 11, Backdrop, and CiviCRM installations.
- **Error Handling**: Provides clear and actionable error messages for missing dependencies or setup issues.
- **Tested Environment**: Includes automated BATS tests to validate functionality, stability, and reliability.
- **Support for Multi-Context Projects**: Works across local development and production-like environments with minimal configuration.

## Installation

### Prerequisites

- DDEV 1.19 or higher.
- PHP 7.4 or higher.
- Composer available in your DDEV project.
- CiviCRM integrated with a supported CMS, such as Drupal or Backdrop.

### Steps

1. **Install the add-on**:

   ```bash
   ddev add-on get vinugawade/ddev-civicrm-cli-tools
   ```

2. **Restart your DDEV project**:

   ```bash
   ddev restart
   ```

3. **Install the required CiviCRM CLI tools package**:

   ```bash
   ddev composer require civicrm/cli-tools
   ```

4. **Verify the installation**:

   Run any CLI command to confirm that everything is working:

   ```bash
   ddev cv --version
   ```

## Usage

The add-on exposes the following commands:

### 1. `ddev civistrings`

Executes the `civistrings` tool inside the web container.

* **Alias**: `cvstr`

Examples:

```bash
ddev civistrings -o myfile.pot myfolder
ddev civistrings --version
```

### 2. `ddev civix`

Executes the `civix` tool inside the web container.

* **Alias**: `cvx`

Examples:

```bash
ddev civix build:zip
ddev civix upgrade
```

### 3. `ddev coworker`

Executes the `coworker` tool inside the web container.

* **Alias**: `cowkr`

Examples:

```bash
ddev coworker list
ddev coworker debug
```

### 4. `ddev cv`

Executes the `cv` tool inside the web container.

* **Alias**: `cv`

Examples:

```bash
ddev cv flush
ddev cv upgrade:db
```

## Repository Structure

```shell
.
├── LICENSE                  # License for the project.
├── README.md                # Documentation for the add-on.
├── commands                 # Directory containing CLI command stubs.
│   └── web
│       ├── civistrings      # Stub for the civistrings command.
│       ├── civix            # Stub for the civix command.
│       ├── coworker         # Stub for the coworker command.
│       └── cv               # Stub for the cv command.
├── install.yaml             # DDEV add-on installation configuration.
└── tests                    # Automated tests for the add-on.
    ├── test.bats            # Main test file for the add-on.
    └── testdata             # Sample test data.
        └── composer.json    # Sample Composer configuration.
```

## Contributing

Contributions are welcome!

To get started:

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

1. Navigate to the add-on test directory:

   ```bash
   cd <ddev-civicrm-cli-tools add-on path>/tests
   ```

2. Run the tests:

   ```bash
   bats test.bats
   ```

## Maintainer

👤 **Vinay Gawade**

Connect with me:

* [GitHub](https://github.com/vinugawade)
* [Drupal](https://www.drupal.org/u/vinaygawade)
* [LinkedIn](https://www.linkedin.com/in/vinu-gawade)

## Acknowledgments

Special thanks to the CiviCRM and DDEV communities for their tools, documentation, and support.
