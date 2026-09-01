# ==========================================
# CONFIGURAZIONE
# ==========================================

$Sorgente = "C:\Users\tomma\Documents\Scuola\Lezioni\Altro\Mappe"

$Repository = "C:\Users\tomma\Documents\Varie\Mappe Nodely"

$Destinazione = "$Repository\docs"


# ==========================================
# CONTROLLO CARTELLA GOOGLE DRIVE
# ==========================================

if (!(Test-Path $Sorgente)) {
    Write-Host ""
    Write-Host "ERRORE: cartella Google Drive non trovata."
    Write-Host ""
    Write-Host $Sorgente
    Write-Host ""
    exit 1
}


# ==========================================
# CONTROLLO REPOSITORY
# ==========================================

if (!(Test-Path "$Repository\.git")) {
    Write-Host ""
    Write-Host "ERRORE: repository Git non trovato."
    Write-Host ""
    exit 1
}


# ==========================================
# AGGIORNA LA COPIA LOCALE DA GITHUB
# ==========================================

Set-Location $Repository

git fetch origin

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Errore durante il collegamento a GitHub."
    exit 1
}

git reset --hard origin/main


# ==========================================
# COPIA DRIVE -> DOCS
# ==========================================

robocopy $Sorgente $Destinazione /MIR /R:2 /W:2

$RobocopyResult = $LASTEXITCODE

if ($RobocopyResult -gt 7) {
    Write-Host ""
    Write-Host "ERRORE durante la copia dei file."
    exit 1
}


# ==========================================
# CONTROLLA SE È CAMBIATO QUALCOSA
# ==========================================

git add -A

git diff --cached --quiet

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Nessuna modifica da pubblicare."
    Write-Host ""
    exit 0
}


# ==========================================
# CREA IL COMMIT
# ==========================================

$Data = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

git commit -m "Aggiornamento automatico mappe - $Data"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Errore durante la creazione del commit."
    exit 1
}


# ==========================================
# PUBBLICA SU GITHUB
# ==========================================

git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "MAPPE PUBBLICATE CORRETTAMENTE."
    Write-Host ""
}
else {
    Write-Host ""
    Write-Host "Il push non è riuscito."
    Write-Host "Lo script potrà riprovare alla prossima esecuzione."
    Write-Host ""
}