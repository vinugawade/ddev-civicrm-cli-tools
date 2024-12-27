# 🚀 DDEV CiviCRM CLI Tools Add-on

This DDEV add-on provides seamless integration of essential CiviCRM CLI tools within your DDEV-managed projects. The add-on simplifies the use of tools like `civistrings`, `civix`, `coworker`, and `cv`, enhancing the developer experience for CiviCRM projects integrated with CMS platforms such as Drupal and Backdrop.

## Features

- **Simplified Command Execution**: Run CiviCRM CLI tools using `ddev` commands.
- **Out-of-the-Box Support**: Compatible with Drupal (9, 10, 11) and Backdrop projects.
- **Error Handling**: Provides actionable error messages when dependencies are missing.
- **Tested Environment**: Includes BATS tests to validate functionality.

## Installation

1. Install the add-on using the DDEV add-on mechanism:

   ```bash
   ddev get vinugawade/ddev-civicrm-cli-tools
   ```

2. Restart your DDEV project to apply the changes:

   ```bash
   ddev restart
   ```

3. Ensure the required dependencies are installed in your project:

   ```bash
   ddev composer require civicrm/cli-tools
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
├── LICENSE
├── README.md
├── commands
│   └── web
│       ├── civistrings
│       ├── civix
│       ├── coworker
│       └── cv
├── install.yaml
└── tests
    ├── test.bats
    └── testdata
        └── composer.json
```

## Contributing

Contributions are welcome! To get started:

1. Fork the repository.
2. Create a feature branch:

   ```bash
   git checkout -b feature/your-feature
   ```

3. Commit your changes:

   ```bash
   git commit -m "add your message here"
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
