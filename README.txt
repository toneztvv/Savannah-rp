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
