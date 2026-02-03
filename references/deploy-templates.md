# Deploy Templates

Phase 7에서 GitHub 배포 시 사용하는 템플릿들.

## Table of Contents

- [README.md Template](#readmemd-template)
- [install.sh Template](#installsh-template)
- [install.ps1 Template](#installps1-template)

---

## README.md Template

배포 시 자동 생성되는 README 형식.

```markdown
# {스킬명}

{한 줄 설명}

## 설치

### macOS / Linux
\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/{username}/{스킬명}/main/install.sh | bash
\`\`\`

### Windows (PowerShell)
\`\`\`powershell
irm https://raw.githubusercontent.com/{username}/{스킬명}/main/install.ps1 | iex
\`\`\`

## 환경변수 설정

이 스킬을 사용하려면 다음 환경변수가 필요합니다:

| 변수명 | 설명 | 발급 방법 |
|--------|------|----------|
{.env.example 기반으로 테이블 생성}

### 설정 방법

1. `.env.example`을 `.env`로 복사:
   \`\`\`bash
   cp .env.example .env
   \`\`\`

2. `.env` 파일을 열어 실제 값 입력

3. Claude Code에서 스킬 사용 시작!

> **Tip**: Claude Code에게 API 키를 알려주면 자동으로 .env에 설정해줘요!
> 예: "슬랙 토큰은 xoxb-xxxx야"

## 사용법

\`\`\`
{트리거 예시}
\`\`\`

## 만든 사람

{이름 또는 GitHub 사용자명}

## 라이선스

MIT
```

---

## install.sh Template

macOS/Linux 원클릭 설치 스크립트.

```bash
#!/bin/bash
set -e

SKILL_NAME="{스킬명}"
BASE_URL="https://raw.githubusercontent.com/{username}/${SKILL_NAME}/main"
SKILL_DIR="$HOME/.claude/skills/${SKILL_NAME}"

echo "Installing ${SKILL_NAME}..."

mkdir -p "$SKILL_DIR"

# 파일 다운로드
curl -fsSL "$BASE_URL/SKILL.md" -o "$SKILL_DIR/SKILL.md"
# (필요한 다른 파일들)

echo "✓ 설치 완료: $SKILL_DIR/"
echo ""
echo "사용법: Claude Code에서 '/{스킬 트리거}' 입력"
```

---

## install.ps1 Template

Windows PowerShell 원클릭 설치 스크립트.

```powershell
$ErrorActionPreference = "Stop"

$SkillName = "{스킬명}"
$BaseUrl = "https://raw.githubusercontent.com/{username}/$SkillName/main"
$SkillDir = "$env:USERPROFILE\.claude\skills\$SkillName"

Write-Host "Installing $SkillName..."

New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null

# 파일 다운로드
Invoke-WebRequest -Uri "$BaseUrl/SKILL.md" -OutFile "$SkillDir\SKILL.md"
# (필요한 다른 파일들)

Write-Host "✓ 설치 완료: $SkillDir\"
Write-Host ""
Write-Host "사용법: Claude Code에서 '/{스킬 트리거}' 입력"
```

---

## 플레이스홀더 치환 규칙

| 플레이스홀더 | 치환값 |
|-------------|--------|
| `{스킬명}` | Phase 5에서 확정된 영문 kebab-case 이름 |
| `{username}` | `gh api user --jq .login`으로 조회 |
| `{한 줄 설명}` | Phase 5에서 확정된 설명 |
| `{트리거 예시}` | SKILL.md의 트리거 목록 |
