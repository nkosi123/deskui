#!/bin/bash

echo "🎨 Redesigning to DARK THEME..."

# tokens.css - DARK THEME
cat > src/styles/tokens.css << 'EOF'
:root {
  /* Dark theme */
  --tsd-navy: #0A1628;
  --tsd-navy-light: #0F1E36;
  --tsd-navy-lighter: #1a2a42;
  --tsd-cyan: #00A8FF;
  --tsd-cyan-bright: #00D4FF;
  --tsd-white: #F5F7FA;
  --tsd-muted: #8A94A6;
  --tsd-line: rgba(255, 255, 255, 0.08);

  --font-display: 'Playfair Display', serif;
  --font-mono: 'IBM Plex Mono', monospace;
  --font-body: 'Source Sans 3', sans-serif;
}
EOF

# global.css - DARK THEME
cat > src/styles/global.css << 'EOF'
* { box-sizing: border-box; }
html, body { margin: 0; padding: 0; }
body {
  background: var(--tsd-navy);
  color: var(--tsd-white);
  font-family: var(--font-body);
  line-height: 1.6;
}
h1, h2, h3 { font-family: var(--font-display); font-weight: 700; color: var(--tsd-white); }
a { color: var(--tsd-cyan); text-decoration: none; }
a:hover { color: var(--tsd-cyan-bright); }
.tsd-container { max-width: 1180px; margin: 0 auto; padding: 0 1.5rem; }
.tsd-tag {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  color: var(--tsd-cyan);
  background: rgba(0, 168, 255, 0.1);
  padding: 0.25rem 0.6rem;
  border-radius: 3px;
  display: inline-block;
}
EOF

# Header
cat > src/components/Header.astro << 'EOF'
---
import Logo from './Logo.astro';
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
    <a href="/" class="tsd-header__logo"><Logo /></a>
    <nav class="tsd-header__nav">
      {navItems.map((item) => <a href={item.href}>{item.label}</a>)}
    </nav>
  </div>
  <NewsTicker />
</header>

<style>
.tsd-header { background: var(--tsd-navy); border-bottom: 1px solid var(--tsd-line); }
.tsd-header__bar { display: flex; align-items: center; justify-content: space-between; padding: 1.25rem 0; }
.tsd-header__nav { display: flex; gap: 2rem; font-family: var(--font-mono); font-size: 0.8rem; letter-spacing: 0.05em; }
.tsd-header__nav a { color: var(--tsd-muted); }
.tsd-header__nav a:hover { color: var(--tsd-cyan); }
</style>
EOF

# Updated HomePage with DARK HERO
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
    <div class="tsd-hero__content">
      <span class="tsd-label">Cybersecurity Intelligence</span>
      <h1>Stay Ahead of <span class="tsd-accent">Every Threat.</span></h1>
      <p class="tsd-hero__tagline">Where Knowledge Becomes Your First Defence.</p>
      <p class="tsd-hero__description">Independent threat intelligence, vulnerability analysis, and security research — curated for practitioners.</p>
      <div class="tsd-hero__cta">
        <button class="tsd-btn tsd-btn--primary">Latest Threats</button>
        <input type="text" placeholder="Search..." class="tsd-search" />
      </div>
    </div>
    <div class="tsd-hero__visual">
      <div class="tsd-terminal">
        <div class="tsd-terminal__header">
          <span class="dot"></span>
          <span class="dot"></span>
          <span class="dot"></span>
          <span>threat-monitor.sh</span>
        </div>
        <div class="tsd-terminal__body">
          <div>$ ./scan --live --feed-all</div>
          <div>✓ Connected to threat feeds</div>
          <div>✓ CVE database synced</div>
          <div>⚠ 3 critical advisories today</div>
          <div>✓ MITRE ATT&CK updated</div>
          <div>✓ IOC watchlist active</div>
          <div>$ monitor --continuous</div>
          <div class="blink">$ Monitoring active...</div>
        </div>
      </div>
    </div>
  </section>

  <!-- Stats Section -->
  <section class="tsd-stats">
    <div class="tsd-container">
      <div class="tsd-stat">
        <div class="tsd-stat__value">2,400+</div>
        <div class="tsd-stat__label">CVEs Tracked</div>
      </div>
      <div class="tsd-stat">
        <div class="tsd-stat__value">180+</div>
        <div class="tsd-stat__label">Articles Published</div>
      </div>
      <div class="tsd-stat">
        <div class="tsd-stat__value">Daily</div>
        <div class="tsd-stat__label">Threat Updates</div>
      </div>
      <div class="tsd-stat">
        <div class="tsd-stat__value">100%</div>
        <div class="tsd-stat__label">Independent & Ad-Free</div>
      </div>
    </div>
  </section>

  <!-- Quote Banner -->
  <section class="tsd-quote">
    <blockquote>"Security is not a product to be bought — <strong>it is</strong> a discipline to be practised. We exist to share the knowledge that makes that discipline possible."</blockquote>
  </section>

  <!-- Latest Threats -->
  {threatIntel.length > 0 && (
    <section class="tsd-section">
      <div class="tsd-container">
        <div class="tsd-section__header">
          <div>
            <span class="tsd-label">Threat Intelligence</span>
            <h2>Latest Threats</h2>
          </div>
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
          <div>
            <span class="tsd-label">Knowledge Base</span>
            <h2>Featured Articles</h2>
          </div>
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
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 4rem;
  align-items: center;
  padding: 4rem 0;
  margin: 2rem 0;
}
.tsd-hero__content { max-width: 500px; }
.tsd-label {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--tsd-cyan);
  display: block;
  margin-bottom: 1rem;
}
.tsd-hero h1 {
  font-size: 3.5rem;
  line-height: 1.1;
  margin: 0 0 1rem 0;
  color: var(--tsd-white);
}
.tsd-accent { color: var(--tsd-cyan); font-style: italic; }
.tsd-hero__tagline {
  font-size: 1.2rem;
  color: var(--tsd-white);
  margin: 0 0 1rem 0;
  font-weight: 600;
}
.tsd-hero__description {
  font-size: 1rem;
  color: var(--tsd-muted);
  margin-bottom: 2rem;
  line-height: 1.7;
}
.tsd-hero__cta {
  display: flex;
  gap: 1rem;
}
.tsd-btn {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  letter-spacing: 0.05em;
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  text-transform: uppercase;
  font-weight: 600;
}
.tsd-btn--primary {
  background: var(--tsd-cyan);
  color: var(--tsd-navy);
}
.tsd-btn--primary:hover {
  background: var(--tsd-cyan-bright);
}
.tsd-search {
  padding: 0.75rem 1rem;
  border: 1px solid var(--tsd-line);
  border-radius: 4px;
  font-size: 0.9rem;
  font-family: var(--font-body);
  flex: 1;
  background: rgba(255,255,255,0.05);
  color: var(--tsd-white);
}
.tsd-search::placeholder { color: var(--tsd-muted); }

.tsd-hero__visual {
  display: flex;
  justify-content: center;
}
.tsd-terminal {
  background: var(--tsd-navy-light);
  color: var(--tsd-cyan);
  padding: 1.25rem;
  border-radius: 8px;
  font-family: var(--font-mono);
  font-size: 0.85rem;
  width: 100%;
  max-width: 450px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.3);
  border: 1px solid var(--tsd-line);
}
.tsd-terminal__header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid var(--tsd-line);
  font-size: 0.75rem;
  color: var(--tsd-muted);
}
.dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  opacity: 0.6;
}
.dot:nth-child(1) { background: #ff5f56; }
.dot:nth-child(2) { background: #ffbd2e; }
.dot:nth-child(3) { background: #27c93f; }
.tsd-terminal__body div {
  margin: 0.4rem 0;
  line-height: 1.5;
}
.blink {
  animation: blink 1s infinite;
}
@keyframes blink { 0%, 50% { opacity: 1; } 51%, 100% { opacity: 0.4; } }

.tsd-stats {
  background: var(--tsd-navy-light);
  padding: 3rem 0;
  margin: 3rem 0;
  border-top: 1px solid var(--tsd-line);
  border-bottom: 1px solid var(--tsd-line);
}
.tsd-stats .tsd-container {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 2rem;
  text-align: center;
}
.tsd-stat__value {
  font-family: var(--font-display);
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--tsd-cyan);
  margin-bottom: 0.5rem;
}
.tsd-stat__label {
  font-size: 0.85rem;
  color: var(--tsd-muted);
  font-family: var(--font-mono);
  letter-spacing: 0.05em;
  text-transform: uppercase;
}

.tsd-quote {
  background: var(--tsd-cyan);
  color: var(--tsd-navy);
  padding: 3rem 1.5rem;
  text-align: center;
  margin: 3rem 0;
  border-radius: 0;
}
.tsd-quote blockquote {
  font-family: var(--font-display);
  font-size: 1.6rem;
  font-style: italic;
  margin: 0;
  line-height: 1.6;
  font-weight: 600;
}

.tsd-section {
  padding: 3rem 0;
}
.tsd-section__header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 2rem;
}
.tsd-section h2 {
  font-size: 2rem;
  margin: 0.5rem 0 0 0;
}
.tsd-link {
  color: var(--tsd-cyan);
  font-family: var(--font-mono);
  font-size: 0.85rem;
  letter-spacing: 0.05em;
  white-space: nowrap;
}

.tsd-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
}

@media (max-width: 768px) {
  .tsd-hero { grid-template-columns: 1fr; }
  .tsd-hero h1 { font-size: 2.2rem; }
  .tsd-stats .tsd-container { grid-template-columns: repeat(2, 1fr); }
  .tsd-grid { grid-template-columns: 1fr; }
}
</style>
EOF

# Update ArticleCard for dark theme
cat > src/components/ArticleCard.astro << 'EOF'
---
const { article } = Astro.props;
---
<a class="tsd-card" href={`/articles/${article.slug}`}>
  {article.imageUrl && <img src={article.imageUrl} alt={article.title} />}
  <div class="tsd-card__body">
    <span class="tsd-tag">{article.category}</span>
    <h3>{article.title}</h3>
    <p>{article.excerpt}</p>
    <span class="tsd-card__meta">{new Date(article.publishedDate).toLocaleDateString()}</span>
  </div>
</a>

<style>
.tsd-card { display: block; text-decoration: none; color: inherit; background: var(--tsd-navy-light); border: 1px solid var(--tsd-line); border-radius: 6px; overflow: hidden; transition: transform 0.2s, box-shadow 0.2s; }
.tsd-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,168,255,0.2); }
.tsd-card img { width: 100%; height: 180px; object-fit: cover; background: var(--tsd-navy-lighter); }
.tsd-card__body { padding: 1.25rem; }
.tsd-card h3 { font-size: 1.1rem; margin: 0.75rem 0 0.5rem 0; line-height: 1.3; color: var(--tsd-white); }
.tsd-card p { margin: 0.5rem 0; color: var(--tsd-muted); font-size: 0.9rem; }
.tsd-card__meta { display: block; margin-top: 0.75rem; font-size: 0.8rem; color: rgba(138, 148, 166, 0.7); }
</style>
EOF

# Update Footer for dark theme
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
  { label: 'API Groups', href: '/articles' },
  { label: 'Cloud Security', href: '/articles' },
  { label: 'OSINT', href: '/articles' },
  { label: 'Red Teaming', href: '/articles' },
];
const connectLinks = [
  { label: 'RSS Feed', href: '/rss.xml' },
  { label: 'GitHub', href: 'https://github.com' },
  { label: 'Mastodon', href: 'https://mastodon.social' },
  { label: 'Contact Form', href: '/contact' },
];
---
<footer class="tsd-footer">
  <div class="tsd-container tsd-footer__grid">
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
  <p class="tsd-footer__copy">© {new Date().getFullYear()} The Security Desk · Independent & Ad-Free</p>
</footer>

<style>
.tsd-footer { background: var(--tsd-navy-light); border-top: 1px solid var(--tsd-line); padding: 3rem 0 1.5rem; margin-top: 4rem; }
.tsd-footer__grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; }
.tsd-footer__grid h3 { font-size: 0.85rem; color: var(--tsd-cyan); margin: 0 0 0.75rem 0; }
.tsd-footer__grid a { display: block; color: var(--tsd-muted); text-decoration: none; font-size: 0.9rem; margin-bottom: 0.5rem; }
.tsd-footer__grid a:hover { color: var(--tsd-cyan); }
.tsd-footer__copy { text-align: center; color: rgba(138, 148, 166, 0.5); font-size: 0.8rem; margin-top: 2rem; border-top: 1px solid var(--tsd-line); padding-top: 1rem; }
</style>
EOF

echo "✅ Dark theme redesign complete!"
