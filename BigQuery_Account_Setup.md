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
 