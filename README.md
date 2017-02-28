# Powershell-Jira
Get sum of all work in a day for a given Project

Required inputs (configured in script) 

$apiUrl - The path to your jira instance api

$projectPrefix - The abbreviated short letter for your Project

$username - your username for jira

$password - your password for jira

The script will pull up to 1000 worklog entries for the current day and find the sum of the total hours you have entered. 
