# Slack 연동 가이드

## 개요

| 항목 | 내용 |
|------|------|
| **용도** | 슬랙 채널에 요약 메시지 공유 |
| **복잡도** | 중간 (Bot Token 필요) |
| **예상 시간** | 15-20분 |
| **사전 준비** | 워크샵 전 미리 설정 권장 |

---

## 설정 단계

### 1. Slack App 생성

1. [Slack API](https://api.slack.com/apps) 접속
2. **"Create New App"** 클릭
3. **"From scratch"** 선택
4. App Name 입력 (예: "Study Digest Bot")
5. 워크스페이스 선택 → **"Create App"**

### 2. Bot Token 권한 설정

1. 좌측 메뉴 → **"OAuth & Permissions"**
2. **"Scopes"** 섹션으로 스크롤
3. **"Bot Token Scopes"**에 다음 권한 추가:
   - `chat:write` - 메시지 전송
   - `channels:read` - 채널 목록 조회
   - `channels:join` - 퍼블릭 채널 참여 (선택)

### 3. 워크스페이스에 앱 설치

1. 좌측 메뉴 → **"Install App"**
2. **"Install to Workspace"** 클릭
3. 권한 검토 후 **"허용"** 클릭

### 4. Bot Token 복사

설치 완료 후 **"Bot User OAuth Token"** 복사:
```
xoxb-xxxxxxxxxxxx-xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxx
```

⚠️ `xoxb-`로 시작하는 토큰입니다.

### 5. MCP 설정 파일에 추가

`~/.mcp.json`에 추가:

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "slack-mcp-server@latest", "--transport", "stdio"],
      "env": {
        "SLACK_MCP_XOXP_TOKEN": "xoxb-your-token-here"
      }
    }
  }
}
```

### 6. 봇을 채널에 초대

메시지를 보내고 싶은 채널에서:
```
/invite @Study Digest Bot
```

또는 채널 설정 → 통합 → 앱 추가

---

## 테스트 방법

Claude Code에서:
```
#테스트채널에 "안녕하세요!" 메시지 보내줘
```

정상이면 해당 채널에 메시지가 전송됩니다.

---

## 주의사항

⚠️ **프라이빗 채널**:
- 봇이 초대되어야 메시지 전송 가능
- `groups:write` 스코프 추가 필요할 수 있음

⚠️ **토큰 관리**:
- 토큰을 코드에 직접 넣지 마세요
- 환경변수나 비밀 관리 도구 사용 권장

---

## 대안: XOXC/XOXD 토큰 사용

브라우저 개발자 도구에서 토큰을 추출하는 방법도 있습니다:
- 별도 앱 생성 불필요
- 본인 계정 권한으로 동작
- 자세한 방법은 [slack-mcp-server 문서](https://github.com/korotovsky/slack-mcp-server) 참조

---

## 참고 링크

- [Slack MCP Server GitHub](https://github.com/korotovsky/slack-mcp-server)
- [Slack API - Create App](https://api.slack.com/apps)
- [Slack API - OAuth Scopes](https://api.slack.com/scopes)
