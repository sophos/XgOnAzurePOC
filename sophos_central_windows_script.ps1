$url=$args[0]
$installer = "C:\SophosInstall.exe"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $installer)
& $installer -q