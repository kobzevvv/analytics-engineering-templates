# 'How to Use' Guide:

This repository is created to collect example of standard analytics engineering tasks like:
— check examples about how to optimise performance
- make standard templates for data cleaning and deduplication
- data marts building best practices


## Prerequisites

Replace:
put gbq_creds.json to conf -> dbt ->


## Installation and Cloning the Repository

### Visual Studio Code

- Download Visual Studio Code
- To clone the repository, execute the command: `git clone git@github.com:qalearn-shop/qalearn-prospects-dbt.git`
- Use `Ctrl+P` (Command+P on macOS) to quickly access files using keyword tips.

## Credentials

### Add BigQuery Access

- Get access to the corporate Google account (data@)
- Go to the service account: dbt-connection-prospects (accessible for the data@ Google account)
- Link: [Google Cloud IAM Admin](https://console.cloud.google.com/iam-admin/serviceaccounts/details/115993050948348682423/keys?hl=en&project=qalearn-prospects) / if you don't have access to this bigquery project you can use else one. just be sure that it contain test schema=datasets

- Generate a JSON key for the dbt service account (or use an existing one). This account already has the necessary permissions.
- Paste the JSON key into the file `gbq_creds.json.example` (located in `conf\.dbt`)
- Rename the file to `gbq_creds.json` (remove `.example`)

## Running dbt

- Install Docker (you can access the free version on the official website).
- Install dbt (you can use Git Bash or Windows PowerShell).
  - For proper installation, use the command `pip install dbt` or, if this command doesn't work, `python3 -m pip install dbt`.
- dbt guide references:
  - [dbt Commands Documentation](https://docs.getdbt.com/reference/dbt-commands)
- Basic commands template:

  - `dbt run -m test_model -t test`
    - Explanation: This command
      1. Compiles Jinja in the file to SQL code in the /target folder `test_model.sql` (you can find this compiled version in the VS Code target folder)
      2. Executes SQL code from the target folder
      3. Prints a log of the command in the console and in the log file: `dbt.log`
  - To run a model with all "parent-models" and "child-models":
    - dbt run -m +data_model_file_name+ -t dbt_transform`

- To run dbt commands with a docker container, we use Linux shell batch script file './run_inside_docker.sh'


### Workarounds

- If there is an access problem for `run_inside_docker.sh`:
  - `chmod +x run_inside_docker.sh`
  - `ls -l run_inside_docker.sh`
  - `sed -i 's/\r$//' run_inside_docker.sh` (removes mismatch of special symbols in Linux and Windows OS)

# Working Folder

- The most used folder will be the `data_models` folder.


