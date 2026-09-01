# Savannah RP — Discord Setup

A complete, no-guessing setup for a standard FiveM roleplay Discord:
verification gate, clean role hierarchy, private staff area, a ticket system,
and automatic customer roles from Tebex.

Do the steps **in order**. Permissions break when you do channels before roles.

---

## 0. Before you touch anything

- Server Settings → **Safety Setup** → set the verification level to **Medium**
  (must be registered on Discord >5 min) and enable **DM spam / raid protection**.
- Server Settings → **AutoMod** → turn on the built-in **spam**, **mention spam**,
  and **suspicious link** filters. Add a word filter later if you need one.
- Community Server: **enable it** (Server Settings → Enable Community). You get a
  Rules screen, a "Welcome" system channel, and better raid tools.

---

## 1. Roles — create these top-to-bottom

Server Settings → **Roles** → New Role. Order matters (top = most power).

| # | Role | Colour | Purpose |
|---|------|--------|---------|
| 1 | **Owner** | gold | You. Administrator. |
| 2 | **Admin** | red | Senior staff. Management + moderation, **no Administrator**. |
| 3 | **Moderator** | orange | Day-to-day moderation. |
| 4 | **Support** | teal | Handles tickets only. No moderation powers. |
| 5 | **LSPD** | blue | Police department members. Identity role. |
| 6 | **EMS** | green | EMS / Fire members. Identity role. |
| 7 | **Mechanic** | grey | Mechanic job. Identity role. |
| 8 | **Business Owner** | purple | Approved player businesses. Identity role. |
| 9 | **Customer** | soft gold | Auto-assigned by Tebex after any purchase. |
| 10 | **Supporter** | bright gold | Auto-assigned by Tebex for a supporter package (optional, can reuse Customer). |
| 11 | **Verified** | none / default | The gate. Everyone gets this after verifying. |

`@everyone` stays at the bottom.

> **Keep buying something ≠ powers.** Customer / Supporter are cosmetic identity
> roles only. They never get moderation, PD access, or channel-management perms.

### Permissions per role

Toggle these ON. Everything else OFF.

**Owner** — `Administrator`. (Nothing else needed.)

**Admin**
- Manage Server, Manage Roles, Manage Channels, Manage Webhooks
- Manage Messages, Manage Nicknames, Manage Events
- Kick Members, Ban Members, Timeout Members (Moderate Members)
- View Audit Log
- Mention @everyone
- (Leave `Administrator` **OFF** — this is deliberate.)

**Moderator**
- Manage Messages, Manage Nicknames
- Kick Members, Timeout Members (Moderate Members)
- View Audit Log
- Move Members, Mute Members, Deafen Members (voice mod)
- (No Ban, no Manage Roles/Channels/Server.)

**Support**
- Read Message History, Send Messages, Embed Links, Attach Files
- Manage Messages (to clean ticket channels)
- Move Members (pull people into a voice room if needed)
- **No** Kick/Ban/Timeout, **no** Manage Roles/Channels.

**LSPD / EMS / Mechanic / Business Owner** — **no server permissions at all.**
They only exist so channel overrides can show department channels to the right
people. Do not give them Manage anything.

**Customer / Supporter** — **no server permissions.** Cosmetic + used for the
supporter/customer channel overrides only.

**Verified** — base member permissions:
- View Channels, Send Messages, Send Messages in Threads, Create Public Threads
- Embed Links, Attach Files, Add Reactions, Use External Emoji
- Read Message History, Connect, Speak, Use Voice Activity
- (This is what "a normal member can do".)

**@everyone** — turn almost everything OFF:
- View Channels: **OFF** (they'll only see the welcome channels via override)
- Send Messages: OFF
- Add Reactions: OFF
- Connect / Speak: OFF
- Keep: Change Nickname (optional), nothing else.

---

## 2. Verification gate

Goal: a brand-new join sees **only** `#welcome` and `#verify`. They click a
button / pass a check, get **Verified**, and the rest of the server appears.

**Pick one bot** (all free tiers work):

| Bot | Style | Notes |
|-----|-------|-------|
| **Wick** | Button + optional captcha, plus strong anti-raid/anti-nuke | Best all-in-one. Recommended. |
| **Double Counter** | Checks the user's Discord account age / flags for alts & VPNs | Great as a *second* layer against ban-evaders. |
| **Captcha.bot** | Image captcha in DM | Simple, effective vs. bot raids. |

**Wick verification setup:**
1. Invite Wick → run `/setup` and pick a prefix.
2. `/module verification` → enable → set **Verified role = `Verified`**.
3. Set the **verification channel = `#verify`**.
4. Choose **Button** mode (add **Captcha** if you get bot raids).
5. In `#verify` channel permissions: `@everyone` → View Channel **ON**, Send **OFF**.
6. In every other channel, `@everyone` **can't** view; `Verified` **can** (set at
   the category level in Step 3 so it cascades).

Optional hardening: add **Double Counter** and set it to auto-kick accounts
younger than ~7 days or flagged as alts, with a `#verify` message telling real
new users to open a ticket if wrongly flagged.

---

## 3. Channels & categories

Create categories in this order. Set permissions **on the category** and let
channels sync — only override the few channels noted.

```
━━━ WELCOME ━━━                     (@everyone: View ✔ / Send ✘   ·  Verified: View ✔)
#welcome                            read-only. Server intro + link to the website.
#rules                              read-only. Paste the rules (or link rules.html).
#verify                             @everyone View ✔ Send ✘. Wick posts the button here.
#announcements                      read-only. Staff only can post.
#server-status                      read-only. Status bot / manual updates.

━━━ COMMUNITY ━━━                   (@everyone: View ✘   ·  Verified: View ✔ Send ✔)
#general
#media-clips                        allow Attach Files / Embed Links
#suggestions                        add a 👍/👎 auto-react or a suggestions bot

━━━ CITY INFO ━━━                   (@everyone: View ✘   ·  Verified: View ✔ Send ✘  — read-only)
#new-player-guide
#jobs-and-careers
#businesses-housing-real-estate
#pd-ems-mechanics

━━━ APPLICATIONS ━━━                (Verified: View ✔ Send ✘)
#apply-here                         explains the apply.html flow + which ticket to open
#application-status                 staff post results, or leave threads open per applicant

━━━ SUPPORT ━━━                     (Verified: View ✔ Send ✘)
#open-a-ticket                      ticket bot panel lives here
#support-info                       what each ticket is for, what to include

━━━ DEPARTMENTS ━━━                 (@everyone & Verified: View ✘)
#lspd                               override: LSPD View ✔ Send ✔  ·  Support/Mod View ✔
#ems                                override: EMS View ✔ Send ✔
#mechanic                           override: Mechanic View ✔ Send ✔
#business-owners                    override: Business Owner View ✔ Send ✔

━━━ SUPPORTERS ━━━                  (@everyone & Verified: View ✘)
#supporter-lounge                   override: Customer View ✔ Send ✔  (and Supporter if you split them)

━━━ STAFF ━━━  🔒                   (@everyone & Verified: View ✘)
#staff-chat                         override: Support/Moderator/Admin/Owner View ✔ Send ✔
#staff-announcements                override: Admin/Owner Send ✔ ; Support/Moderator View ✔
#tickets-and-reports               (ticket bot can also just make channels under SUPPORT — your call)
#ticket-logs                        ticket bot transcript log
#purchase-logs                      Tebex webhook posts sales here
#mod-logs                           audit/mod-action log bot
```

**How to set a category permission:** open the category → Permissions →
add `@everyone` and set **View Channel = ✘**, then add `Verified` and set the
right View/Send. Channels inside will "sync" automatically. Only the ones with a
note above need their own override on top.

---

## 4. Ticket system

**Bot options (free tiers fine):** **Ticket Tool**, **Tickets**, or **Tickety**.
Ticket Tool is the most common on FiveM servers.

Set up **one panel** in `#open-a-ticket` with these ticket types (Ticket Tool
calls them "panels"/"multi-panels"):

| Ticket | Who can see it | Ask for |
|--------|----------------|---------|
| **General Support** | opener + Support | character name, what happened |
| **Bug Report** | opener + Support | steps to reproduce, clip/screenshot |
| **Player Report** | opener + **Moderator/Admin only** (not Support) | who, when, **clip/screenshot** |
| **Ban / Punishment Appeal** | opener + **Admin/Owner only** | Discord ID, the punishment, honest account |
| **Purchase Support** | opener + Support | Tebex transaction / order ID |
| **Custom Order (Chain / Clothing / Vehicle)** | opener + Support + Owner | **Tebex invoice (required)** + reference image |
| **Staff Application** | opener + Admin/Owner | the copied application from apply.html |
| **PD / EMS / Business Application** | opener + department lead + Admin | the copied application |

Ticket bot config:
- **Support role** = `Support` (add `Moderator`/`Admin` on the report/appeal panels).
- **Transcript / log channel** = `#ticket-logs`.
- **Ticket category** = a hidden category the bot manages (or under `SUPPORT`).
- Turn ON: close-with-reason, transcript-on-close, and a claim system so two
  staff don't answer the same ticket.
- Add a one-line rule in `#support-info`: *staff will never DM you for passwords,
  card numbers, CVV, or banking logins.*

---

## 5. Tebex → automatic Discord roles

When the store opens, Tebex assigns the Discord role on purchase — no bot needed.

1. **Tebex Creator Panel → Integrations → Discord** → connect your server, and
   authorise the Tebex bot. Give the Tebex bot role a position **above**
   `Customer` / `Supporter` in your role list (so it can assign them).
2. For each package: **package → "Discord role"** setting → choose the role:
   - Supporter tiers → `Supporter` (or `Customer`)
   - Custom Chain / Clothing / Vehicle / Queue Priority / everything else → `Customer`
3. Keep it to **one visible customer role**. Tebex/the ticket still knows the
   exact package, so the custom-order tickets route correctly without cluttering
   your role list with `Custom Chain Customer`, `Custom Clothing Customer`, etc.
4. **Purchase log:** Tebex → Webhooks → add a Discord webhook pointing at
   `#purchase-logs` so every sale drops there for staff to cross-check invoices.
5. Subscriptions (if any tier is monthly): Tebex auto-**removes** the role when a
   subscription lapses. One-time purchases keep the role.

> Even with the auto-role, **custom orders still require the Tebex invoice in the
> ticket** before work starts. That's your second verification point.

---

## 6. Recommended bot stack (all have free tiers)

| Job | Bot |
|-----|-----|
| Verification + anti-raid + anti-nuke | **Wick** |
| Alt / ban-evader detection | **Double Counter** |
| Tickets | **Ticket Tool** |
| Mod logging + timed mutes + reaction roles | **Carl-bot** or **Dyno** |
| Purchases | **Tebex** (native Discord integration) |
| FiveM live status in `#server-status` | **Statbot** / **Server Status Bot** (add once you have the Cfx join code) |

Give each bot's role only the permissions it needs, and keep all bot roles
**below Owner** but above the roles they manage.

---

## 7. Do-this-in-order checklist

1. Enable Community + Safety Setup + AutoMod.
2. Create all 11 roles, top-to-bottom, with the permissions in Step 1.
3. Lock `@everyone` down (View Channels OFF).
4. Create the categories; set View permissions at the **category** level
   (`@everyone` ✘, `Verified` ✔ where noted).
5. Add the department / supporter / staff **channel overrides** from Step 3.
6. Invite **Wick**, set verification → `Verified` role, button in `#verify`.
7. Invite **Ticket Tool**, build the panel in `#open-a-ticket`, log to `#ticket-logs`.
8. Invite **Carl-bot/Dyno** for mod logs → `#mod-logs`.
9. (Later) Connect **Tebex → Discord**, map packages to `Customer`/`Supporter`,
   webhook to `#purchase-logs`.
10. (Later) Add the **status bot** in `#server-status` with your Cfx join code.
11. Test with an alt account: join → can only see `#welcome` + `#verify` → verify
    → everything else appears → open a test ticket → confirm only you + Support
    see it.

---

## 8. Quick copy — role list for the bots

```
Owner
Admin
Moderator
Support
LSPD
EMS
Mechanic
Business Owner
Customer
Supporter
Verified
```

## 9. Quick copy — channel tree

```
WELCOME: welcome, rules, verify, announcements, server-status
COMMUNITY: general, media-clips, suggestions
CITY INFO: new-player-guide, jobs-and-careers, businesses-housing-real-estate, pd-ems-mechanics
APPLICATIONS: apply-here, application-status
SUPPORT: open-a-ticket, support-info
DEPARTMENTS: lspd, ems, mechanic, business-owners
SUPPORTERS: supporter-lounge
STAFF (locked): staff-chat, staff-announcements, ticket-logs, purchase-logs, mod-logs
```
