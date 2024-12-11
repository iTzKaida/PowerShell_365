# Microsoft 365 Verwaltungsskript

# Skriptinformationen
$ScriptVersion = "0.3.0-alpha"
$ScriptCreator = "iTzKaida"
$ReleaseDate = "2024-12-11"
$GitHubRepo = "https://github.com/iTzKaida/PowerShell_365"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8


Write-Host "=================================" -ForegroundColor Red
Write-Host "   Microsoft 365 Verwaltungsskript   " -ForegroundColor Yellow
Write-Host "=================================" -ForegroundColor Red
Write-Host "Version: $ScriptVersion" -ForegroundColor White
Write-Host "Erstellt von: $ScriptCreator" -ForegroundColor White
Write-Host "Release-Datum: $ReleaseDate" -ForegroundColor White
Write-Host "GitHub-Repo: $GitHubRepo" -ForegroundColor White
Write-Host "=================================" -ForegroundColor Red
Write-Host "" # Abstand hinzufügen

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
    Write-Host "3: Windows-Server-Skripte" -ForegroundColor White
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

function Show-WindowsServerMenu {
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "   Windows-Server-Skripte   " -ForegroundColor Yellow
    Write-Host "=================================" -ForegroundColor Cyan
    Write-Host "1: Azure AD Connect" -ForegroundColor White
    Write-Host "2: Allgemeine Skripte" -ForegroundColor White
    Write-Host "3: Zurück zum Hauptmenü" -ForegroundColor White
    Write-Host "=================================" -ForegroundColor Cyan
}

function Check-GitHubUpdates {
    Write-Host "Prüfe auf Updates auf GitHub..." -ForegroundColor Cyan
    $url = "https://api.github.com/repos/iTzKaida/PowerShell_365/tags"
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        $tags = $response.Content | ConvertFrom-Json
        if ($tags.Count -gt 0) {
            $latestTag = $tags[0].name
            $tagUrl = "https://github.com/iTzKaida/PowerShell_365/releases/tag/$latestTag"
            Write-Host "Die neueste Version ist: $latestTag" -ForegroundColor Green
            Write-Host "Details und Download: $tagUrl" -ForegroundColor White
        } else {
            Write-Host "Keine Tags gefunden. Bitte überprüfen Sie das Repository." -ForegroundColor Red
        }
    } catch {
        Write-Host "Fehler beim Abrufen der Informationen: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Login-M365 {
    Write-Host "Starte Anmeldung bei Microsoft 365..." -ForegroundColor Cyan
    Connect-ExchangeOnline -ShowBanner:$false
    Write-Host "Anmeldung erfolgreich." -ForegroundColor Green
    Show-SubMenu
    $subExit = $false
    while (-not $subExit) {
        $subChoice = Read-Host "Bitte wählen Sie eine Option"

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

function AzureADConnect {
    Write-Host "Azure AD Connect Skripte ausführen..." -ForegroundColor Cyan
    # Hier können spezifische Skripte oder Befehle für Azure AD Connect hinzugefügt werden
    Write-Host "Funktion in Arbeit." -ForegroundColor Yellow
}

function GeneralScripts {
    Write-Host "Allgemeine Windows-Server-Skripte ausführen..." -ForegroundColor Cyan
    # Hier können spezifische allgemeine Skripte hinzugefügt werden
    Write-Host "Funktion in Arbeit." -ForegroundColor Yellow
}

# Hauptmenü-Logik
$exit = $false
while (-not $exit) {
    Show-MainMenu
    $choice = Read-Host "Bitte wählen Sie eine Option"

    switch ($choice) {
        "1" {
            Login-M365
        }
        "2" {
            Check-GitHubUpdates
        }
        "3" {
            $subExit = $false
            while (-not $subExit) {
                Show-WindowsServerMenu
                $subChoice = Read-Host "Bitte wählen Sie eine Option"

                switch ($subChoice) {
                    "1" {
                        AzureADConnect
                    }
                    "2" {
                        GeneralScripts
                    }
                    "3" {
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
