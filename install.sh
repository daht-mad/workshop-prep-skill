#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   Workshop Prep Skill Installer${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

BASE_URL="https://raw.githubusercontent.com/daht-mad/workshop-prep-skill/main"
SKILL_DIR="$HOME/.claude/skills/workshop-prep"
MCP_FILE="$HOME/.mcp.json"
CLAUDE_MCP="$HOME/.claude/.mcp.json"

# Check for existing installation
if [ -f "$SKILL_DIR/SKILL.md" ]; then
    echo -e "${YELLOW}⚠ 기존 설치가 발견되었습니다${NC}"
    echo ""
    echo "기존 파일을 최신 버전으로 업데이트하시겠습니까?"
    echo -e "${RED}주의: 스킬 파일을 직접 수정했다면 변경사항이 사라집니다${NC}"
    echo ""
    
    # Try to read from tty, fall back if not available
    if [ -t 0 ]; then
        # stdin is a terminal
        read -p "계속하시겠습니까? (y/N): " -n 1 -r
    elif [ -c /dev/tty ]; then
        # stdin is not terminal but /dev/tty is available
        read -p "계속하시겠습니까? (y/N): " -n 1 -r < /dev/tty
    else
        # No interactive terminal available - auto proceed
        echo -e "${YELLOW}⚠ 대화형 터미널을 사용할 수 없습니다. 3초 후 자동 업데이트를 진행합니다...${NC}"
        echo ""
        sleep 3
        REPLY="y"
    fi
    
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${YELLOW}업데이트를 취소합니다${NC}"
        exit 0
    fi
    echo ""
    echo -e "${GREEN}✓ 업데이트를 진행합니다${NC}"
    echo ""
fi

echo -e "${CYAN}[1/4]${NC} Skill 파일 다운로드 중..."
mkdir -p "$SKILL_DIR/references"

download_file() {
    if curl -fsSL "$1" -o "$2" 2>/dev/null; then
        return 0
    else
        echo -e "${RED}✗ 다운로드 실패: $1${NC}"
        return 1
    fi
}

download_file "$BASE_URL/SKILL.md" "$SKILL_DIR/SKILL.md" || exit 1
download_file "$BASE_URL/references/examples.md" "$SKILL_DIR/references/examples.md" || exit 1
download_file "$BASE_URL/references/integrations.md" "$SKILL_DIR/references/integrations.md" || exit 1
download_file "$BASE_URL/references/template.md" "$SKILL_DIR/references/template.md" || exit 1

echo -e "${GREEN}✓ Skill 설치 완료${NC} → $SKILL_DIR/"
echo ""

echo -e "${CYAN}[2/4]${NC} Context7 MCP 설정"
echo ""

CONTEXT7_ALREADY_INSTALLED=false
if [ -f "$MCP_FILE" ] && grep -q "context7" "$MCP_FILE"; then
    CONTEXT7_ALREADY_INSTALLED=true
    echo -e "${GREEN}✓ Context7 MCP가 이미 설정되어 있습니다${NC}"
fi

if [ "$CONTEXT7_ALREADY_INSTALLED" = false ]; then
    echo -e "${BOLD}Context7은 최신 라이브러리 문서를 조회하는 MCP입니다.${NC}"
    echo -e "스킬 설계서 생성 시 외부 서비스 연동 가이드를 만드는 데 사용됩니다."
    echo ""
    echo -e "API 키가 필요합니다. 무료로 발급받을 수 있어요:"
    echo -e "  ${BLUE}${BOLD}https://context7.com/dashboard${NC}"
    echo ""
    echo -e "위 링크에서 가입 → API Key 발급 → 여기에 붙여넣기"
    echo ""
    echo -e "${YELLOW}(나중에 설정하려면 그냥 Enter)${NC}"
    echo ""

    if [ -t 0 ]; then
        read -p "Context7 API Key: " CONTEXT7_KEY
    elif [ -c /dev/tty ]; then
        read -p "Context7 API Key: " CONTEXT7_KEY < /dev/tty
    else
        echo -e "${YELLOW}⚠ 대화형 터미널을 사용할 수 없습니다. API 키를 건너뜁니다.${NC}"
        CONTEXT7_KEY=""
    fi

    echo ""

    if [ -z "$CONTEXT7_KEY" ]; then
        CONTEXT7_KEY="YOUR_CONTEXT7_API_KEY"
        echo -e "${YELLOW}⚠ API 키 없이 설치합니다. 나중에 ~/.mcp.json에서 수정하세요.${NC}"
    else
        echo -e "${GREEN}✓ API 키가 입력되었습니다${NC}"
    fi

    if [ -f "$MCP_FILE" ]; then
        if command -v jq &> /dev/null; then
            jq --arg key "$CONTEXT7_KEY" '.mcpServers["context7"] = {"command": "npx", "args": ["-y", "@upstash/context7-mcp", "--api-key", $key]}' "$MCP_FILE" > "$MCP_FILE.tmp" && mv "$MCP_FILE.tmp" "$MCP_FILE"
            echo -e "${GREEN}✓ Context7 MCP 추가 완료${NC}"
        else
            echo -e "${YELLOW}⚠ jq가 없어 수동 설정이 필요합니다${NC}"
            echo ""
            echo "~/.mcp.json의 mcpServers에 다음을 추가하세요:"
            echo -e "${BLUE}\"context7\": {\"command\": \"npx\", \"args\": [\"-y\", \"@upstash/context7-mcp\", \"--api-key\", \"$CONTEXT7_KEY\"]}${NC}"
        fi
    else
        cat > "$MCP_FILE" << EOF
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp", "--api-key", "$CONTEXT7_KEY"]
    }
  }
}
EOF
        echo -e "${GREEN}✓ ~/.mcp.json 생성 완료${NC}"
    fi
fi
echo ""

echo -e "${CYAN}[3/4]${NC} Claude Code 심링크 확인..."
if [ -L "$CLAUDE_MCP" ]; then
    echo -e "${GREEN}✓ 심링크 정상${NC}"
elif [ -f "$CLAUDE_MCP" ]; then
    echo -e "${YELLOW}⚠ ~/.claude/.mcp.json이 일반 파일입니다${NC}"
    echo ""
    echo "심링크 설정이 필요합니다. 다음 명령어를 실행하세요:"
    echo -e "  ${BLUE}mv ~/.claude/.mcp.json ~/.claude/.mcp.json.bak${NC}"
    echo -e "  ${BLUE}ln -s ~/.mcp.json ~/.claude/.mcp.json${NC}"
else
    mkdir -p "$HOME/.claude"
    ln -s "$MCP_FILE" "$CLAUDE_MCP"
    echo -e "${GREEN}✓ 심링크 생성 완료${NC}"
fi
echo ""

echo -e "${CYAN}[4/4]${NC} 설치 확인"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}   설치 완료!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "다음 단계:"
echo ""
echo -e "  1. Claude Code 재시작"
echo -e "  2. ${BOLD}/workshop-prep${NC} 입력하여 시작"
echo ""

if [ "$CONTEXT7_KEY" = "YOUR_CONTEXT7_API_KEY" ]; then
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}   잊지 마세요: Context7 API 키 설정${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "  1. https://context7.com/dashboard 에서 API 키 발급"
    echo "  2. ~/.mcp.json 열기"
    echo "  3. YOUR_CONTEXT7_API_KEY를 발급받은 키로 교체"
    echo ""
fi

echo "문제가 있으면: https://github.com/daht-mad/workshop-prep-skill/issues"
echo ""
