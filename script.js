const menuBtn=document.getElementById('menuBtn');
const nav=document.getElementById('navLinks');
menuBtn?.addEventListener('click',()=>nav.classList.toggle('open'));
document.querySelectorAll('#navLinks a').forEach(a=>a.addEventListener('click',()=>nav.classList.remove('open')));

/*
  SAVANNAH RP LIVE STATUS
  -----------------------
  Put the public Cfx.re server join code / server ID below.
  Example format only: abc123
  Do NOT paste your license key here.
*/
const SAVANNAH_CFX_SERVER_ID = "";

function setServerUI(status, playersText, isOnline){
  document.querySelectorAll('[data-server-status]').forEach(el=>{
    el.textContent=status;
  });
  document.querySelectorAll('[data-player-count]').forEach(el=>{
    el.textContent=playersText;
  });

  document.querySelectorAll('.status i, .status-box i, .join-status-grid i').forEach(dot=>{
    dot.classList.toggle('server-offline-dot', !isOnline);
  });
}

async function refreshSavannahStatus(){
  if(!SAVANNAH_CFX_SERVER_ID){
    setServerUI("CONFIG NEEDED", "— / —", false);
    return;
  }

  try{
    const endpoint=`https://servers-frontend.fivem.net/api/servers/single/${encodeURIComponent(SAVANNAH_CFX_SERVER_ID)}`;
    const response=await fetch(endpoint,{cache:"no-store"});
    if(!response.ok) throw new Error("Server lookup failed");

    const payload=await response.json();
    const data=payload?.Data || payload?.data || payload;
    const clients=Number(data?.clients ?? data?.Clients ?? 0);
    const maxClients=Number(data?.svMaxclients ?? data?.sv_maxclients ?? data?.MaxClients ?? 0);

    if(!data) throw new Error("No server data");

    setServerUI(
      "ONLINE",
      maxClients ? `${clients} / ${maxClients}` : `${clients} ONLINE`,
      true
    );
  }catch(err){
    console.warn("Savannah RP status unavailable:",err);
    setServerUI("OFFLINE", "— / —", false);
  }
}

refreshSavannahStatus();
setInterval(refreshSavannahStatus, 60000);


// Savannah RP site polish
const backToTop = document.createElement("button");
backToTop.className = "back-to-top";
backToTop.setAttribute("aria-label","Back to top");
backToTop.textContent = "↑";
document.body.appendChild(backToTop);

window.addEventListener("scroll",()=>{
  backToTop.classList.toggle("show", window.scrollY > 500);
});
backToTop.addEventListener("click",()=>window.scrollTo({top:0,behavior:"smooth"}));

// Respect reduced-motion preferences while still allowing subtle reveal effects.
if(!window.matchMedia("(prefers-reduced-motion: reduce)").matches){
  const observer = new IntersectionObserver(entries=>{
    entries.forEach(entry=>{
      if(entry.isIntersecting){
        entry.target.classList.add("reveal-visible");
        observer.unobserve(entry.target);
      }
    });
  },{threshold:0.08});
  document.querySelectorAll("section, article").forEach(el=>{
    el.classList.add("reveal");
    observer.observe(el);
  });
}
