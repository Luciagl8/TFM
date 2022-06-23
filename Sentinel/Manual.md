# Adding a Sentinel
1. Edit the sentinel-template.parameters.json with the values needed
2. Run the next command:
    >>> az deployment group create --resource-group Arc-AWS-Demo --template-file ./sentinel-template.json --parameters ./sentinel-template.parameters.json

# Connect AWS CloudTrailLogs to sentinel
1. Follow the instructions in https://docs.microsoft.com/en-us/azure/sentinel/connect-aws?tabs=ct

# Connect Microsoft defender for Cloud
1. Follow the instructions in https://docs.microsoft.com/en-us/azure/sentinel/connect-defender-for-cloud
