# Ape Archive Mobile - API Mapping Document

**Version:** 1.0  
**Date:** December 7, 2025  
**Backend:** https://github.com/APE-ARCHIVE/ape-archive-backend  
**Web Frontend:** https://github.com/APE-ARCHIVE/ape-archive-web  
**Base URL:** `https://server-apearchive.freeddns.org`

---

## Authentication & User Management

### Google OAuth Flow (BFF Pattern)

| Endpoint | Method | Description | Mobile Implementation | Request | Response | Notes |
|----------|--------|-------------|----------------------|---------|----------|-------|
| `/api/v1/auth/google` | GET | Redirect to Google OAuth consent screen | Use `url_launcher` to open in system browser | N/A | 302 redirect to Google | Backend handles OAuth flow |
| `/api/v1/auth/google/callback` | GET | Google callback (internal) | Backend redirects to `apearchive://auth#accessToken=...&userId=...&isOnboarded=...` | Query: `code`, `error`, `state` | 302 redirect with token in fragment | Implement deep link handler |
| `/api/v1/auth/me` | GET | Get current user profile | Used for token validation & user data sync | Headers: `Authorization: Bearer <token>` | `{ success, data: User, message }` | Call on app startup if token exists |
| `/api/v1/auth/onboard` | POST | Complete user onboarding | Show onboarding form for new users | Body: `{ role, school?, batch?, bio?, qualifications?, whatsappNumber?, telegramUser?, interests?, subjects? }` | `{ success, data: User, message }` | Required for GUEST users |

**User Model:**
```dart
class User {
  String id;
  String email;
  String name;
  String? imageUrl;
  UserRole role; // GUEST, STUDENT, TEACHER, ADMIN
  bool isOnboarded;
  DateTime createdAt;
  StudentProfile? studentProfile;
  TeacherProfile? teacherProfile;
}
```

**Mobile Auth Flow:**
1. User taps "Sign in with Google"
2. Launch `/api/v1/auth/google` in system browser
3. Backend redirects to `apearchive://auth#accessToken=...&userId=...&isOnboarded=...`
4. App captures deep link, extracts token, stores in `flutter_secure_storage`
5. If `isOnboarded=false`, show onboarding screen
6. Call `/auth/me` to fetch full user profile

---

## Library & Resources

### Hierarchical Library (Tag-based)

| Endpoint | Method | Description | Mobile Implementation | Request | Response | Notes |
|----------|--------|-------------|----------------------|---------|----------|-------|
| `/api/v1/library` | GET | Get full library hierarchy | Initial load for offline cache | N/A | `{ success, data: Hierarchy, message }` | Cache response for offline browsing |
| `/api/v1/library/hierarchy` | GET | Same as above | Alternative endpoint | N/A | Same as above | Prefer this for clarity |
| `/api/v1/library/browse` | GET | Browse with filters (AND logic) | Library browsing with tag filters | Query: `stream?, subject?, grade?, medium?, resourceType?, page?, limit?` | `{ success, data: { hierarchy, documents, meta }, message }` | Supports pagination |

**Hierarchy Structure:**
```dart
// Nested map representing Grade → Subject → Lesson → Medium → [Documents]
Map<String, dynamic> hierarchy = {
  "Grade 12": {
    "Economics": {
      "Macroeconomics": {
        "English Medium": [Document, Document, ...],
        "Sinhala Medium": [...]
      }
    }
  }
}
```

### Resource Operations

| Endpoint | Method | Description | Mobile Implementation | Request | Response | Notes |
|----------|--------|-------------|----------------------|---------|----------|-------|
| `/api/v1/resources` | GET | Get resources with filters | Search & filter resources | Query: `page?, limit?, search?, tagId?, status?` | `{ success, data: { resources, meta }, message }` | Paginated |
| `/api/v1/resources/:id` | GET | Get single resource details | Resource detail screen | Path: `id` | `{ success, data: Resource, message }` | Increments view count |
| `/api/v1/resources/:id/stream` | GET | Stream PDF from Google Drive | PDF viewer with chunked loading | Path: `id`, Headers: `Range: bytes=0-999` (optional) | Binary stream (application/pdf) | Supports partial content (206) |
| `/api/v1/resources/upload` | POST | Upload resource (STUDENT/TEACHER) | Upload form (pending approval) | Body: `multipart/form-data` - `file, grade, subject, lesson, medium, title?, description?` | `{ success, data: Resource, message }` | Creates resource with `PENDING` status |
| `/api/v1/resources/admin/upload` | POST | Upload resource (ADMIN) | Admin upload (auto-approved) | Body: `multipart/form-data` - `file, tagIds[], title?, description?` | `{ success, data: Resource, message }` | Creates resource with `APPROVED` status |

**Resource Model:**
```dart
class Resource {
  String id;
  String title;
  String? description;
  String driveFileId;
  String mimeType;
  int views;
  int downloads;
  ResourceStatus status; // PENDING, APPROVED, REJECTED
  List<Tag> tags;
  String uploaderId;
  DateTime createdAt;
}
```

### Tags

| Endpoint | Method | Description | Mobile Implementation | Request | Response | Notes |
|----------|--------|-------------|----------------------|---------|----------|-------|
| `/api/v1/tags` | GET | Get all tags grouped by type | Used for filters & upload form | N/A | `{ success, data: GroupedTags, message }` | Cache for offline use |

**Tag Groups:**
- Stream (e.g., "A/L Subjects", "O/L Subjects")
- Grade (e.g., "Grade 12", "Grade 13")
- Subject (e.g., "Economics", "Biology")
- Lesson (e.g., "Macroeconomics", "Microeconomics")
- Medium (e.g., "English Medium", "Sinhala Medium", "Tamil Medium")
- ResourceType (e.g., "Past Paper", "Notes", "Syllabus", "Unit", "Teacher Guide")

---

## Forum & Q&A

| Endpoint | Method | Description | Mobile Implementation | Request | Response | Notes |
|----------|--------|-------------|----------------------|---------|----------|-------|
| `/api/v1/forum` | GET | Get questions with filters | Forum list screen | Query: `page?, limit?, search?, category?, solved?` | `{ success, data: { questions, meta }, message }` | Paginated |
| `/api/v1/forum/:id` | GET | Get question with answers | Question detail screen | Path: `id` | `{ success, data: Question, message }` | Includes sorted answers |
| `/api/v1/forum` | POST | Create new question | Create question screen | Body: `{ title, body, categoryId }` | `{ success, data: Question, message }` | Requires auth |
| `/api/v1/forum/:id/answers` | POST | Post answer to question | Answer input | Path: `id`, Body: `{ body }` | `{ success, data: Answer, message }` | Requires auth |
| `/api/v1/forum/answers/:id/vote` | POST | Upvote/downvote answer | Vote buttons | Path: `id`, Body: `{ vote: 1 or -1 }` | `{ success, data: Vote, message }` | Toggle vote |
| `/api/v1/forum/answers/:id/accept` | POST | Mark answer as accepted | Accept button (OP only) | Path: `id` | `{ success, message }` | Only question owner can accept |

**Answer Sorting Logic (Backend):**
1. Accepted answer first
2. Then by role priority: ADMIN > TEACHER > STUDENT > GUEST
3. Then by vote count (descending)
4. Then by creation date (newest first)

---

## Teacher Discovery

| Endpoint | Method | Description | Mobile Implementation | Request | Response | Notes |
|----------|--------|-------------|----------------------|---------|----------|-------|
| `/api/v1/teachers` | GET | Get all teachers | Teacher list screen | Query: `page?, limit?, subject?` | `{ success, data: { teachers, meta }, message }` | Paginated |
| `/api/v1/teachers/:id` | GET | Get teacher profile | Teacher detail screen | Path: `id` | `{ success, data: TeacherProfile, message }` | Full profile with subjects |
| `/api/v1/teachers/subject/:slug` | GET | Get teachers by subject | Subject filter | Path: `slug`, Query: `page?, limit?` | `{ success, data: { teachers, meta }, message }` | Filtered by subject |

**TeacherProfile Model:**
```dart
class TeacherProfile {
  String id;
  String userId;
  String bio;
  String? qualifications;
  String? whatsappNumber;
  String? telegramUser;
  bool isAvailable;
  List<Subject> subjects;
  User user; // Name, email, imageUrl
}
```

---

## Announcements

| Endpoint | Method | Description | Mobile Implementation | Request | Response | Notes |
|----------|--------|-------------|----------------------|---------|----------|-------|
| `/api/v1/announcements` | GET | Get all announcements | Home screen banners & news feed | N/A | `{ success, data: Announcement[], message }` | Sorted by priority & date |

**Announcement Model:**
```dart
class Announcement {
  String id;
  String title;
  String content;
  Priority priority; // HIGH, MEDIUM, LOW
  DateTime createdAt;
  DateTime? expiresAt;
}
```

---

## Design Tokens (from Web Frontend)

### Colors (HSL)
```dart
// Light Theme
const primaryColor = Color.fromRGBO(255, 87, 51, 1); // hsl(3.2, 100%, 59.4%)
const backgroundColor = Color.fromRGBO(255, 255, 255, 1); // hsl(0, 0%, 100%)
const foregroundColor = Color.fromRGBO(26, 22, 20, 1); // hsl(20, 14%, 10%)
const cardColor = Color.fromRGBO(255, 255, 255, 1);
const secondaryColor = Color.fromRGBO(246, 241, 238, 1); // hsl(30, 20%, 96%)
const mutedColor = Color.fromRGBO(237, 230, 224, 1); // hsl(30, 15%, 92%)
const accentColor = Color.fromRGBO(255, 87, 51, 1); // Same as primary
const destructiveColor = Color.fromRGBO(239, 68, 68, 1); // hsl(0, 84.2%, 60.2%)
const borderColor = Color.fromRGBO(230, 216, 206, 1); // hsl(30, 25%, 85%)

// Dark Theme
const darkBackgroundColor = Color.fromRGBO(13, 11, 10, 1); // hsl(20, 14%, 4%)
const darkForegroundColor = Color.fromRGBO(250, 245, 240, 1); // hsl(30, 50%, 96%)
// ... (other dark theme colors)
```

### Typography
```dart
const fontFamily = 'Source Sans Pro';
// Headline: Source Sans Pro, bold
// Body: Source Sans Pro, regular
```

### Spacing (Tailwind scale)
```dart
const spacing = {
  'xs': 4.0,
  'sm': 8.0,
  'md': 16.0,
  'lg': 24.0,
  'xl': 32.0,
  '2xl': 48.0,
};
```

### Border Radius
```dart
const borderRadius = {
  'sm': 8.0,
  'md': 12.0,
  'lg': 16.0,
  'full': 9999.0,
};
```

---

## API Gaps & Proposed Additions

### Missing Endpoints (from mobile requirements)

1. **Real-time Notifications**
   - **Proposed:** WebSocket endpoint or FCM integration for push notifications
   - **Contract:** `wss://server/api/v1/notifications` or Firebase Cloud Messaging
   - **Reason:** Mobile apps need instant notification delivery for forum replies, upload approvals, etc.

2. **Offline Sync Status**
   - **Proposed:** `GET /api/v1/sync/status?lastSyncTimestamp=...`
   - **Response:** `{ newResources, updatedResources, deletedResources }`
   - **Reason:** Enable efficient offline sync without downloading full hierarchy

3. **User Avatar Upload**
   - **Proposed:** `POST /api/v1/auth/avatar` (multipart/form-data)
   - **Response:** `{ success, data: { imageUrl }, message }`
   - **Reason:** Users currently get avatar from Google OAuth only

4. **Batch Resource Metadata**
   - **Proposed:** `POST /api/v1/resources/batch` (Body: `{ ids: string[] }`)
   - **Response:** `{ success, data: Resource[], message }`
   - **Reason:** Efficient metadata fetch for offline cache validation

5. **Analytics Tracking**
   - **Proposed:** `POST /api/v1/analytics/track` (Body: `{ event, properties }`)
   - **Response:** `{ success }`
   - **Reason:** Track user behavior for admin dashboard (opt-in)

---

## Mobile-Specific Implementation Notes

### PDF Streaming Strategy
1. Use `/resources/:id/stream` with `Range` header for chunked loading
2. Cache chunks in `path_provider` temporary directory
3. Implement progressive loading UI (show pages as they load)
4. Use `syncfusion_flutter_pdfviewer` or `pdfx` for rendering

### Offline Caching
1. **Metadata Cache (Hive/Sqflite):**
   - Store full hierarchy, tags, user profile
   - Update on app launch if network available
2. **File Cache:**
   - Store recently viewed PDFs in local storage
   - Implement LRU eviction with max size limit (e.g., 500MB)
   - Display offline badge on cached resources

### Authentication Token Storage
- Use `flutter_secure_storage` for access token
- Store in encrypted keychain (iOS) / keystore (Android)
- No refresh token (re-authenticate when expired)

### Deep Link Handling
- Register custom URL scheme: `apearchive://`
- Handle auth callback: `apearchive://auth#accessToken=...`
- Handle resource sharing: `apearchive://resources/:id`

### Network Error Handling
- Implement exponential backoff for retries (3 attempts)
- Show offline indicator when network unavailable
- Queue mutations (uploads, posts) for retry when online

---

## Testing Checklist

- [ ] Auth flow: Login → Onboard → Profile fetch
- [ ] Library browsing: Offline cache → Network fetch → Pagination
- [ ] PDF streaming: Partial content → Full download → Offline view
- [ ] Upload: Form validation → File selection → Upload progress → Pending state
- [ ] Forum: Create question → Post answer → Vote → Accept answer
- [ ] Teacher discovery: List → Filter by subject → Profile view
- [ ] Announcements: Priority sorting → Banner display → News feed

---

## References

- Backend Repo: https://github.com/APE-ARCHIVE/ape-archive-backend
- Web Frontend: https://github.com/APE-ARCHIVE/ape-archive-web
- Backend Auth Docs: `docs/AUTH_FLOW.md`
- Frontend Integration: `docs/FRONTEND_INTEGRATION_GUIDE.md`
- Swagger UI: `http://localhost:3000/swagger` (local dev)
