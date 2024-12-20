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

  - `./run_inside_docker.sh dbt run -m test_model -t test`
        output for succssfull run example:
            21:25:48  1 of 1 START sql view model test.test_model .................................... [RUN]
            21:25:49  1 of 1 OK created sql view model test.test_model ............................... [CREATE VIEW (0 processed) in 1.54s]

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

# 'How to Create a Google Cloud Account and Set Up Access to BigQuery'

1. Create a Google Cloud Account
 - Go to the [Google Cloud website](https://cloud.google.com/).
 - Click 'Get started' for free.
 - Enter your email address and follow the instructions to register a new account or log in if you already have one.
 - During registration, select your country, for example, Russia.

2. Create a Project in Google Cloud
 - After logging in, go to the [Google Cloud Console](https://console.cloud.google.com/).
 - From the top menu, select 'Project' → 'Create Project'.
 - Give your project a name, such as 'My BigQuery Project', and select an organization (if necessary).
 - Click 'Create'.

 3. Enable BigQuery API
 - After creating your project, go to the 'APIs & Services' section.
 - In the 'API Library', search for 'BigQuery API'.
 - Click 'Enable'.

 4. Create a Service Account
 - Go to 'IAM & Admin' → 'Service Accounts'.
 - Click Create Service Account.
 - Provide a name for the account, such as bigquery-service-account, and add a description, for example, "Service account for BigQuery access".
 - Click 'Create and Continue'.
 - Assign roles to the account:
  "Choose the BigQuery Admin role" to grant full access to BigQuery.
 - Click Done.

 5. Create a Key for the 'Service Account'
 - In the 'Service Accounts' section, find the account you just created.
 - Click the three dots on the right and select 'Create Key'.
 - Choose the JSON format and click 'Create'.
 - Download the key file and save it securely.

 6. Set Up Access via BigQuery
 - Go to the BigQuery section in the Google Cloud Console.
 - Select the project you created earlier.
 - In the left pane, choose a dataset and start working with BigQuery.
 - To work via API or the command line, set the [GOOGLE_APPLICATION_CREDENTIALS] environment variable to point to the downloaded JSON key.

 7. (Optional) Grant Access to Other Users
 - Go to 'IAM & Admin'.
 - Add users who need access and assign appropriate roles, such as 'BigQuery Admin'.
 
