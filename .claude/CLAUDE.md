# Ask Again Later – Studio privacy policy (public repository)

This repository is PUBLIC. It publishes one page with GitHub Pages: `index.html`, the privacy policy for the channel
owner's personal tool: Google Drive backups (Google OAuth scope `drive.file`) and private YouTube uploads plus the
channel's own analytics (scopes `youtube.upload` and `youtube.readonly`). Everything committed here, including the
Git history, is visible to anyone.

## What may be published
- Only what is needed to explain the app's Google Drive and YouTube access, data handling, storage, sharing and the user's rights
  (revoking access, deleting data), plus the approved public contact address askagainlater.studio@gmail.com.
- Approved files only (the allowlist lives in `.github/scripts/policy-check.sh`): the page, these instructions, the
  Gitleaks configuration, the security workflow and its policy script. A new file needs the owner's approval and an
  allowlist change in the same pull request.

## Never publish
- API keys, OAuth client IDs or secrets, access or refresh tokens, passwords or any credential, real or partial.
- Environment variable values, `.env` files or secret configuration.
- Content from the private production repository: source code, manifests, logs, production records, scripts,
  artwork, unpublished material or video files.
- Internal filesystem paths, infrastructure details, account or project IDs, private Google Drive file or folder IDs.
- Personal information beyond the approved public contact address.
- Scripts, trackers, analytics, embeds or external stylesheets or fonts on the page.

## How changes are made
1. Always on a branch with a pull request into `main`; never push to `main` directly, never force-push, never rewrite
   history, never change the repository's visibility or permissions.
2. The policy must describe the backup tool's actual, current behaviour. Whenever the tool changes its permissions,
   authentication, data handling, sharing, storage locations or backup behaviour, compare the page with the tool's
   code and propose an update. Describe behaviour, not implementation details.
3. The `Security scan` workflow must pass (secret scan of the current files and the full history with the built-in and
   the extra Google credential rules, a self-test with synthetic credentials, the file allowlist and the content
   policy). Never weaken it to make a change pass; never add an allowlist that could hide a real credential. A proven
   false positive is handled narrowly (a single finding fingerprint) after manual review.
4. A person reviews every pull request before merging. Automated scanning supplements manual review; it does not
   replace it. Changes to the workflow, the policy script or the Gitleaks configuration need especially careful review.
5. Tests use synthetic, randomly generated fake credentials only, never real ones. Never print secret values in logs,
   reports, pull requests or chat; the workflow redacts all findings.
6. Keep the existing design: one self-contained, mobile-friendly HTML file with inline styles.

## Known history note
The first commit of this repository contains an internal file location (not a credential). It was removed from the
page in a later commit; the owner decided to keep the history as it is (no rewrite). The secret scanners do not flag it.
