# Workshop Prep Skill

Claude Code 바이브코딩 워크샵 사전 준비 스킬. 참석자의 업무를 인터뷰하여 맞춤형 스킬 설계서를 생성합니다.

---

## ⚠️ 설치 전 필독

스킬 실행 시 Claude Code가 **권한 허용**을 여러 번 물어봅니다. 모두 허용해주세요!

| 순서 | 질문 | 선택 |
|------|------|------|
| 1번 | "Do you want to allow..." (스킬 사용 동의) | **Yes** |
| 2번 | "Allow for this session/project?" | **Yes, allow for this project** |

> **Tip**: 매번 묻는 게 귀찮다면 "Yes, allow for this project"를 선택하면 해당 프로젝트에서는 다시 묻지 않아요.

---

## 빠른 시작 (3단계)

### 1. 터미널 열고 설치하기

**macOS:**
1. `Cmd + Space` → "터미널" 검색 → Enter
2. 아래 명령어 복사해서 붙여넣기 → Enter

```bash
curl -fsSL https://raw.githubusercontent.com/daht-mad/workshop-prep-skill/main/install.sh | bash
```

**Windows:**
1. `Win + X` → **Windows PowerShell** 또는 **터미널** 클릭
2. 아래 명령어 복사해서 붙여넣기 → Enter

```powershell
irm https://raw.githubusercontent.com/daht-mad/workshop-prep-skill/main/install.ps1 | iex
```

> 설치가 완료되면 터미널을 닫아도 됩니다.

### 2. 프로젝트 폴더 만들고 VSCode로 열기

1. 바탕화면이나 원하는 위치에 **새 폴더** 만들기 (이름: `my-first-skill`)
2. VSCode 실행 → **File** → **Open Folder** → 방금 만든 폴더 선택

### 3. Claude Code 익스텐션 열고 스킬 시작

1. VSCode 왼쪽 사이드바에서 **Claude Code 아이콘** 클릭 (또는 `Cmd/Ctrl + Shift + P` → "Claude" 검색)
2. 채팅창에 다음 중 **아무거나** 입력:

```
워크샵 준비해줘
```

다른 표현도 가능해요:
- `스킬 설계 도와줘`
- `업무 자동화하고 싶어`
- `/workshop-prep`

> **Tip**: 슬래시 커맨드(`/workshop-prep`)가 안 보여도 걱정 마세요!  
> 자연어로 "워크샵 준비해줘"라고 말하면 동일하게 작동합니다.

---

## 목적

워크샵 참석자가 **자신만의 자동화 아이디어를 구체화**할 수 있도록 도와주는 인터뷰 챗봇입니다.

- 뭘 자동화해야 할지 모르는 참석자를 질문으로 이끌어냄
- 반복 업무를 파악하고 자동화 가능성을 탐색
- 외부 서비스 연동 필요성을 감지하고 셋업 가이드 제공
- 최종적으로 워크샵에서 사용할 **스킬 설계서** 출력

## 주요 기능

### 7단계 인터뷰 워크플로우

```
Phase 1: Warmup        → 역할/업무 파악
Phase 2: Find Tasks    → 반복 업무 탐색  
Phase 3: Map Process   → 시작→과정→결과물 맵핑
Phase 4: Possibilities → 자동화 사례 제시
Phase 4.5: Tech Detection → 외부 연동 필요성 감지 (NEW)
Phase 5: Crystallize   → 스킬 확정 및 범위 조절
Phase 6: Design Doc    → 맞춤형 설계서 생성 (NEW)
```

### 외부 서비스 자동 감지

41개 서비스를 11개 카테고리로 분류하여 자동 감지:
- 이메일 & 커뮤니케이션 (Gmail, Outlook, Slack, Teams 등)
- 파일 저장 & 문서 (Drive, Notion, Confluence 등)
- 일정 & 미팅 (Calendar, Zoom, Meet 등)
- 프로젝트 관리 (Linear, Jira, Asana, Trello 등)
- 데이터 & 스프레드시트 (Airtable, Sheets, Excel 등)
- 그 외 (GitHub, Figma, OpenAI 등)

### 동적 셋업 가이드 생성

감지된 서비스에 맞는 MCP 설정 가이드를 **Context7로 실시간 조사**하여 생성합니다.
- 미리 정해진 가이드가 아닌 최신 공식 문서 기반
- 비개발자도 따라할 수 있는 친절한 설명

## 설치 (원클릭)

터미널에서 한 줄만 실행하면 끝!

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/daht-mad/workshop-prep-skill/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/daht-mad/workshop-prep-skill/main/install.ps1 | iex
```

### 설치되는 것

| 항목 | 설명 |
|------|------|
| **workshop-prep 스킬** | `~/.claude/skills/workshop-prep/`에 설치 |
| **Context7 MCP** | `~/.mcp.json`에 자동 추가 (API 키 입력 프롬프트) |
| **심링크 설정** | Claude Code 호환성 자동 확인 |

### Context7 API 키

설치 중 API 키를 물어봅니다. 무료로 발급받을 수 있어요:

1. [context7.com/dashboard](https://context7.com/dashboard) 접속
2. 가입 (GitHub/Google 로그인)
3. API Key 복사
4. 설치 스크립트에 붙여넣기

> 나중에 설정하려면 Enter로 스킵 → `~/.mcp.json`에서 수동 설정

### 업데이트

이미 설치되어 있는 경우, 설치 스크립트를 다시 실행하면 **업데이트 여부를 물어봅니다**.

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/daht-mad/workshop-prep-skill/main/install.sh | bash
```

**Windows:**
```powershell
irm https://raw.githubusercontent.com/daht-mad/workshop-prep-skill/main/install.ps1 | iex
```

**프롬프트 예시:**
```
⚠ 기존 설치가 발견되었습니다

기존 파일을 최신 버전으로 업데이트하시겠습니까?
주의: 스킬 파일을 직접 수정했다면 변경사항이 사라집니다

계속하시겠습니까? (y/N):
```

- **y 입력**: 최신 버전으로 업데이트
- **N 또는 Enter**: 업데이트 취소

> **주의**: 스킬 파일을 직접 수정했다면 백업 후 업데이트하세요.

## 사용법

### 스킬 호출

**자연어로 말하기 (추천):**
```
워크샵 준비해줘
스킬 설계 도와줘
업무 자동화하고 싶어
반복 업무 줄이고 싶어
```

**슬래시 커맨드:**
```
/workshop-prep
```

> 슬래시 커맨드가 목록에 안 뜨는 경우가 있어요.  
> 그냥 자연어로 말해도 똑같이 작동하니 편하게 사용하세요!

### 예시 대화

**사용자**: 워크샵 준비해줘

**스킬**: 
> 안녕하세요! 워크샵에서 만들 스킬을 함께 설계해볼게요 😊
> 
> 먼저 간단한 질문 하나! **지금 회사에서 어떤 일을 맡고 계세요?**

**사용자**: PM이에요. 주로 회의하고 문서 정리하는 일 해요.

**스킬**:
> 아 PM이시구나! 회의도 많고 문서 정리도 많을 것 같아요.
> 
> 혹시 이런 것들 중에 "아 이거 맨날 해..." 싶은 거 있으세요?
> - 매주 같은 양식으로 보고서 쓰기
> - 회의록 정리해서 공유하기
> - 여러 소스에서 숫자 모아서 정리하기
> 
> 이 중에 해당되는 거 있어요? 없으면 다른 거 말씀해주셔도 돼요!

### 최종 결과물

인터뷰가 끝나면 다음 폴더 구조로 산출물이 생성됩니다:

```
프로젝트루트/
└── {스킬명}/                      # 예: weekly-report/
    ├── {스킬명}-설계서.md          # 설계서 (flow.mermaid 포함)
    ├── 사전설문응답.md             # 인터뷰 Q&A 기록
    └── 연동가이드/                  # 외부 연동 시에만 생성
        ├── slack.md
        ├── google-drive.md
        └── ...
```

**산출물 내용**:
- **설계서**: MVP 목표, 입출력 명세, 범위, 실패 처리, 테스트 체크리스트
- **flow.mermaid**: 워크플로 시각화 (설계서 내부 포함)
- **사전설문응답.md**: 인터뷰 질문/답변 기록 (Q1, A1, Q2, A2... 형식)
- **연동가이드/**: 서비스별 연동 설정 가이드 (Context7 조사 기반)

> **Note**: 사전 설문에서는 문서만 생성됩니다. 실제 API 설정은 워크샵 당일 진행합니다.

## 파일 구조

```
workshop-prep/
├── install.sh               # 원클릭 설치 (macOS/Linux)
├── install.ps1              # 원클릭 설치 (Windows)
├── SKILL.md                 # 메인 스킬 정의
├── README.md                # 이 파일
└── references/
    ├── examples.md          # 직무별 반복 업무 예시
    ├── integrations.md      # 외부 서비스 감지 키워드 (41개)
    └── template.md          # 설계서 템플릿 (Core + Optional)
```

## 설계서 템플릿 구조

```
Core (필수) - 8개 섹션
├── 0. 선언 (이름, 설명, 유형, MVP 목표)
├── 1. 언제 쓰나요
├── 2. 사용법
├── 3. 입력/출력 명세
├── 4. 범위 (하는것/안하는것)
├── 5. 데이터/도구/권한
├── 6. 실패/예외 처리
├── 7. 대화 시나리오 (정상+실패)
└── 8. 테스트 & Done 기준

Optional (선택) - 스킬 유형별
├── A. 파일 기반
├── B. 외부 API 연동
└── C. 다단계 워크플로우
```

## 대상

- **PM**: 회의록 자동화, 주간보고 생성, 이슈 정리
- **마케터**: 캠페인 리포트, 콘텐츠 캘린더, 경쟁사 모니터링
- **디자이너**: 핸드오프 문서, 피드백 정리, 디자인 시스템 문서화
- **기타 비개발자**: 반복적인 문서/데이터/커뮤니케이션 업무

## 라이선스

MIT

## 기여

이슈와 PR 환영합니다!
