#!/bin/bash
echo "🎨 Correcting theme: light page + dark accent bands (matching original)..."

# ---------- tokens.css ----------
cat > src/styles/tokens.css << 'EOF'
:root {
  /* Dark navy — used only for accent bands: header logo icon, ticker, hero, stats bar, footer */
  --tsd-navy: #0A1628;
  --tsd-navy-mid: #122040;
  --tsd-navy-light: #1A3A6B;

  /* Cyan accent */
  --tsd-cyan: #00A8FF;
  --tsd-cyan-dark: #007FCC;      /* text/icons on light backgrounds */
  --tsd-cyan-bright: #00D4FF;    /* hover state */
  --tsd-cyan-subtle: rgba(0, 168, 255, 0.07);
  --tsd-cyan-border: rgba(0, 168, 255, 0.25);
  --tsd-cyan-glow: rgba(0, 168, 255, 0.18);

  /* Page — LIGHT by default */
  --tsd-bg: #F5F7FA;
  --tsd-bg-card: #FFFFFF;
  --tsd-bg-alt: #EEF1F6;
  --tsd-white: #FFFFFF;

  /* Text */
  --tsd-text: #1C2B3A;
  --tsd-text-mid: #3D5166;
  --tsd-text-light: #6B8299;
  --tsd-muted: rgba(255, 255, 255, 0.6); /* muted text ON dark bands only */

  /* Borders */
  --tsd-border: #D4DCE8;                 /* light-band borders */
  --tsd-line: rgba(255, 255, 255, 0.08); /* dark-band borders */

  /* Shadows / radius */
  --tsd-shadow-sm: 0 2px 8px rgba(10,22,40,.08);
  --tsd-shadow-md: 0 6px 24px rgba(10,22,40,.12);
  --tsd-shadow-lg: 0 16px 48px rgba(10,22,40,.16);
  --tsd-shadow-cyan: 0 0 24px rgba(0,168,255,.2);
  --tsd-r-sm: 3px;
  --tsd-r: 5px;
  --tsd-r-md: 8px;
  --tsd-r-lg: 12px;

  --font-display: 'Playfair Display', Georgia, serif;
  --font-mono: 'IBM Plex Mono', 'Courier New', monospace;
  --font-body: 'Source Sans 3', system-ui, sans-serif;
}
EOF

# ---------- global.css ----------
cat > src/styles/global.css << 'EOF'
* { box-sizing: border-box; }
html, body { margin: 0; padding: 0; }
body {
  background: var(--tsd-bg);
  color: var(--tsd-text);
  font-family: var(--font-body);
  line-height: 1.6;
}
h1, h2, h3 { font-family: var(--font-display); font-weight: 700; color: var(--tsd-navy); }
a { color: var(--tsd-cyan-dark); text-decoration: none; }
a:hover { color: var(--tsd-cyan); }
.tsd-container { max-width: 1180px; margin: 0 auto; padding: 0 1.5rem; }
.tsd-tag {
  font-family: var(--font-mono);
  font-size: 0.6rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--tsd-cyan-dark);
  background: var(--tsd-cyan-subtle);
  border: 1px solid var(--tsd-cyan-border);
  padding: 0.18rem 0.55rem;
  border-radius: var(--tsd-r-sm);
  display: inline-block;
  transition: all 0.2s ease;
}
.tsd-tag:hover { background: var(--tsd-navy); color: var(--tsd-cyan); border-color: var(--tsd-navy); }
EOF

# ---------- Header.astro ----------
cat > src/components/Header.astro << 'EOF'
---
import NewsTicker from './NewsTicker.astro';

const navItems = [
  { label: 'HOME', href: '/' },
  { label: 'THREAT INTEL', href: '/threat-intel' },
  { label: 'ARTICLES', href: '/articles' },
  { label: 'CONTACT', href: '/contact' },
  { label: 'ABOUT', href: '/about' },
];
---
<header class="tsd-header">
  <div class="tsd-container tsd-header__bar">
    <a href="/" class="tsd-logo">
      <span class="tsd-logo__icon" aria-hidden="true">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#00A8FF" stroke-width="2">
          <rect x="2" y="3" width="20" height="14" rx="2"></rect>
          <path d="M8 21h8M12 17v4"></path>
        </svg>
      </span>
      <span class="tsd-logo__text">
        <span class="tsd-logo__the">THE</span>
        <span class="tsd-logo__name">Security Desk</span>
      </span>
    </a>
    <nav class="tsd-header__nav">
      {navItems.map((item) => <a href={item.href}>{item.label}</a>)}
    </nav>
  </div>
  <NewsTicker />
</header>

<style>
.tsd-header { background: var(--tsd-white); border-bottom: 1px solid var(--tsd-border); box-shadow: var(--tsd-shadow-sm); position: sticky; top: 0; z-index: 1000; }
.tsd-header__bar { display: flex; align-items: center; justify-content: space-between; padding: 1rem 0; }
.tsd-logo { display: flex; align-items: center; gap: 0.65rem; text-decoration: none; }
.tsd-logo__icon {
  width: 36px; height: 36px; flex-shrink: 0;
  background: var(--tsd-navy); border-radius: var(--tsd-r);
  display: flex; align-items: center; justify-content: center;
  position: relative; overflow: hidden;
}
.tsd-logo__icon::after {
  content: ''; position: absolute; inset: 0;
  background: linear-gradient(135deg, var(--tsd-cyan) 0%, transparent 60%);
  opacity: 0.28;
}
.tsd-logo__icon svg { position: relative; z-index: 1; }
.tsd-logo__text { display: flex; flex-direction: column; line-height: 1; gap: 0.1rem; }
.tsd-logo__the { font-family: var(--font-mono); font-size: 0.58rem; letter-spacing: 0.22em; color: var(--tsd-cyan-dark); }
.tsd-logo__name { font-family: var(--font-display); font-size: 1.05rem; font-weight: 700; color: var(--tsd-navy); }
.tsd-header__nav { display: flex; gap: 0.15rem; font-family: var(--font-body); font-size: 0.8rem; font-weight: 600; letter-spacing: 0.05em; }
.tsd-header__nav a {
  color: var(--tsd-text-mid); padding: 0.5rem 0.9rem; border-radius: var(--tsd-r);
  position: relative; text-decoration: none; transition: color 0.2s ease;
}
.tsd-header__nav a::after {
  content: ''; position: absolute; bottom: 2px; left: 0.9rem; right: 0.9rem; height: 2px;
  background: var(--tsd-cyan); transform: scaleX(0); transition: transform 0.2s ease;
}
.tsd-header__nav a:hover { color: var(--tsd-navy); }
.tsd-header__nav a:hover::after { transform: scaleX(1); }
</style>
EOF

# ---------- NewsTicker.astro ----------
cat > src/components/NewsTicker.astro << 'EOF'
---
const headlines = [
  'Critical VMware vCenter RCE flaw exploited in the wild',
  'AI "watermark removers" flood the web — almost none can prove they work',
  'New zero-day vulnerability disclosed in widely used enterprise software',
];
---
<div class="tsd-ticker">
  <span class="tsd-ticker__label">
    <span class="tsd-ticker__dot"></span> Live Feed
  </span>
  <div class="tsd-ticker__track">
    <div class="tsd-ticker__inner">
      {headlines.concat(headlines).map((h) => (
        <span class="tsd-ticker__item">{h} &nbsp;•&nbsp;</span>
      ))}
    </div>
  </div>
</div>

<style>
.tsd-ticker {
  background: var(--tsd-navy); height: 34px; display: flex; align-items: center;
  overflow: hidden; border-bottom: 1px solid rgba(0,168,255,0.1);
}
.tsd-ticker__label {
  font-family: var(--font-mono); font-size: 0.6rem; letter-spacing: 0.16em; text-transform: uppercase;
  color: var(--tsd-cyan); background: var(--tsd-navy-mid);
  padding: 0 1.1rem; height: 100%; display: flex; align-items: center; gap: 0.5rem;
  white-space: nowrap; border-right: 1px solid rgba(0,168,255,0.18); min-width: 110px; flex-shrink: 0;
}
.tsd-ticker__dot { width: 6px; height: 6px; background: var(--tsd-cyan); border-radius: 50%; animation: tsd-pulse 2s ease infinite; }
@keyframes tsd-pulse { 0%,100% { opacity: 1; transform: scale(1); } 50% { opacity: .35; transform: scale(.65); } }
.tsd-ticker__track { flex: 1; overflow: hidden; }
.tsd-ticker__inner { display: flex; white-space: nowrap; animation: tsd-scroll 40s linear infinite; }
.tsd-ticker__inner:hover { animation-play-state: paused; }
.tsd-ticker__item { color: rgba(255,255,255,0.75); font-size: 0.8rem; padding-right: 0.5rem; }
@keyframes tsd-scroll { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }
</style>
EOF

echo "✅ Header + ticker fixed (white header, logo mark, working single-line marquee)"

# ---------- index.astro (hero / stats / quote) ----------
cat > src/pages/index.astro << 'EOF'
---
import BaseLayout from '../layouts/BaseLayout.astro';
import ArticleCard from '../components/ArticleCard.astro';
import { getArticles, getArticlesByCategory } from '../lib/strapi.js';

const allArticles = await getArticles();
const threatIntel = await getArticlesByCategory('threat-intelligence');
const featured = allArticles.slice(0, 3);
---
<BaseLayout title="The Security Desk">
  <!-- Hero Section -->
  <section class="tsd-hero">
    <div class="tsd-hero__inner">
      <div class="tsd-hero__content">
        <span class="tsd-eyebrow">Cybersecurity Intelligence</span>
        <h1>Stay Ahead of <span class="tsd-accent">Every Threat.</span></h1>
        <p class="tsd-hero__tagline">
          <strong>Where Knowledge Becomes Your First Defence.</strong><br />
          Independent threat intelligence, vulnerability analysis, and security research — curated for practitioners.
        </p>
        <div class="tsd-hero__cta">
          <a href="#latest-threats" class="tsd-btn tsd-btn--primary">Latest Threats</a>
          <div class="tsd-search-wrap">
            <input type="text" placeholder="Search..." class="tsd-search" />
          </div>
        </div>
      </div>
      <div class="tsd-hero__visual">
        <div class="tsd-terminal">
          <div class="tsd-terminal__header">
            <span class="dot"></span><span class="dot"></span><span class="dot"></span>
            <span>threat-monitor.sh</span>
          </div>
          <div class="tsd-terminal__body">
            <div class="cmd">$ ./scan --live --feed=all</div>
            <div>✓ Connected to threat feeds</div>
            <div>✓ CVE database synced</div>
            <div class="warn">⚠ 3 critical advisories today</div>
            <div>✓ MITRE ATT&CK updated</div>
            <div>✓ IOC watchlist active</div>
            <div class="cmd">$ monitor --continuous</div>
            <div class="blink">$ Monitoring active...</div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- Stats Bar -->
  <section class="tsd-stats">
    <div class="tsd-container tsd-stats__inner">
      <div class="tsd-stat"><span class="tsd-stat__value">2,400+</span><span class="tsd-stat__label">CVEs Tracked</span></div>
      <div class="tsd-stat"><span class="tsd-stat__value">180+</span><span class="tsd-stat__label">Articles Published</span></div>
      <div class="tsd-stat"><span class="tsd-stat__value">Daily</span><span class="tsd-stat__label">Threat Updates</span></div>
      <div class="tsd-stat"><span class="tsd-stat__value">100%</span><span class="tsd-stat__label">Independent & Ad-Free</span></div>
    </div>
  </section>

  <!-- Quote Banner -->
  <section class="tsd-quote">
    <blockquote>"Security is not a product to be bought — <strong>it is</strong> a discipline to be practised. We exist to share the knowledge that makes that discipline possible."</blockquote>
  </section>

  <!-- Latest Threats -->
  {threatIntel.length > 0 && (
    <section class="tsd-section" id="latest-threats">
      <div class="tsd-container">
        <div class="tsd-section__header">
          <div><span class="tsd-eyebrow">Threat Intelligence</span><h2>Latest Threats</h2></div>
          <a href="/threat-intel" class="tsd-link">View All →</a>
        </div>
        <div class="tsd-grid">
          {threatIntel.slice(0, 3).map((article) => <ArticleCard article={article} />)}
        </div>
      </div>
    </section>
  )}

  <!-- Featured Articles -->
  {featured.length > 0 && (
    <section class="tsd-section">
      <div class="tsd-container">
        <div class="tsd-section__header">
          <div><span class="tsd-eyebrow">Knowledge Base</span><h2>Featured Articles</h2></div>
        </div>
        <div class="tsd-grid">
          {featured.map((article) => <ArticleCard article={article} />)}
        </div>
      </div>
    </section>
  )}
</BaseLayout>

<style>
.tsd-hero {
  background: var(--tsd-navy);
  padding: 5rem 0 4.5rem;
  position: relative;
  overflow: hidden;
}
.tsd-hero::before {
  content: ''; position: absolute; inset: 0;
  background-image:
    linear-gradient(rgba(0,168,255,.055) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,168,255,.055) 1px, transparent 1px);
  background-size: 40px 40px;
}
.tsd-hero::after {
  content: ''; position: absolute; top: -120px; right: -120px; width: 520px; height: 520px;
  background: radial-gradient(circle, rgba(0,168,255,.12) 0%, transparent 70%); pointer-events: none;
}
.tsd-hero__inner {
  max-width: 1180px; margin: 0 auto; padding: 0 1.5rem; position: relative; z-index: 1;
  display: grid; grid-template-columns: 1fr 1fr; gap: 4rem; align-items: center;
}
.tsd-eyebrow {
  font-family: var(--font-mono); font-size: 0.7rem; letter-spacing: 0.18em; text-transform: uppercase;
  color: var(--tsd-cyan); display: flex; align-items: center; gap: 0.65rem; margin-bottom: 1rem;
}
.tsd-eyebrow::before { content: ''; width: 22px; height: 1px; background: var(--tsd-cyan); }
.tsd-hero h1 { font-size: clamp(2rem, 4.5vw, 3.4rem); font-weight: 900; color: var(--tsd-white); line-height: 1.1; margin: 0 0 1.2rem 0; }
.tsd-accent { color: var(--tsd-cyan); font-style: italic; }
.tsd-hero__tagline { font-size: 1rem; color: rgba(255,255,255,.65); line-height: 1.7; max-width: 480px; margin-bottom: 2rem; }
.tsd-hero__tagline strong { color: rgba(255,255,255,.92); font-weight: 600; display: block; margin-bottom: 0.4rem; font-size: 1.1rem; }
.tsd-hero__cta { display: flex; gap: 1rem; flex-wrap: wrap; }
.tsd-btn {
  font-family: var(--font-body); font-weight: 600; font-size: 0.8rem; letter-spacing: 0.05em;
  text-transform: uppercase; padding: 0.75rem 1.6rem; border-radius: var(--tsd-r); border: none;
  cursor: pointer; text-decoration: none; display: inline-flex; align-items: center;
}
.tsd-btn--primary { background: var(--tsd-cyan); color: var(--tsd-navy); }
.tsd-btn--primary:hover { background: var(--tsd-cyan-bright); box-shadow: var(--tsd-shadow-cyan); }
.tsd-search-wrap { flex: 1; min-width: 200px; }
.tsd-search {
  width: 100%; height: 100%; padding: 0.75rem 1rem;
  background: rgba(255,255,255,0.08); border: 1px solid var(--tsd-cyan-border);
  border-radius: var(--tsd-r); color: var(--tsd-white); font-family: var(--font-body); font-size: 0.9rem;
}
.tsd-search::placeholder { color: rgba(255,255,255,0.4); }
.tsd-search:focus { outline: none; border-color: var(--tsd-cyan); background: rgba(255,255,255,0.12); }

.tsd-hero__visual { display: flex; justify-content: center; }
.tsd-terminal {
  background: rgba(10,22,40,.82); border: 1px solid rgba(0,168,255,.18); border-radius: var(--tsd-r-lg);
  padding: 1.4rem; width: 100%; max-width: 430px; backdrop-filter: blur(8px);
  box-shadow: 0 0 36px rgba(0,168,255,.08), var(--tsd-shadow-lg); font-family: var(--font-mono); font-size: 0.85rem;
}
.tsd-terminal__header {
  display: flex; align-items: center; gap: 0.6rem; margin-bottom: 1rem; padding-bottom: 0.9rem;
  border-bottom: 1px solid rgba(0,168,255,.09); font-size: 0.75rem; color: rgba(255,255,255,.4);
}
.dot { width: 10px; height: 10px; border-radius: 50%; }
.dot:nth-child(1) { background: #FF5F57; }
.dot:nth-child(2) { background: #FFBD2E; }
.dot:nth-child(3) { background: #28C840; }
.tsd-terminal__body div { margin: 0.4rem 0; line-height: 1.5; color: rgba(255,255,255,.78); }
.tsd-terminal__body .cmd { color: var(--tsd-cyan); }
.tsd-terminal__body .warn { color: #FFBD2E; }
.blink { animation: blink 1.1s infinite; }
@keyframes blink { 0%,50% { opacity: 1; } 51%,100% { opacity: 0.35; } }

.tsd-stats { background: var(--tsd-navy); border-top: 1px solid rgba(0,168,255,.12); border-bottom: 1px solid rgba(0,168,255,.12); padding: 1.1rem 0; }
.tsd-stats__inner { display: flex; justify-content: space-around; align-items: center; gap: 2rem; flex-wrap: wrap; }
.tsd-stat { display: flex; flex-direction: column; align-items: center; gap: 0.25rem; }
.tsd-stat__value { font-family: var(--font-mono); font-size: 1.4rem; font-weight: 700; color: var(--tsd-cyan); }
.tsd-stat__label { font-family: var(--font-body); font-size: 0.7rem; letter-spacing: 0.1em; text-transform: uppercase; color: rgba(255,255,255,.5); }

.tsd-quote { background: var(--tsd-cyan); color: var(--tsd-navy); padding: 2.75rem 1.5rem; text-align: center; }
.tsd-quote blockquote { font-family: var(--font-display); font-size: clamp(1.1rem, 2vw, 1.5rem); font-style: italic; font-weight: 700; margin: 0 auto; max-width: 800px; line-height: 1.55; }

.tsd-section { padding: 3.5rem 0; }
.tsd-section__header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 2rem; flex-wrap: wrap; gap: 1rem; }
.tsd-section h2 { font-size: 1.8rem; margin: 0.4rem 0 0 0; color: var(--tsd-navy); }
.tsd-link { color: var(--tsd-cyan-dark); font-family: var(--font-mono); font-size: 0.85rem; white-space: nowrap; }
.tsd-link:hover { color: var(--tsd-cyan); }

.tsd-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; }

@media (max-width: 900px) {
  .tsd-hero__inner { grid-template-columns: 1fr; }
  .tsd-hero__visual { display: none; }
  .tsd-hero h1 { font-size: 2.2rem; }
  .tsd-grid { grid-template-columns: 1fr; }
}
</style>
EOF

# ---------- ArticleCard.astro ----------
cat > src/components/ArticleCard.astro << 'EOF'
---
const { article } = Astro.props;
---
<a class="tsd-card" href={`/articles/${article.slug}`}>
  <div class="tsd-card__img">
    {article.imageUrl ? (
      <img src={article.imageUrl} alt={article.title} />
    ) : (
      <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="#00A8FF" stroke-width="1.5" opacity="0.5">
        <rect x="2" y="3" width="20" height="14" rx="2"></rect>
        <path d="M8 21h8M12 17v4"></path>
      </svg>
    )}
  </div>
  <div class="tsd-card__body">
    <div class="tsd-card__meta">
      <span class="tsd-card__date">{new Date(article.publishedDate).toLocaleDateString('en-US', { month: 'short', day: '2-digit', year: 'numeric' })}</span>
    </div>
    <span class="tsd-tag">{article.category}</span>
    <h3>{article.title}</h3>
    <p>{article.excerpt}</p>
    <span class="tsd-card__more">Read More →</span>
  </div>
</a>

<style>
.tsd-card {
  display: flex; flex-direction: column; text-decoration: none; color: inherit;
  background: var(--tsd-bg-card); border: 1px solid var(--tsd-border); border-radius: var(--tsd-r-lg);
  overflow: hidden; position: relative; transition: all 0.24s ease;
}
.tsd-card::before {
  content: ''; position: absolute; top: 0; left: 0; right: 0; height: 3px;
  background: linear-gradient(90deg, var(--tsd-cyan), transparent); opacity: 0; transition: opacity 0.24s ease;
}
.tsd-card:hover { box-shadow: var(--tsd-shadow-md); transform: translateY(-3px); border-color: var(--tsd-cyan-border); }
.tsd-card:hover::before { opacity: 1; }
.tsd-card__img {
  aspect-ratio: 16/9; overflow: hidden;
  background: linear-gradient(135deg, var(--tsd-navy) 0%, var(--tsd-navy-light) 100%);
  display: flex; align-items: center; justify-content: center;
}
.tsd-card__img img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.4s ease; }
.tsd-card:hover .tsd-card__img img { transform: scale(1.04); }
.tsd-card__body { padding: 1.3rem; flex: 1; display: flex; flex-direction: column; gap: 0.65rem; }
.tsd-card__meta { display: flex; align-items: center; gap: 0.5rem; }
.tsd-card__date { font-family: var(--font-mono); font-size: 0.65rem; letter-spacing: 0.06em; color: var(--tsd-text-light); }
.tsd-card h3 { font-family: var(--font-display); font-size: 1.05rem; font-weight: 700; color: var(--tsd-navy); line-height: 1.33; margin: 0; transition: color 0.2s ease; }
.tsd-card:hover h3 { color: var(--tsd-cyan-dark); }
.tsd-card p { margin: 0; color: var(--tsd-text-light); font-size: 0.85rem; line-height: 1.6; flex: 1; }
.tsd-card__more { font-family: var(--font-mono); font-size: 0.78rem; color: var(--tsd-cyan-dark); }
</style>
EOF

# ---------- Footer.astro ----------
cat > src/components/Footer.astro << 'EOF'
---
const footerNav = [
  { label: 'Home', href: '/' },
  { label: 'Threat Intel', href: '/threat-intel' },
  { label: 'Articles', href: '/articles' },
  { label: 'Contact', href: '/contact' },
  { label: 'About', href: '/about' },
];
const topicLinks = [
  { label: 'Ransomware', href: '/articles' },
  { label: 'Zero-Days', href: '/articles' },
  { label: 'APT Groups', href: '/articles' },
  { label: 'Cloud Security', href: '/articles' },
  { label: 'OSINT', href: '/articles' },
  { label: 'Red Teaming', href: '/articles' },
];
const connectLinks = [
  { label: 'RSS Feed', href: '/rss.xml' },
  { label: 'GitHub', href: 'https://github.com' },
  { label: 'Mastodon', href: 'https://infosec.exchange' },
  { label: 'Contact Form', href: '/contact' },
];
---
<footer class="tsd-footer">
  <div class="tsd-container tsd-footer__grid">
    <div class="tsd-footer__brand">
      <a href="/" class="tsd-logo tsd-logo--footer">
        <span class="tsd-logo__icon" aria-hidden="true">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#00A8FF" stroke-width="2">
            <rect x="2" y="3" width="20" height="14" rx="2"></rect>
            <path d="M8 21h8M12 17v4"></path>
          </svg>
        </span>
        <span class="tsd-logo__text">
          <span class="tsd-logo__the">THE</span>
          <span class="tsd-logo__name tsd-logo__name--light">Security Desk</span>
        </span>
      </a>
      <p>An independent cybersecurity knowledge platform. No vendor bias. No paywalls.</p>
    </div>
    <div>
      <h3>Navigate</h3>
      {footerNav.map((item) => <a href={item.href}>{item.label}</a>)}
    </div>
    <div>
      <h3>Topics</h3>
      {topicLinks.map((item) => <a href={item.href}>{item.label}</a>)}
    </div>
    <div>
      <h3>Connect</h3>
      {connectLinks.map((item) => <a href={item.href} target="_blank" rel="noopener noreferrer">{item.label}</a>)}
    </div>
  </div>
  <p class="tsd-footer__copy">© {new Date().getFullYear()} The Security Desk · Independent &amp; Ad-Free</p>
</footer>

<style>
.tsd-footer { background: var(--tsd-navy); color: rgba(255,255,255,.65); padding: 3.5rem 0 0; }
.tsd-footer__grid { display: grid; grid-template-columns: 1.6fr 1fr 1fr 1fr; gap: 2.5rem; padding-bottom: 2.5rem; border-bottom: 1px solid rgba(255,255,255,.07); }
.tsd-footer__brand p { color: rgba(255,255,255,.45); font-size: 0.83rem; line-height: 1.7; margin-top: 0.9rem; }
.tsd-logo--footer .tsd-logo__icon { width: 40px; height: 40px; }
.tsd-logo__name--light { color: var(--tsd-white); }
.tsd-footer__grid h3 { font-family: var(--font-mono); font-size: 0.65rem; letter-spacing: 0.14em; text-transform: uppercase; color: var(--tsd-cyan); margin: 0 0 1rem 0; }
.tsd-footer__grid a { display: block; color: rgba(255,255,255,.5); text-decoration: none; font-size: 0.85rem; margin-bottom: 0.6rem; }
.tsd-footer__grid a:hover { color: var(--tsd-cyan); }
.tsd-footer__copy { text-align: center; color: rgba(255,255,255,.25); font-family: var(--font-mono); font-size: 0.7rem; margin: 0; padding: 1.4rem 0; }
</style>
EOF

echo "✅ Hero, stats bar, article cards, and footer now match the original's light-theme-with-dark-bands structure."
