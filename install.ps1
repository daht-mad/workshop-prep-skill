# Workshop Prep Skill Installer (Windows)
# PowerShell 5.1+ required

$ErrorActionPreference = "Stop"

function Write-Color {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

Write-Host ""
Write-Color "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Blue"
Write-Color "   Workshop Prep Skill Installer" "Blue"
Write-Color "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Blue"
Write-Host ""

$BaseUrl = "https://raw.githubusercontent.com/daht-mad/workshop-prep-skill/main"
$SkillDir = "$env:USERPROFILE\.claude\skills\workshop-prep"
$McpFile = "$env:USERPROFILE\.mcp.json"
$ClaudeMcp = "$env:USERPROFILE\.claude\.mcp.json"

# Check for existing installation
if (Test-Path "$SkillDir\SKILL.md") {
    Write-Color "⚠ 기존 설치가 발견되었습니다" "Yellow"
    Write-Host ""
    Write-Host "기존 파일을 최신 버전으로 업데이트하시겠습니까?"
    Write-Color "주의: 스킬 파일을 직접 수정했다면 변경사항이 사라집니다" "Red"
    Write-Host ""
    
    # Try to read from console
    try {
        if ([Console]::KeyAvailable -or $Host.UI.RawUI.KeyAvailable) {
            Write-Host "계속하시겠습니까? (y/N): " -NoNewline
            $response = [Console]::ReadLine()
        } else {
            Write-Host "계속하시겠습니까? (y/N): " -NoNewline
            $response = Read-Host
        }
    } catch {
        Write-Color "⚠ 대화형 입력을 사용할 수 없습니다. 3초 후 자동 업데이트를 진행합니다..." "Yellow"
        Write-Host ""
        Start-Sleep -Seconds 3
        $response = "y"
    }
    
    if ($response -ne "y" -and $response -ne "Y") {
        Write-Host ""
        Write-Color "업데이트를 취소합니다" "Yellow"
        exit 0
    }
    Write-Host ""
    Write-Color "✓ 업데이트를 진행합니다" "Green"
    Write-Host ""
}

Write-Color "[1/4] Skill 파일 다운로드 중..." "Cyan"

New-Item -ItemType Directory -Force -Path "$SkillDir\references" | Out-Null

function Download-File {
    param([string]$Url, [string]$Dest)
    try {
        Invoke-WebRequest -Uri $Url -OutFile $Dest -UseBasicParsing
        return $true
    } catch {
        Write-Color "✗ 다운로드 실패: $Url" "Red"
        return $false
    }
}

$files = @(
    @{Url="$BaseUrl/SKILL.md"; Dest="$SkillDir\SKILL.md"},
    @{Url="$BaseUrl/references/examples.md"; Dest="$SkillDir\references\examples.md"},
    @{Url="$BaseUrl/references/integrations.md"; Dest="$SkillDir\references\integrations.md"},
    @{Url="$BaseUrl/references/template.md"; Dest="$SkillDir\references\template.md"}
)

foreach ($file in $files) {
    if (-not (Download-File -Url $file.Url -Dest $file.Dest)) {
        exit 1
    }
}

Write-Color "✓ Skill 설치 완료 → $SkillDir\" "Green"
Write-Host ""

Write-Color "[2/4] Context7 MCP 설정" "Cyan"
Write-Host ""

$Context7AlreadyInstalled = $false
if ((Test-Path $McpFile) -and (Select-String -Path $McpFile -Pattern "context7" -Quiet)) {
    $Context7AlreadyInstalled = $true
    Write-Color "✓ Context7 MCP가 이미 설정되어 있습니다" "Green"
}

if (-not $Context7AlreadyInstalled) {
    Write-Host "Context7은 최신 라이브러리 문서를 조회하는 MCP입니다." -ForegroundColor White
    Write-Host "스킬 설계서 생성 시 외부 서비스 연동 가이드를 만드는 데 사용됩니다."
    Write-Host ""
    Write-Host "API 키가 필요합니다. 무료로 발급받을 수 있어요:"
    Write-Color "  https://context7.com/dashboard" "Blue"
    Write-Host ""
    Write-Host "위 링크에서 가입 → API Key 발급 → 여기에 붙여넣기"
    Write-Host ""
    Write-Color "(나중에 설정하려면 그냥 Enter)" "Yellow"
    Write-Host ""

    try {
        if ([Console]::KeyAvailable -or $Host.UI.RawUI.KeyAvailable) {
            Write-Host "Context7 API Key: " -NoNewline
            $Context7Key = [Console]::ReadLine()
        } else {
            Write-Host "Context7 API Key: " -NoNewline
            $Context7Key = Read-Host
        }
    } catch {
        Write-Color "⚠ 대화형 입력을 사용할 수 없습니다. API 키를 건너뜁니다." "Yellow"
        $Context7Key = ""
    }

    Write-Host ""

    if ([string]::IsNullOrWhiteSpace($Context7Key)) {
        $Context7Key = "YOUR_CONTEXT7_API_KEY"
        Write-Color "⚠ API 키 없이 설치합니다. 나중에 ~/.mcp.json에서 수정하세요." "Yellow"
    } else {
        Write-Color "✓ API 키가 입력되었습니다" "Green"
    }

    $Context7Config = @{
        command = "npx"
        args = @("-y", "@upstash/context7-mcp", "--api-key", $Context7Key)
    }

    if (Test-Path $McpFile) {
        $mcpContent = Get-Content $McpFile -Raw | ConvertFrom-Json
        $mcpContent.mcpServers | Add-Member -NotePropertyName "context7" -NotePropertyValue $Context7Config
        $mcpContent | ConvertTo-Json -Depth 10 | Set-Content $McpFile -Encoding UTF8
        Write-Color "✓ Context7 MCP 추가 완료" "Green"
    } else {
        $newMcp = @{
            mcpServers = @{
                context7 = $Context7Config
            }
        }
        $newMcp | ConvertTo-Json -Depth 10 | Set-Content $McpFile -Encoding UTF8
        Write-Color "✓ ~/.mcp.json 생성 완료" "Green"
    }
}
Write-Host ""

Write-Color "[3/4] Claude Code 설정 확인..." "Cyan"

$claudeDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null
}

if (Test-Path $ClaudeMcp) {
    $linkTarget = (Get-Item $ClaudeMcp).Target
    if ($linkTarget -eq $McpFile) {
        Write-Color "✓ 심링크 정상" "Green"
    } else {
        Write-Color "⚠ ~/.claude/.mcp.json이 존재합니다" "Yellow"
        Write-Host ""
        Write-Host "Windows에서는 심링크 대신 파일 복사를 권장합니다."
        Write-Host "다음 명령어로 설정을 동기화하세요:"
        Write-Color "  Copy-Item `"$McpFile`" `"$ClaudeMcp`" -Force" "Blue"
    }
} else {
    Copy-Item $McpFile $ClaudeMcp -Force
    Write-Color "✓ MCP 설정 복사 완료" "Green"
}
Write-Host ""

Write-Color "[4/4] 설치 확인" "Cyan"
Write-Host ""
Write-Color "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Blue"
Write-Color "   설치 완료!" "Green"
Write-Color "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Blue"
Write-Host ""
Write-Host "다음 단계:"
Write-Host ""
Write-Host "  1. Claude Code 재시작"
Write-Host "  2. /workshop-prep 입력하여 시작"
Write-Host ""

if ($Context7Key -eq "YOUR_CONTEXT7_API_KEY") {
    Write-Color "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Yellow"
    Write-Color "   잊지 마세요: Context7 API 키 설정" "Yellow"
    Write-Color "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" "Yellow"
    Write-Host ""
    Write-Host "  1. https://context7.com/dashboard 에서 API 키 발급"
    Write-Host "  2. $McpFile 열기"
    Write-Host "  3. YOUR_CONTEXT7_API_KEY를 발급받은 키로 교체"
    Write-Host ""
}

Write-Host "문제가 있으면: https://github.com/daht-mad/workshop-prep-skill/issues"
Write-Host ""
