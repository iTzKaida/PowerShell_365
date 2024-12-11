# Microsoft 365 Verwaltungsskript

# Skriptinformationen
$ScriptVersion = "0.1.0"
$ScriptCreator = "PNDRA"
$ReleaseDate = "2024-12-11"

Write-Host "=================================" -ForegroundColor Cyan
Write-Host "   Microsoft 365 Verwaltungsskript   " -ForegroundColor Yellow
Write-Host "=================================" -ForegroundColor Cyan
Write-Host "Version: $ScriptVersion" -ForegroundColor White
Write-Host "Erstellt von: $ScriptCreator" -ForegroundColor White
Write-Host "Release-Datum: $ReleaseDate" -ForegroundColor White
Write-Host "=================================" -ForegroundColor Cyan

# Sicherstellen, dass das benötigte Modul installiert ist
if (!(Get-Module -ListAvailable -Name "ExchangeOnlineManagement")) {
    Write-Host "Installiere Exchange Online Management Modul..."
    Install-Module -Name ExchangeOnlineManagement -Force -Scope CurrentUser
}

function Show-MainMenu {
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "   Microsoft 365 Start Menu   " -ForegroundColor Yellow
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "1: Login in Microsoft 365" -ForegroundColor White
    Write-Host "2: Nach Updates suchen (GitHub)" -ForegroundColor White
    Write-Host "0: Beenden" -ForegroundColor White
    Write-Host "=================================" -ForegroundColor Cyan
}

function Show-SubMenu {
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "   Microsoft 365 Funktionen   " -ForegroundColor Yellow
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "1: Benutzerliste anzeigen" -ForegroundColor White
    Write-Host "2: Lizenzinformationen abrufen" -ForegroundColor White
    Write-Host "3: Abmelden" -ForegroundColor White
    Write-Host "=================================" -ForegroundColor Cyan
}

function Check-GitHubUpdates {
    Write-Host "Prüfe auf Updates auf GitHub..." -ForegroundColor Cyan
    try {
        $response = Invoke-WebRequest -Uri "https://api.github.com/repos/IHR_USERNAME/IHR_REPOSITORY/releases/latest" -UseBasicParsing
        $release = $response.Content | ConvertFrom-Json
        Write-Host "Die neueste Version ist: $($release.tag_name)" -ForegroundColor Green
        Write-Host "Details: $($release.html_url)" -ForegroundColor White
    } catch {
        Write-Host "Konnte keine Informationen abrufen. Bitte überprüfen Sie Ihre Internetverbindung oder die GitHub-URL." -ForegroundColor Red
    }
}

function Login-M365 {
    Write-Host "Starte Anmeldung bei Microsoft 365..." -ForegroundColor Cyan
    Connect-ExchangeOnline -ShowBanner:$false
    Write-Host "Anmeldung erfolgreich." -ForegroundColor Green
    Show-SubMenu
    $subExit = $false
    while (-not $subExit) {
        $subChoice = Read-Host ([char]0x0042 + "itte w" + [char]0x00E4 + "hlen Sie eine Option")

        switch ($subChoice) {
            "1" {
                Show-Users
            }
            "2" {
                Show-Licenses
            }
            "3" {
                Logout-M365
                $subExit = $true
            }
            default {
                Write-Host "Ungültige Eingabe, bitte erneut versuchen." -ForegroundColor Red
            }
        }

        if (-not $subExit) {
            Write-Host "Drücken Sie eine beliebige Taste, um zum Menü zurückzukehren..." -ForegroundColor Gray
            Read-Host
        }
    }
}

function Show-Users {
    Write-Host "Benutzer werden abgerufen..." -ForegroundColor Cyan
    Get-ExoMailbox -ResultSize Unlimited | Select-Object DisplayName, PrimarySmtpAddress | Format-Table -AutoSize
}

function Show-Licenses {
    Write-Host "Lizenzinformationen werden abgerufen..." -ForegroundColor Cyan
    Get-MsolAccountSku | Select-Object AccountSkuId, ActiveUnits, ConsumedUnits | Format-Table -AutoSize
}

function Logout-M365 {
    Write-Host "Melde ab von Microsoft 365..." -ForegroundColor Cyan
    Disconnect-ExchangeOnline -Confirm:$false
    Write-Host "Abmeldung erfolgreich." -ForegroundColor Green
}

# Hauptmenü-Logik
$exit = $false
while (-not $exit) {
    Show-MainMenu
    $choice = Read-Host ([char]0x0042 + "itte w" + [char]0x00E4 + "hlen Sie eine Option")

    switch ($choice) {
        "1" {
            Login-M365
        }
        "2" {
            Check-GitHubUpdates
        }
        "0" {
            $exit = $true
            Write-Host "Programm wird beendet." -ForegroundColor Yellow
        }
        default {
            Write-Host "Ungültige Eingabe, bitte erneut versuchen." -ForegroundColor Red
        }
    }

    if (-not $exit) {
        Write-Host "Drücken Sie eine beliebige Taste, um fortzufahren..." -ForegroundColor Gray
        Read-Host
    }
}
