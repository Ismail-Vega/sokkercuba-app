# App Review Information

Paste the **Review Notes** section below into App Store Connect →
your app → the version → *App Review Information* → *Notes*.
Fill in every `«placeholder»` first.

---

## Sign-in required (App Store Connect fields)

- **Sign-in required:** Yes
- **User name:** «Sokker demo account username»
- **Password:** «Sokker demo account password»

> Create a dedicated Sokker account for this, ideally one with a team and some
> squad/training history so the reviewer sees populated screens rather than
> empty states. Do not use your own account.

---

## Review Notes

Sokker Pro is an unofficial companion app for sokker.org, a long-running
online football manager game. It signs in to an existing Sokker account and
presents that account's squad, juniors, training, transfers and news in a
native iOS interface. The app does not create accounts — a Sokker account
must already exist, and is created and deleted on sokker.org.

HOW TO SIGN IN

1. Launch the app. You will see a username and password form.
2. Enter the demo credentials supplied in the App Review Information fields.
3. Tap "Log In". The app loads the account's data and opens the home screen.

IMPORTANT — CLOUDFLARE HUMAN VERIFICATION

sokker.org sits behind Cloudflare, which intermittently presents a human
verification challenge to non-browser clients. If that happens during sign-in,
the app is working as designed and will do the following automatically:

1. A screen titled "Sokker sign-in" opens with an embedded web view showing
   sokker.org.
2. Complete Cloudflare's verification in that view (usually a single checkbox).
3. If sokker.org then shows its own login page, sign in there with the same
   demo credentials.
4. The app detects the authenticated session on its own; the status bar at the
   top changes to "Signed in as «name»".
5. Tap "Continue to app". The app loads the account data and opens the home
   screen.

The "Continue to app" button stays disabled until the session is confirmed
working, so it is expected to be greyed out until step 4 completes. If the
status does not update within a few seconds, tap "Check again".

This flow exists solely because Cloudflare blocks the app's normal network
requests. The app never asks for credentials outside of its own sign-in form
or sokker.org's own page.

PRIVACY

The app has no backend. No analytics, advertising, tracking or crash-reporting
software is included. The password is sent over HTTPS to sokker.org only, is
never stored by the app and is never written to logs. Game data is cached
locally on the device and removed when the app is deleted. Privacy policy:
«your privacy policy URL»

ACCOUNT DELETION (Guideline 5.1.1(v))

The app does not support account creation, so in-app account deletion does not
apply. Sokker accounts are created and deleted entirely on sokker.org, which
this app only reads from.

AUTHORISATION (Guideline 5.2.1)

«Attach or reference written permission from the operators of sokker.org here.
For example: "Written permission to publish a third-party client using the
Sokker API and name was granted by «name/role» on «date»; a copy is attached."
If you do not yet have this, obtain it before submitting — see notes below.»

NAVIGATION

Open the drawer with the menu button at the top left to reach Squad, Training,
Juniors, Scouting and Xtreme. "Update your data" in the drawer refreshes from
sokker.org. "Logout" clears the session.
