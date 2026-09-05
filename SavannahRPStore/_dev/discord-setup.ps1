<#
  Savannah RP - Discord server builder
  Creates roles, categories and channels with correct permissions via the Discord API.

  SAFE: it only ADDS. It never deletes or renames anything you already have, and it
  skips any role/channel whose name already exists. Re-running it is fine.

  YOU NEED:
    1. A bot token  ->  https://discord.com/developers/applications
                        New Application -> (left menu) Bot -> Reset Token -> copy
    2. The bot in your server WITH ADMINISTRATOR:
       OAuth2 -> URL Generator -> scope: bot  -> permission: Administrator
       open the generated link, add the bot to the Savannah server,
       then in Server Settings -> Roles, drag the bot's role near the TOP.
    3. Your Server ID:
       Discord -> Settings -> Advanced -> Developer Mode ON
       right-click the server icon -> Copy Server ID

  RUN:  double-click RUN-DISCORD-SETUP.bat
        (or right-click this file -> Run with PowerShell), paste the two values.
        Optional: put a file called  discord-config.txt  next to this one:
            TOKEN=your-bot-token
            GUILD=your-server-id
#>

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ---------- input ----------
$cfg = Join-Path $PSScriptRoot 'discord-config.txt'
if (Test-Path $cfg) {
  foreach ($ln in (Get-Content $cfg)) {
    if ($ln -match '^\s*TOKEN\s*=\s*(.+)$') { $TOKEN = $Matches[1].Trim() }
    if ($ln -match '^\s*GUILD\s*=\s*(.+)$') { $GUILD = $Matches[1].Trim() }
  }
}
if (-not $TOKEN) { $TOKEN = (Read-Host 'Paste your BOT TOKEN').Trim() }
if (-not $GUILD) { $GUILD = (Read-Host 'Paste your SERVER ID').Trim() }
if (-not $TOKEN -or -not $GUILD) { Write-Host 'Missing token or server id.' -ForegroundColor Red; exit 1 }

$Base = 'https://discord.com/api/v10'
$Headers = @{
  Authorization  = "Bot $TOKEN"
  'Content-Type' = 'application/json'
  'User-Agent'   = 'SavannahRP-Setup/1.0 (local script)'
}

function Api {
  param($Method, $Path, $Body)
  for ($try = 0; $try -lt 6; $try++) {
    try {
      $json = if ($null -ne $Body) { $Body | ConvertTo-Json -Depth 15 -Compress } else { $null }
      return Invoke-RestMethod -Method $Method -Uri "$Base$Path" -Headers $Headers -Body $json
    } catch {
      $resp = $_.Exception.Response
      if ($resp -and [int]$resp.StatusCode -eq 429) {
        $wait = 2.0
        try { $wait = [double]$resp.Headers['Retry-After'] + 0.5 } catch {}
        Write-Host "  (rate limit - waiting $wait s)" -ForegroundColor DarkYellow
        Start-Sleep -Seconds $wait
        continue
      }
      $detail = $_.ErrorDetails.Message
      if (-not $detail) { $detail = $_.Exception.Message }
      throw "API $Method $Path -> $detail"
    }
  }
  throw "API $Method $Path failed after retries"
}

try {
  $me = Api GET '/users/@me'
  Write-Host "Connected as bot: $($me.username)" -ForegroundColor Green
} catch {
  Write-Host "Could not authenticate - check the bot token.`n$_" -ForegroundColor Red
  Read-Host 'Press Enter to close'; exit 1
}

# ---------- permission flag values (all distinct powers of two) ----------
$P = @{
  ADMIN='8'; VIEW='1024'; SEND='2048'; MANAGE_CHANNELS='16'; MANAGE_ROLES='268435456'
  MANAGE_GUILD='32'; MANAGE_WEBHOOKS='536870912'; MANAGE_MESSAGES='8192'; MANAGE_NICKS='134217728'
  MANAGE_EVENTS='8589934592'; KICK='2'; BAN='4'; MODERATE='1099511627776'; AUDIT='128'
  MENTION_ALL='131072'; MOVE='16777216'; MUTE='4194304'; DEAFEN='8388608'
  HISTORY='65536'; EMBED='16384'; ATTACH='32768'; REACT='64'; EXT_EMOJI='262144'
  CONNECT='1048576'; SPEAK='2097152'; VAD='33554432'; PUB_THREADS='34359738368'
  THREAD_SEND='274877906944'; CHANGE_NICK='67108864'
}
function Bits {
  param([string[]]$Names)
  $sum = [bigint]0
  foreach ($n in $Names) { $sum = $sum + [bigint]::Parse($P[$n]) }
  $sum.ToString()
}
$MEMBER_BASE = @('VIEW','SEND','HISTORY','EMBED','ATTACH','REACT','EXT_EMOJI','PUB_THREADS','THREAD_SEND','CONNECT','SPEAK','VAD')

# ---------- 1. roles ----------
Write-Host "`n== Roles ==" -ForegroundColor Cyan
$roleId = @{ '@everyone' = $GUILD }
foreach ($r in (Api GET "/guilds/$GUILD/roles")) { $roleId[$r.name] = $r.id }

$roleDefs = @(
  @{ n = 'Owner';          c = 15844367; hoist = $true;  perms = (Bits @('ADMIN')) }
  @{ n = 'Admin';          c = 15158332; hoist = $true;  perms = (Bits @('MANAGE_GUILD','MANAGE_ROLES','MANAGE_CHANNELS','MANAGE_WEBHOOKS','MANAGE_MESSAGES','MANAGE_NICKS','MANAGE_EVENTS','KICK','BAN','MODERATE','AUDIT','MENTION_ALL','VIEW','SEND','HISTORY','EMBED','ATTACH','CONNECT','SPEAK','MOVE','MUTE','DEAFEN')) }
  @{ n = 'Moderator';      c = 15105570; hoist = $true;  perms = (Bits @('MANAGE_MESSAGES','MANAGE_NICKS','KICK','MODERATE','AUDIT','MOVE','MUTE','DEAFEN','VIEW','SEND','HISTORY','EMBED','ATTACH','CONNECT','SPEAK')) }
  @{ n = 'Support';        c = 1752220;  hoist = $true;  perms = (Bits @('MANAGE_MESSAGES','MOVE','VIEW','SEND','HISTORY','EMBED','ATTACH','CONNECT','SPEAK')) }
  @{ n = 'LSPD';           c = 3447003;  hoist = $true;  perms = '0' }
  @{ n = 'EMS';            c = 3066993;  hoist = $true;  perms = '0' }
  @{ n = 'Mechanic';       c = 9807270;  hoist = $true;  perms = '0' }
  @{ n = 'Business Owner'; c = 10181046; hoist = $true;  perms = '0' }
  @{ n = 'Customer';       c = 14201666; hoist = $false; perms = '0' }
  @{ n = 'Supporter';      c = 15915845; hoist = $false; perms = '0' }
  @{ n = 'Verified';       c = 0;        hoist = $false; perms = (Bits $MEMBER_BASE) }
)

foreach ($d in $roleDefs) {
  if ($roleId.ContainsKey($d.n)) { Write-Host "  = $($d.n) (exists)" -ForegroundColor DarkGray; continue }
  $b = @{ name = $d.n; permissions = $d.perms; mentionable = $false; hoist = $d.hoist }
  if ($d.c -gt 0) { $b.color = $d.c }
  $roleId[$d.n] = (Api POST "/guilds/$GUILD/roles" $b).id
  Write-Host "  + $($d.n)" -ForegroundColor Green
  Start-Sleep -Milliseconds 400
}

Write-Host "  * locking @everyone (no View Channel)" -ForegroundColor Yellow
Api PATCH "/guilds/$GUILD/roles/$GUILD" @{ permissions = (Bits @('CHANGE_NICK')) } | Out-Null

$order = @('Verified','Supporter','Customer','Business Owner','Mechanic','EMS','LSPD','Support','Moderator','Admin','Owner')
$posPayload = @()
$p = 1
foreach ($n in $order) { if ($roleId[$n]) { $posPayload += @{ id = $roleId[$n]; position = $p }; $p++ } }
try {
  Api PATCH "/guilds/$GUILD/roles" $posPayload | Out-Null
  Write-Host "  * role order set" -ForegroundColor Yellow
} catch {
  Write-Host "  ! could not reorder roles automatically - drag the bot's role above them and re-run, or reorder by hand." -ForegroundColor DarkYellow
}

# ---------- 2. permission-overwrite profiles ----------
function OW {
  param($Id, [string]$Allow, [string]$Deny)
  @{ id = "$Id"; type = 0; allow = "$Allow"; deny = "$Deny" }
}
$eve = $roleId['@everyone']
$ver = $roleId['Verified']
$staffIds = @()
foreach ($s in @('Support','Moderator','Admin')) { if ($roleId[$s]) { $staffIds += $roleId[$s] } }

function StaffView {
  $out = @()
  foreach ($sid in $staffIds) { $out += (OW $sid (Bits @('VIEW','SEND','HISTORY','EMBED','ATTACH')) '0') }
  $out
}

$OW_WELCOME = @()
$OW_WELCOME += (OW $eve (Bits @('VIEW','HISTORY')) (Bits @('SEND','REACT')))
$OW_WELCOME += (OW $ver (Bits @('VIEW','HISTORY')) (Bits @('SEND')))
$OW_WELCOME += (StaffView)

$OW_COMMUNITY = @()
$OW_COMMUNITY += (OW $eve '0' (Bits @('VIEW')))
$OW_COMMUNITY += (OW $ver (Bits @('VIEW','SEND','HISTORY','EMBED','ATTACH','REACT','EXT_EMOJI','PUB_THREADS','THREAD_SEND')) '0')

$OW_READONLY = @()
$OW_READONLY += (OW $eve '0' (Bits @('VIEW')))
$OW_READONLY += (OW $ver (Bits @('VIEW','HISTORY')) (Bits @('SEND')))
$OW_READONLY += (StaffView)

$OW_HIDDEN = @()
$OW_HIDDEN += (OW $eve '0' (Bits @('VIEW')))
$OW_HIDDEN += (OW $ver '0' (Bits @('VIEW')))

function DeptOW {
  param([string]$RoleName)
  $out = @()
  $out += (OW $eve '0' (Bits @('VIEW')))
  $out += (OW $ver '0' (Bits @('VIEW')))
  $out += (OW $roleId[$RoleName] (Bits @('VIEW','SEND','HISTORY','EMBED','ATTACH','REACT','CONNECT','SPEAK','VAD')) '0')
  foreach ($sid in $staffIds) { $out += (OW $sid (Bits @('VIEW','SEND','HISTORY')) '0') }
  $out
}

$OW_SUPPORTERS = @()
$OW_SUPPORTERS += (OW $eve '0' (Bits @('VIEW')))
$OW_SUPPORTERS += (OW $ver '0' (Bits @('VIEW')))
$OW_SUPPORTERS += (OW $roleId['Customer']  (Bits @('VIEW','SEND','HISTORY','EMBED','ATTACH','REACT','CONNECT','SPEAK','VAD')) '0')
$OW_SUPPORTERS += (OW $roleId['Supporter'] (Bits @('VIEW','SEND','HISTORY','EMBED','ATTACH','REACT','CONNECT','SPEAK','VAD')) '0')
foreach ($sid in $staffIds) { $OW_SUPPORTERS += (OW $sid (Bits @('VIEW','SEND','HISTORY')) '0') }

$OW_STAFF = @()
$OW_STAFF += (OW $eve '0' (Bits @('VIEW')))
$OW_STAFF += (OW $ver '0' (Bits @('VIEW')))
foreach ($sid in $staffIds) { $OW_STAFF += (OW $sid (Bits @('VIEW','SEND','HISTORY','EMBED','ATTACH','REACT','CONNECT','SPEAK','VAD')) '0') }

# ---------- 3. channel tree ----------
Write-Host "`n== Channels ==" -ForegroundColor Cyan
$catId = @{}
$haveChan = @{}
foreach ($c in (Api GET "/guilds/$GUILD/channels")) {
  if ($c.type -eq 4) { $catId[$c.name] = $c.id } else { $haveChan[$c.name] = $true }
}

function EnsureCategory {
  param([string]$Name, $Overwrites)
  if ($catId.ContainsKey($Name)) { Write-Host "  = [$Name]" -ForegroundColor DarkGray; return $catId[$Name] }
  $b = @{ name = $Name; type = 4 }
  if ($Overwrites) { $b.permission_overwrites = @($Overwrites) }
  $id = (Api POST "/guilds/$GUILD/channels" $b).id
  $catId[$Name] = $id
  Write-Host "  + [$Name]" -ForegroundColor Green
  Start-Sleep -Milliseconds 400
  return $id
}
function EnsureChannel {
  param([string]$Name, $ParentId, $Overwrites)
  if ($haveChan.ContainsKey($Name)) { Write-Host "    = #$Name" -ForegroundColor DarkGray; return }
  $b = @{ name = $Name; type = 0; parent_id = "$ParentId" }
  if ($Overwrites) { $b.permission_overwrites = @($Overwrites) }
  Api POST "/guilds/$GUILD/channels" $b | Out-Null
  $haveChan[$Name] = $true
  Write-Host "    + #$Name" -ForegroundColor Green
  Start-Sleep -Milliseconds 400
}

$cat = EnsureCategory 'WELCOME' $OW_WELCOME
foreach ($n in @('welcome','rules','verify','announcements','server-status')) { EnsureChannel $n $cat $OW_WELCOME }

$cat = EnsureCategory 'COMMUNITY' $OW_COMMUNITY
foreach ($n in @('general','media-clips','suggestions')) { EnsureChannel $n $cat $OW_COMMUNITY }

$cat = EnsureCategory 'CITY INFO' $OW_READONLY
foreach ($n in @('new-player-guide','jobs-and-careers','businesses-housing-real-estate','pd-ems-mechanics')) { EnsureChannel $n $cat $OW_READONLY }

$cat = EnsureCategory 'APPLICATIONS' $OW_READONLY
foreach ($n in @('apply-here','application-status')) { EnsureChannel $n $cat $OW_READONLY }

$cat = EnsureCategory 'SUPPORT' $OW_READONLY
foreach ($n in @('open-a-ticket','support-info')) { EnsureChannel $n $cat $OW_READONLY }

$cat = EnsureCategory 'DEPARTMENTS' $OW_HIDDEN
EnsureChannel 'lspd'            $cat (DeptOW 'LSPD')
EnsureChannel 'ems'             $cat (DeptOW 'EMS')
EnsureChannel 'mechanic'        $cat (DeptOW 'Mechanic')
EnsureChannel 'business-owners' $cat (DeptOW 'Business Owner')

$cat = EnsureCategory 'SUPPORTERS' $OW_HIDDEN
EnsureChannel 'supporter-lounge' $cat $OW_SUPPORTERS

$cat = EnsureCategory 'STAFF' $OW_STAFF
foreach ($n in @('staff-chat','staff-announcements','ticket-logs','purchase-logs','mod-logs')) { EnsureChannel $n $cat $OW_STAFF }

Write-Host "`nStructure done." -ForegroundColor Green
Write-Host @"

STILL TO DO BY HAND (bots - a script cannot install these):
  1. Wick        -> verification button in #verify ; Verified role = 'Verified'
  2. Ticket Tool -> ticket panel in #open-a-ticket ; transcripts -> #ticket-logs
  3. Carl-bot / Dyno -> log mod actions to #mod-logs
  4. (store launch) Tebex -> Discord integration -> packages grant 'Customer' / 'Supporter'
                              add a webhook -> #purchase-logs
  5. (server public) a FiveM status bot -> #server-status

Full who-can-see-what breakdown is in DISCORD-SETUP.md
"@ -ForegroundColor Cyan
Read-Host "`nPress Enter to close"
