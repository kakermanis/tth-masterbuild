# Template SFDX project setup for Q Industries IDOs
After creating a number of SFDX projects for the Travel & Hospitality IDO, I've create a set of common things I needed in each of them.  This project template WILL NEED editing to be appropriate for your IDO so please know that it just won't work for you out of the box if you clone it.

# Environment setup
There are a few toolkits as well as SFDX extensions you will need to install to make this all work.

* SalesforceDX CLI - https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm

* Heroku CLI - https://devcenter.heroku.com/articles/heroku-cli

* SFDX Plug-ins

   * texei-sfdc-plugin (for automatic package dependency installation) - https://github.com/texei/texei-sfdx-plugin/ (command line install: sfdx plugins:install texei-sfdx-plugin)

   * Shane McLaughlan SFDX plugins - https://github.com/mshanemc/shane-sfdx-plugins (command line install: sfdx plugins:install shane-sfdx-plugins)

* Forcedotcom Dataloader - https://help.salesforce.com/articleView?id=loader_install_general.htm&type=5 - following install steps from link, copy the dataloader-<version>.jar to the SFDX project folder bin/dataloader and rename to dataloader.jar

  * Once you've installed dataloader and done the necessary moving around and renaming of the dataloader.jar you can complete the setup by running the dataloaderSetup.sh script which helps to complete the setup of running dataloader in a headless manner

  * Manual Dataloader setup steps (if the dataloaderSetup.sh file doesn't work for you)

     * NOTE: On Mac, you'll need to run this manually in terminal in a similar fashion (stolen from the windows encrypt.bat file here https://github.com/forcedotcom/dataloader/blob/master/release/win/bin/encrypt.bat)

     * Generate a keyfile first:
     ```
     java -cp bin/dataloader/dataloader.jar com.salesforce.dataloader.security.EncryptionUtil -k data/prod/config/login.key
     ```

     * Choose default password and run it through the encryption process eg:
     ```
     java -cp bin/dataloader/dataloader.jar com.salesforce.dataloader.security.EncryptionUtil -e <YourPassWord> data/prod/config/login.key
     ```

  * Ensure you've also setup the two environment variables (DX_DEF_PWD and DX_ENC_PWD) in your .bashrc file
     * DX_DEF_PWD - is the default password you are choosing for all your orgs
     * DX_ENC_PWD - is the output of the EncryptionUtil and represents the encrypted value of the above default password     
     * The values of those two variables comes from either running the dataloaderSetup.sh script or thru the above manual steps

# Project specific setup changes

1) SFDX Project Setup
   - Rename the project folder from ido-tth-template to something more meaningful. Please keep the ido at the start so we can easily find our stuff within the SFDC GitHub organisation. General format is: ido-<industry>-<package name> for example for FINS I'd suggest ido-fins-bankingBaseDM
   - Rename the tth- folder within the project - again something more meaningful and reflective of your industry and package. E.G to follow on from the above FINS example for FINS fins-banking-dm
   - Within the sfdx-project.json file, change the path element to reflect the change you did in step 2
   - Update the config/project-scratch-def.json to include the appropriate features and settings
   - Update orgName in config/project-scratch-def.json
   - Tailor your .gitignore and .forceignore to be appropriate for your project
   - Update sfdx-project.json to have the appropriate alias' you require

2) DEV Datasets
   - DEV dataload - Uses SFDX dataload JSON format and is only for use with Scratch orgs. Master dataload plan kept here data/devt/data-load-plan.json and all data files under here data/devt

3) PROD Datasets
   - PROD dataload (leveraging Dataloader and QLabs datapack format) Update data/prod/config/process-conf.xml to reflect the appropriate PROD dataload processes/files (which are kept in data/prod/) and ensure mappings (kept at data/prod/mappings) are also appropriate
   - Update scripts/bash/loadProdData.sh to call appropriate dataloader processes as defined within data/prod/config/process-conf.xml
