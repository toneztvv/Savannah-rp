SAVANNAH RP WEBSITE - STARTER BUILD

Open index.html in a browser.

Current setup:
- Responsive Savannah RP landing page
- Los Santos / semi-serious RP theme
- Sections for PD & EMS, businesses, housing & MLOs, mechanics, street life, custom style
- Tebex store buttons point to: https://store.traprp.com
- Mobile navigation included
- assets/hero-reference.png is currently the approved visual concept used as the temporary hero image

Next items to replace when ready:
- Discord invite URL
- FiveM direct-connect URL / server IP
- Live player count/API
- Final original hero artwork/screenshots
- Rules page
- Full feature/gallery page
- Tebex package showcases


LIVE FIVE M STATUS SETUP
------------------------
1. Open script.js.
2. Find:
   const SAVANNAH_CFX_SERVER_ID = "";
3. Put the PUBLIC Cfx.re server join code/server ID between the quotes.
   Example only:
   const SAVANNAH_CFX_SERVER_ID = "abc123";
4. Commit script.js to GitHub.
5. The website refreshes server status/player count automatically every 60 seconds.

IMPORTANT:
- Do NOT put your Cfx.re license key in this file.
- The website only needs the public join/server identifier.


V8 UPDATE
---------
- Rules page now has fallback dark styling and cache-busted CSS to prevent a blank white page.
- Added planned non-pay-to-win store packages with suggested prices.
- All package buttons currently open the main Tebex store until exact package/category URLs are provided.


V10 UPDATE
----------
Added:
- support.html
- terms.html
- refunds.html
- privacy.html

IMPORTANT BEFORE LAUNCH:
Replace every ADD-YOUR-EMAIL@EXAMPLE.COM placeholder with a real support/contact email.
These pages are starter policies, not a substitute for jurisdiction-specific legal advice.


V12 UPDATE
----------
- applications.html buttons now work.
- Added apply.html with role-specific forms for PD, EMS, Mechanic, Business, Real Estate, Gang/Crew, Tattoo Artist and Staff.
- Forms can save a local draft and generate/copy a formatted application for Discord.
- No backend or external form service is required yet.


V13 UPDATE
----------
- Rebuilt the navigation on every page from one canonical tab list.
- Removed duplicate APPLY tabs and inconsistent page-only tabs.
- APPLY now appears exactly once on all main pages.
- Added updates.html for server announcements, patch notes, events, MLOs, jobs and maintenance.


V14 UPDATE
----------
- Added directory.html: City Directory / Departments & Businesses.
- Includes filters for public services, businesses, housing, nightlife and underground.
- Added City Directory link from the homepage and footer areas without adding another top navigation tab.
- Ready for real business names, owners, hours, locations and screenshots later.


V15 UPDATE
----------
- Added guide.html: New Player / Getting Started guide.
- Covers character creation, rules, jobs, housing, legal/illegal paths, social RP and basic player tips.
- Linked from the homepage without adding another top navigation tab.


V16 UPDATE
----------
Launch-readiness polish:
- Added favicon / app icon.
- Added 404 page.
- Added robots.txt and sitemap.xml.
- Added site.webmanifest.
- Added SEO/social metadata to main pages.
- Added consistent footer navigation.
- Added Back-to-Top button.
- Added subtle scroll reveal animations with reduced-motion accessibility support.
- Improved mobile nav overflow behavior.


V17 UPDATE
----------
- Flattened the website for iPhone/GitHub uploads.
- Removed the assets folder.
- favicon.svg and hero-reference.png now sit in the main website folder.
- You can select and upload every website file from one folder.


V18 UPDATE
----------
- Added team.html for Staff & Leadership.
- Includes ownership/management, PD command, EMS command, real estate, businesses, mechanics and community management.
- Linked from homepage and footer without adding another crowded top navigation tab.


V19 UPDATE
----------
- Removed all staff/leadership roles from team.html.
- Owner page now shows only the Savannah RP owner.
- Updated homepage/footer wording from Staff & Leadership to Owner.


V20 UPDATE
----------
- Added custom-chain.html.
- Buyers can enter chain style, finish, pendant details, character info and artwork method.
- Includes artwork ownership and copyright/trademark confirmations.
- Generates a clean order request that can be copied into Discord.
- Store CUSTOM CHAIN package now opens the custom order page.
- Added four-step custom order flow to the Store page.


V21 UPDATE
----------
- Added custom-clothing.html for original cosmetic clothing orders.
- Supports shirts, jackets, pants, hats, masks, accessories, uniforms, gang/crew cosmetics and full outfits.
- Includes artwork ownership and no-brand/no-copyright confirmations.
- Generates a clean Discord order request.
- Store CITY STYLE PACK now opens the clothing order page.
- Added a Custom Cosmetic Orders hub for chains and clothing.


V22 UPDATE
----------
- Added custom-vehicle.html for visual-only vehicle cosmetics.
- Supports liveries, wraps, vanity plates, business branding, gang/crew cosmetics and other non-performance visuals.
- Explicitly blocks paid speed, handling, armor, durability, storage or combat advantages.
- Store VANITY PLATE package now opens the vehicle cosmetic order page.
- Added Vehicle Cosmetics to the custom-order hub.


V23 UPDATE
----------
- Simplified the Custom Chain process.
- Customer pays first through Tebex.
- Customer opens a Custom Chain / Support ticket.
- Customer uploads the exact picture directly in the ticket.
- Savannah RP creates the chain from the approved image.
- If the finished chain is wrong or not satisfactory, the same ticket stays open until support helps resolve it.
- Removed the old detailed chain-design form and artwork-method form.


V24 UPDATE
----------
- Added Tebex purchase verification to the Custom Chain flow.
- Customer pays first, opens a ticket, then provides receipt/invoice or transaction/order ID.
- Staff verifies the purchase before accepting the chain image.
- Customer may also be asked for the checkout email to match the order.
- Added a warning that staff never need passwords, full card numbers, CVV, or banking login details.
