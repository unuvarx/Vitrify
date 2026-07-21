# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository structure

This repo contains two independent projects that together make up Vitrify, an AI product-photography app:

- `Vitrify.API/` — ASP.NET Core 8 backend (`Vitrify.API/Vitrify.API/` is the actual project; the outer folder just holds the `.sln`)
- `vitrify_app/` — Flutter mobile client (iOS/Android)

They communicate over plain HTTP + SignalR — there is no shared code or contract between them beyond matching JSON shapes by convention (see DTOs vs. Dart service calls).

**Never read or write inside `bin/`, `obj/`, `build/`, or `.dart_tool/`** — these are build output and can be large/stale.

## Backend (Vitrify.API)

### Commands
- Run: `cd Vitrify.API/Vitrify.API && dotnet run` (listens on `http://localhost:5118`, Swagger UI at `/swagger`, Hangfire dashboard at `/hangfire`)
- Build: `dotnet build` from `Vitrify.API/Vitrify.API/`
- EF Core migrations: `dotnet ef migrations add <Name>` / `dotnet ef database update` (run from `Vitrify.API/Vitrify.API/`; `AppDbContextFactory` supplies design-time config via user secrets + `appsettings.json`)
- Config: `appsettings.json`/`appsettings.Development.json` are gitignored — connection strings, `Gemini:ApiKey`, `Replicate:ApiToken` are set via user secrets (`UserSecretsId` is in the `.csproj`) or the local appsettings files. `firebase-key.json` (service account) is also gitignored and required at startup — `Program.cs` loads it directly.

### Architecture
- **Auth**: Firebase ID tokens validated as JWT bearer tokens against `https://securetoken.google.com/vitrify-c68b0`. `BaseApiController.GetFirebaseUid()` extracts the uid from claims; controllers look up the local `User` row by `FirebaseUid`. There's no local password auth — Firebase is the identity provider, Postgres just mirrors app-specific state (credits, device id, FCM token).
- **Device-locked free credits**: `AuthController.Login` grants 5 free credits only if `DeviceId` (from `device_info_plus` on the Flutter side) hasn't been seen before, to stop users from farming free credits via new Firebase accounts on the same device.
- **Job pipeline** (the core feature — turning uploaded product photos into styled scene images):
  1. `JobsController.Create` fans a batch out into `images × scenarios` `JobItem` rows under one `Job`, checks/holds nothing upfront beyond a credit *count* check (credits are deducted per-item only on success).
  2. Each `JobItem` is enqueued individually as a Hangfire background job (`BackgroundJob.Enqueue<JobProcessingService>`), backed by Postgres storage (`Hangfire.PostgreSql`), with a worker count of 3 and an in-process `SemaphoreSlim(5)` in `JobProcessingService` limiting concurrent Gemini calls.
  3. `JobProcessingService.ProcessJobItemAsync` calls `GeminiService` (Gemini 2.5 Flash Image / "nano-banana") with the source image as inline base64 — images are never uploaded to external storage, they flow as base64 the whole way (compressed to max 1024px/JPEG quality 85 first, both client- and server-side).
  4. On completion of each item, progress is pushed live over SignalR (`JobHub`, group-per-jobId, events `ImageReady`/`ImageFailed`) so the Flutter client updates without polling. `JobsController.GetStatus` exists as a fallback/reconciliation path.
  5. When the last item in a job finishes, an FCM push notification is sent via `NotificationService` (only if `jobUser.FcmToken` is set) so users get notified even if the app is backgrounded.
  - Note: `ReplicateService` (Replicate/nano-banana via URL-based image_input, with 429 retry/backoff handling) exists alongside `GeminiService` but the active job pipeline in `JobsController`/`JobProcessingService` currently goes through Gemini directly with base64 images.
- **Payments**: `CreditsController.AddCredits` is *not yet verifying purchases server-side* — it trusts the Flutter/RevenueCat client and only de-dupes via `Purchase.StoreTransactionId` uniqueness. This is called out in-code as pre-production/to-be-replaced by a RevenueCat webhook.
- **Controllers with `test-` prefixed or `TestController`-style endpoints** (e.g. `JobsController.TestCreateFiles`/`TestStatus`) are unauthenticated scaffolding for development and are marked in comments as to-be-removed before production — don't extend the auth model to make them "safe to keep," flag them for removal instead if touching that area.
- Many in-code comments and user-facing messages are in Turkish — match that convention when editing existing strings/comments in the API project rather than switching to English.

## Flutter app (vitrify_app)

### Commands
- Run: `cd vitrify_app && flutter run`
- Analyze: `flutter analyze` (uses `flutter_lints`, config in `analysis_options.yaml` — no custom rule overrides currently)
- Test: `flutter test` (single test file: `flutter test test/widget_test.dart`)
- Get deps: `flutter pub get`

### Architecture
- **State/storage**: `provider` for state management; `hive`/`hive_flutter` for local persistence (currently just theme/scenario settings via `StorageService` + `ThemeSettings`, initialized in `main()` before `runApp`).
- **Backend connectivity**: `AppConfig.apiBaseUrl` switches between `10.0.2.2:5118` (Android emulator → host loopback) and `localhost:5118` (iOS simulator) — this is the one thing to change if the API port/host changes. `ApiService` (Dio) and `SignalRService` (`signalr_netcore`) both point at this base URL.
- **Auth flow**: `AuthService` wraps `firebase_auth` for sign-up/sign-in and also derives a stable per-device id (`device_info_plus`: `identifierForVendor` on iOS, Android ID on Android) used for the backend's device-lock check, plus reports platform ("ios"/"android") — both are sent to `POST /api/auth/login` alongside the Firebase ID token.
- **Image upload path**: images are compressed client-side (`flutter_image_compress`, max 1024px, quality 85) and sent as base64 data URIs directly in the `POST /api/jobs/create` body — no multipart upload or external file storage involved.
- **Real-time updates**: `SignalRService` connects to `/jobhub` and joins a job-specific group (`SubscribeToJob`) to receive `ImageReady`/`ImageFailed` events pushed by the backend as each image finishes, matching the backend's per-item completion model — don't reintroduce polling as the primary update mechanism, `getJobStatus` is a fallback only.
- Screens live flat under `lib/screens/` (`login_screen`, `main_screen`, `create_screen`, `gallery_screen`, `theme_screen`, `profile_screen`) with no nested feature folders yet.
