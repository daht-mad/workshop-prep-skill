# Airtable 연동 가이드

## 개요

| 항목 | 내용 |
|------|------|
| **용도** | 설문 응답 데이터 읽기 |
| **복잡도** | 쉬움 (API 키만 필요) |
| **예상 시간** | 10-15분 |
| **사전 준비** | 당일 설정 가능 |

---

## 설정 단계

### 1. Personal Access Token 발급

1. [Airtable 계정](https://airtable.com/account)에 로그인
2. 좌측 메뉴에서 **"Developer hub"** 클릭
3. **"Personal access tokens"** 섹션으로 이동
4. **"Create new token"** 클릭

### 2. 토큰 권한 설정

**Scopes (권한)** 설정:
- `data.records:read` - 레코드 읽기 (필수)
- `schema.bases:read` - 베이스 스키마 읽기 (권장)

**Access (접근 범위)** 설정:
- 설문 데이터가 있는 베이스 선택
- 또는 "All current and future bases" 선택 (편의상)

### 3. 토큰 복사 및 저장

⚠️ **중요**: 토큰은 한 번만 표시됩니다. 안전한 곳에 저장하세요!

```
pat.xxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 4. 환경변수 설정

```bash
export AIRTABLE_API_KEY="pat.xxxxx..."
```

또는 `.env` 파일에 추가:
```
AIRTABLE_API_KEY=pat.xxxxx...
```

---

## 필요한 정보

워크샵에서 스킬을 만들 때 다음 정보가 필요합니다:

| 항목 | 설명 | 예시 |
|------|------|------|
| **Base ID** | 베이스 고유 ID | `appXXXXXXXXXXXXXX` |
| **Table Name** | 설문 응답 테이블 이름 | `설문응답` 또는 `Survey Responses` |
| **View Name** | 사용할 뷰 (선택) | `오늘 응답` |

### Base ID 찾는 방법

1. 해당 베이스 열기
2. URL 확인: `https://airtable.com/appXXXXXXXXXXXXXX/...`
3. `app`으로 시작하는 부분이 Base ID

---

## 테스트 방법

터미널에서 다음 명령어로 연결 테스트:

```bash
curl "https://api.airtable.com/v0/{BASE_ID}/{TABLE_NAME}" \
  -H "Authorization: Bearer $AIRTABLE_API_KEY"
```

정상이면 JSON 응답이 반환됩니다.

---

## 참고 링크

- [Airtable API 공식 문서](https://airtable.com/developers/web/api/introduction)
- [Personal Access Token 가이드](https://airtable.com/developers/web/guides/personal-access-tokens)
