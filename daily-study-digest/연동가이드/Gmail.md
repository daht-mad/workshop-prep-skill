# Gmail 연동 가이드

## 개요

| 항목 | 내용 |
|------|------|
| **용도** | 스터디장에게 이메일 발송 |
| **복잡도** | 중간 (OAuth 설정 필요) |
| **예상 시간** | 20-30분 |
| **사전 준비** | 워크샵 전 미리 설정 권장 |

---

## 설정 단계

### 1. Google Cloud 프로젝트 생성

1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. 상단의 프로젝트 선택 드롭다운 클릭
3. **"새 프로젝트"** 클릭
4. 프로젝트 이름 입력 (예: "Study Digest Mailer")
5. **"만들기"** 클릭

### 2. Gmail API 활성화

1. 좌측 메뉴 → **"API 및 서비스"** → **"라이브러리"**
2. 검색창에 "Gmail API" 입력
3. Gmail API 선택 → **"사용"** 클릭

### 3. OAuth 동의 화면 설정

1. 좌측 메뉴 → **"API 및 서비스"** → **"OAuth 동의 화면"**
2. User Type: **"외부"** 선택 → **"만들기"**
3. 앱 정보 입력:
   - 앱 이름: "Study Digest"
   - 사용자 지원 이메일: 본인 이메일
   - 개발자 연락처: 본인 이메일
4. **"저장 후 계속"** 클릭
5. 범위(Scopes) 추가:
   - `https://www.googleapis.com/auth/gmail.send`
   - `https://www.googleapis.com/auth/gmail.compose`
6. 테스트 사용자 추가: 본인 Gmail 주소

### 4. OAuth 클라이언트 ID 생성

1. 좌측 메뉴 → **"API 및 서비스"** → **"사용자 인증 정보"**
2. **"+ 사용자 인증 정보 만들기"** → **"OAuth 클라이언트 ID"**
3. 애플리케이션 유형: **"데스크톱 앱"**
4. 이름 입력 (예: "Study Digest Desktop")
5. **"만들기"** 클릭
6. **"JSON 다운로드"** 클릭 → `client_secret.json` 저장

### 5. Gmail MCP 설정

```bash
# 설정 폴더 생성
mkdir -p ~/.gmail-mcp

# client_secret.json 복사
cp ~/Downloads/client_secret_*.json ~/.gmail-mcp/gcp-oauth.keys.json

# 인증 플로우 실행
npx @shinzolabs/gmail-mcp auth
```

브라우저가 열리면 Google 계정으로 로그인하고 권한을 허용하세요.

### 6. MCP 설정 파일에 추가

`~/.mcp.json`에 추가:

```json
{
  "mcpServers": {
    "gmail": {
      "command": "npx",
      "args": ["@shinzolabs/gmail-mcp"]
    }
  }
}
```

---

## 테스트 방법

Claude Code에서:
```
Gmail MCP가 설정됐는지 확인해줘
```

정상이면 Gmail 관련 도구가 사용 가능하다고 응답합니다.

---

## 주의사항

⚠️ **앱이 "테스트 모드"인 경우**:
- 테스트 사용자로 등록된 이메일만 사용 가능
- 7일마다 재인증 필요할 수 있음
- 프로덕션 배포 시 Google 검토 필요

---

## 참고 링크

- [Gmail MCP GitHub](https://github.com/shinzo-labs/gmail-mcp)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Gmail API 문서](https://developers.google.com/gmail/api)
