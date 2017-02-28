# Find the sum all of your work for the current day in a given project

$dateNow = Get-Date -format s
$dateStart = $dateNow.Substring(0,10)
$apiUrl = ""                                            # url to your jira api
$projectPrefix = ""                                     # project prefix
$username = ""                                          # your jira username
$password = ""                                          # your jira password

$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username + ":" + $password))
$headers = @{"Authorization" = "Basic $auth"}

$searchParam = "search?jql=assignee in ($username) and updated > $dateStart and project in ($projectPrefix) and timespent > 0&fields=summary,worklog&maxResults=1000"
$searchUrl = [uri]::EscapeUriString(-join ($apiUrl,$searchParam))
$total = 0;

$request = Invoke-WebRequest -Headers $headers -Method Get -Uri $searchUrl 
$json = ConvertFrom-Json $request.Content

foreach ($issue in $json."issues")
{    
    $subtotal = 0

    foreach ($worklog in $issue."fields".worklog.worklogs)
    {
        if ($worklog."created".CompareTo($dateStart) -eq 1)
        {
            $seconds = $worklog."timeSpentSeconds"
            $total = $total + ([int]$seconds / 60 / 60)
            $subtotal = $subtotal + ([int]$seconds / 60 / 60)
        }
    }
    
    $key = $issue."key"
    Write-Output "$key : $subtotal"
    
 }

Write-Output "Total : $total"