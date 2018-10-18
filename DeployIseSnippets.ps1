New-IseSnippet -Title "CmdletBindingBlock" -Author "sdoubleday" -Description "All CmdletBinding Attributes" -Force -Text '
#Cmdlet Binding Attributes
[CmdletBinding(
#,    ConfirmImpact           ="Medium"
#,    DefaultParameterSetName ="Default"
#,    HelpURI                 =$null
#,    SupportsPaging          =$true <#Enables -First n, -Skip n, -IncludeTotalCount#>
#,    SupportsShouldProcess   =$true <#Enables -Confirm and -Whatif, for which you will want: If ($PSCmdlet.ShouldProcess("Message")) { BlockofCode } #>
#,    PositionalBinding       =$true <#True auto-enables positional. If false, [Parameter(Position=n)] overrides for those params.#>
)]
'

New-IseSnippet -Title "ParameterDecorator" -Author "sdoubleday" -Description "All ParameterDecorator Attributes" -Force -Text '
[Parameter(Mandatory= $true,ValueFromPipelineByPropertyName= $true)]
<#Map parameters from inbound objects by property name#>
#,ParameterSetName= "Default" <#If you use this, you need [Parameter()] blocks for each version, or omit to allow in all.#>
#,Position= 0
#,ValueFromPipeline= $true    <#Takes a pipeline *object*, not just parameters from it#>
#,ValueFromRemainingArgument= $true    <#Advanced.#>
#,HelpMessage= "Helpful message to display in get-help get-thisfunction -detailed"
'

New-IseSnippet -Title "ParameterValidation" -Author "sdoubleday" -Description "All ParameterValidation Attributes" -Force -Text '
#Parameter Validation Attributes
[AllowNull()]
[AllowEmptyString()]
[AllowEmptyCollection()]
[ValidateCount(1,9)]    <#Min and Max parameter count#>
[ValidateLength(1,20)]  <#Min and Max parameter character length#>
[ValidatePattern("[0-9][0-9][0-9][0-9]")]   <#Regex#>
[ValidateRange(1,99)]   <#Min and Max numeric range#>
[ValidateScript({"Based on the incoming value, stored in `$_, should resolve to a boolean or throw errors" -like $_})]  <#Not valid for Class Properties#>
[ValidateSet("This","is","a","list")]
[ValidateNotNull()]
[ValidateNotNullOrEmpty()]
'

New-IseSnippet -Title "ParameterValidation_FileName" -Author "sdoubleday" -Description "Valid a potential filename." -Force -Text '
[ValidateNotNullorEmpty()]
        [ValidateScript({<#Confirm that a proposed file path is in a directory and is valid#>
            IF (Test-Path -PathType Container -Path (Split-Path $_ -Parent) ) 
                {$true}
            ELSE {
                Throw "$_ is not in a Directory - please create directory or redirect destination."
            } 
            IF (Test-Path -Path $_ -IsValid) {$true}
            ELSE {
                Throw "File name $_ is not valid."
            }
        })][String]'

New-IseSnippet -Title "ParameterValidation_Directory" -Author "sdoubleday" -Description "Valid a Directory." -Force -Text '
[ValidateNotNullorEmpty()][ValidateScript({
            IF (Test-Path -PathType Container -Path $_ ) 
                {$True}
            ELSE {
                Throw "$_ is not a Directory."
            } 
        })][String]'

New-IseSnippet -Title "ParameterValidation_File" -Author "sdoubleday" -Description "Valid an actual file." -Force -Text '
[ValidateNotNullorEmpty()][ValidateScript({
            IF (Test-Path -PathType leaf -Path $_ ) 
                {$True}
            ELSE {
                Throw "$_ is not a file."
            } 
        })][String]'

New-IseSnippet -Title "ParameterVerboseEchoValues" -Author "sdoubleday" -Description "Verbose list the values of all parameters." -Force -Text '
#region Echo parameters (https://stackoverflow.com/questions/21559724/getting-all-named-parameters-from-powershell-including-empty-and-set-ones)
Write-Verbose "Echoing parameters:"
$ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters;
foreach ($key in $ParameterList.keys)
{
    $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
    if($var)
    {
        Write-Verbose "    $($var.name): $($var.value)"
    }
    <#Catches Dynamic Parameters with default values that were not explicitly set in the calling script.#>
    If(-not $var){
        If($PSBoundParameters[$key]) {
            "    `$PSBoundParameters[$($key)]: $($PSBoundParameters[$key])" | Write-Verbose
        }    
    }

}
Write-Verbose "Parameters done."
#endregion Echo parameters'


New-IseSnippet -Title "CleanupDirectory" -Author "sdoubleday" -Description "Removes trailing (and optionally leading) (back)slashes and standardizes (back)slashes." -Force -Text @'
###############BE SURE TO CHANGE DIRECTORY VARIABLE!################
#region Cleanup Virtual Directory - should use '/' instead of '\', leave off the final '/', should not start with a '/'
<#Clean up directory by removing trailing slash so I know I will not have double slash problems.#>
IF ($Directory.LastIndexOfAny("\/") + 1 -eq $Directory.Length) {
    $Directory = $Directory.Substring(0,$Directory.LastIndexOfAny("\/"))
} <#End If#>
#IF ($Directory.IndexOfAny("\/") -eq 0) {
#    $Directory = $Directory.Substring(1,$Directory.Length - 1)
#} <#End If#>
<#Standard windows format#>
$Directory = $Directory.Replace("/","\")
<#Web or *nix format#>
#$Directory = $Directory.Replace("\","/")
#endregion Cleanup Virtual Directory - should use '/' instead of '\', leave off the final '/', should not start with a '/'
'@

New-IseSnippet -Title "endCommentForBlock" -Author "sdoubleday" -Description "Comment for the end of a script block" -Force -Text '<# END  #>' -CaretOffset 7

New-IseSnippet -Title "pscustomobject" -Author "sdoubleday" -Description "Hashtable to pscustomobject" -Force -Text '[PSCustomObject]@{=""}' -CaretOffset 18

New-IseSnippet -Title "BeginProcessEnd" -Author "sdoubleday" -Description "Begin Process and End blocks with end tags." -Force -Text @'
BEGIN   {}<# END BEGIN    #>
PROCESS {}<# END PROCESS  #>
END     {}<# END END      #>
'@

