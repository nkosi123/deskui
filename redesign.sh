#!/bin/bash

echo "🎨 Redesigning Security Desk to match production..."

# Update tokens.css - LIGHT THEME
cat > src/styles/tokens.css << 'EOF'
:root {
  /* Light theme */
  --tsd-bg-primary: #FFFFFF;
  --tsd-bg-secondary: #F8FAFB;
  --tsd-bg-tertiary: #E8F0F7;
  --tsd-text-primary: #0A1628;
  --tsd-text-secondary: #4A5A6F;
  --tsd-text-muted: #7A8A9F;
  --tsd-accent-cyan: #00A8FF;
  --tsd-accent-cyan-dark: #0080CC;
  --tsd-border-light: #E0E8F0;
  --tsd-border-dark: #D0D8E0;

  --font-display: 'Playfair Display', serif;
  --font-mono: 'IBM Plex Mono', monospace;
  --font-body: 'Source Sans 3', sans-serif;
}
EOF

# Update global.css - LIGHT THEME
cat > src/styles/global.css << 'EOF'
* { box-sizing: border-box; }
html, body { margin: 0; padding: 0; }
body {
  background: var(--tsd-bg-primary);
  color: var(--tsd-text-primary);
  font-family: var(--font-body);
  line-height: 1.6;
}
h1, h2, h3 { font-family: var(--font-display); font-weight: 700; color: var(--tsd-text-primary); }
a { color: var(--tsd-accent-cyan); text-decoration: none; }
a:hover { color: var(--tsd-accent-cyan-dark); }
.tsd-container { max-width: 1180px; margin: 0 auto; padding: 0 1.5rem; }
.tsd-tag {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  color: var(--tsd-accent-cyan);
  background: var(--tsd-bg-tertiary);
  padding: 0.25rem 0.6rem;
  border-radius: 3px;
  display: inline-block;
}
EOF

# Update Logo.astro
cat > src/components/Logo.astro << 'EOF'
---
---
<span class="tsd-logo">
  <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="var(--tsd-accent-cyan)" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round">
    <rect x="2" y="3" width="20" height="14" rx="2"/>
    <path d="M8 21h8M12 17v4"/>
  </svg>
  <span class="tsd-logo__text">
    <span class="tsd-logo__pre">THE</span>
    <span class="tsd-logo__main">SECURITY<br/>DESK</span>
  </span>
</span>

<style>
.tsd-logo { display: inline-flex; align-items: center; gap: 0.6rem; }
.tsd-logo__text { display: flex; flex-direction: column; line-height: 1.1; }
.tsd-logo__pre { font-family: var(--font-mono); font-size: 0.65rem; color: var(--tsd-accent-cyan); letter-spacing: 0.08em; text-transform: uppercase; }
.tsd-logo__main { font-family: var(--font-display); font-size: 0.9rem; font-weight: 700; color: var(--tsd-text-primary); }
</style>
EOF

# Update Header.astro
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
.tsd-header { background: var(--tsd-bg-primary); border-bottom: 1px solid var(--tsd-border-light); }
.tsd-header__bar { display: flex; align-items: center; justify-content: space-between; padding: 1.25rem 0; }
.tsd-header__nav { display: flex; gap: 2rem; font-family: var(--font-mono); font-size: 0.8rem; letter-spacing: 0.05em; }
.tsd-header__nav a { text-decoration: none; color: var(--tsd-text-secondary); }
.tsd-header__nav a:hover { color: var(--tsd-accent-cyan); }
</style>
EOF

# Update NewsTicker.astro - keep the scrolling ticker but style for light theme
cat > src/components/NewsTicker.astro << 'EOF'
---
import { getSecurityNews } from '../lib/newsFeed.js';
const items = await getSecurityNews(10);
---
<div class="tsd-ticker" role="marquee" aria-label="Latest security news">
  <span class="tsd-ticker__label">◀ LIVE FEED</span>
  <div class="tsd-ticker__track">
    {items.concat(items).map((item) => (
      <a class="tsd-ticker__item" href={item.link} target="_blank" rel="noopener noreferrer">
        {item.title}
      </a>
    ))}
  </div>
</div>

<style>
.tsd-ticker { display: flex; align-items: center; gap: 1.5rem; overflow: hidden; background: var(--tsd-text-primary); color: var(--tsd-bg-primary); padding: 0.5rem 0; white-space: nowrap; }
.tsd-ticker__label { font-family: var(--font-mono); font-size: 0.7rem; letter-spacing: 0.1em; font-weight: 600; flex-shrink: 0; }
.tsd-ticker__track { display: inline-flex; gap: 3rem; animation: tsd-scroll 60s linear infinite; }
.tsd-ticker__item { color: var(--tsd-bg-primary); font-family: var(--font-mono); font-size: 0.75rem; text-decoration: none; }
.tsd-ticker__item:hover { text-decoration: underline; }
@keyframes tsd-scroll { from { transform: translateX(0); } to { transform: translateX(-50%); } }
</style>
EOF

# Update Footer.astro
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
.tsd-footer { background: var(--tsd-text-primary); color: var(--tsd-bg-primary); padding: 3rem 0 1.5rem; margin-top: 4rem; }
.tsd-footer__grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; }
.tsd-footer__grid h3 { font-size: 0.85rem; color: var(--tsd-accent-cyan); margin: 0 0 0.75rem 0; }
.tsd-footer__grid a { display: block; color: rgba(255,255,255,0.7); text-decoration: none; font-size: 0.9rem; margin-bottom: 0.5rem; }
.tsd-footer__grid a:hover { color: var(--tsd-accent-cyan); }
.tsd-footer__copy { text-align: center; color: rgba(255,255,255,0.5); font-size: 0.8rem; margin-top: 2rem; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 1rem; }
</style>
EOF

# Update ArticleCard.astro
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
.tsd-card { display: block; text-decoration: none; color: inherit; background: var(--tsd-bg-secondary); border: 1px solid var(--tsd-border-light); border-radius: 6px; overflow: hidden; transition: transform 0.2s, box-shadow 0.2s; }
.tsd-card:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
.tsd-card img { width: 100%; height: 180px; object-fit: cover; background: var(--tsd-bg-tertiary); }
.tsd-card__body { padding: 1.25rem; }
.tsd-card h3 { font-size: 1.1rem; margin: 0.75rem 0 0.5rem 0; line-height: 1.3; }
.tsd-card p { margin: 0.5rem 0; color: var(--tsd-text-secondary); font-size: 0.9rem; }
.tsd-card__meta { display: block; margin-top: 0.75rem; font-size: 0.8rem; color: var(--tsd-text-muted); }
</style>
EOF

# Create new HomePage
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
      <p>Where knowledge becomes your first defence. Independent threat intelligence, vulnerability analysis, and security research — curated for practitioners.</p>
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
        </div>
        <div class="tsd-terminal__body">
          <div>$ ./scan --live --firewall</div>
          <div>✓ Connected to threat feed</div>
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
    <blockquote>"Security is not a product to be bought — <em>it is</em> a discipline to be practised. We exist to share the knowledge that makes that discipline possible."</blockquote>
  </section>

  <!-- Latest Threats -->
  {threatIntel.length > 0 && (
    <section class="tsd-section">
      <div class="tsd-container">
        <div class="tsd-section__header">
          <h2>Latest Threats</h2>
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
          <span class="tsd-label">Knowledge Base</span>
          <h2>Featured Articles</h2>
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
  gap: 3rem;
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
  color: var(--tsd-accent-cyan);
  display: block;
  margin-bottom: 1rem;
}
.tsd-hero h1 {
  font-size: 3rem;
  line-height: 1.1;
  margin: 0 0 1.5rem 0;
}
.tsd-accent { color: var(--tsd-accent-cyan); font-style: italic; }
.tsd-hero > div > p {
  font-size: 1.1rem;
  color: var(--tsd-text-secondary);
  margin-bottom: 2rem;
  line-height: 1.7;
}
.tsd-hero__cta {
  display: flex;
  gap: 1rem;
}
.tsd-btn {
  font-family: var(--font-mono);
  font-size: 0.8rem;
  letter-spacing: 0.05em;
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  text-transform: uppercase;
  font-weight: 600;
}
.tsd-btn--primary {
  background: var(--tsd-accent-cyan);
  color: var(--tsd-bg-primary);
}
.tsd-btn--primary:hover {
  background: var(--tsd-accent-cyan-dark);
}
.tsd-search {
  padding: 0.75rem 1rem;
  border: 2px solid var(--tsd-border-light);
  border-radius: 4px;
  font-size: 0.9rem;
  font-family: var(--font-body);
  flex: 1;
}
.tsd-hero__visual {
  display: flex;
  justify-content: center;
}
.tsd-terminal {
  background: var(--tsd-text-primary);
  color: var(--tsd-accent-cyan);
  padding: 1rem;
  border-radius: 6px;
  font-family: var(--font-mono);
  font-size: 0.85rem;
  width: 100%;
  max-width: 400px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.2);
}
.tsd-terminal__header {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem;
  padding-bottom: 0.75rem;
  border-bottom: 1px solid rgba(0,168,255,0.2);
}
.dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: var(--tsd-accent-cyan);
  opacity: 0.3;
}
.tsd-terminal__body div {
  margin: 0.5rem 0;
  line-height: 1.4;
}
.blink {
  animation: blink 1s infinite;
}
@keyframes blink { 0%, 50% { opacity: 1; } 51%, 100% { opacity: 0.3; } }

.tsd-stats {
  background: var(--tsd-bg-tertiary);
  padding: 3rem 0;
  margin: 2rem 0;
  border-top: 1px solid var(--tsd-border-light);
  border-bottom: 1px solid var(--tsd-border-light);
}
.tsd-stats .tsd-container {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 2rem;
  text-align: center;
}
.tsd-stat__value {
  font-family: var(--font-display);
  font-size: 2rem;
  font-weight: 700;
  color: var(--tsd-accent-cyan);
  margin-bottom: 0.5rem;
}
.tsd-stat__label {
  font-size: 0.9rem;
  color: var(--tsd-text-secondary);
  font-family: var(--font-mono);
  letter-spacing: 0.05em;
}

.tsd-quote {
  background: var(--tsd-accent-cyan);
  color: var(--tsd-bg-primary);
  padding: 3rem 1.5rem;
  text-align: center;
  margin: 2rem 0;
  border-radius: 6px;
}
.tsd-quote blockquote {
  font-family: var(--font-display);
  font-size: 1.5rem;
  font-style: italic;
  margin: 0;
  line-height: 1.6;
}
.tsd-quote em {
  font-style: normal;
  font-weight: 700;
}

.tsd-section {
  padding: 3rem 0;
}
.tsd-section__header {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  margin-bottom: 2rem;
}
.tsd-section h2 {
  font-size: 2rem;
  margin: 0;
}
.tsd-link {
  color: var(--tsd-accent-cyan);
  font-family: var(--font-mono);
  font-size: 0.85rem;
  letter-spacing: 0.05em;
}

.tsd-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
}

@media (max-width: 768px) {
  .tsd-hero { grid-template-columns: 1fr; }
  .tsd-hero h1 { font-size: 2rem; }
  .tsd-stats .tsd-container { grid-template-columns: repeat(2, 1fr); }
  .tsd-grid { grid-template-columns: 1fr; }
}
</style>
EOF

# Update BaseLayout.astro
cat > src/layouts/BaseLayout.astro << 'EOF'
---
import Header from '../components/Header.astro';
import Footer from '../components/Footer.astro';
import '../styles/tokens.css';
import '../styles/global.css';

const { title = 'The Security Desk', description = 'Security news and threat intelligence.' } = Astro.props;
---
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>{title}</title>
  <meta name="description" content={description} />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=IBM+Plex+Mono:wght@400;500&family=Source+Sans+3:wght@400;600&display=swap" rel="stylesheet" />
</head>
<body>
  <Header />
  <main class="tsd-container">
    <slot />
  </main>
  <Footer />
</body>
</html>
EOF

# Update articles list page
cat > src/pages/articles/\[\.\.\.\page\].astro << 'EOF'
---
import BaseLayout from '../../layouts/BaseLayout.astro';
import ArticleCard from '../../components/ArticleCard.astro';
import { getArticles } from '../../lib/strapi.js';

export async function getStaticPaths({ paginate }) {
  const articles = await getArticles();
  return paginate(articles, { pageSize: 9 });
}

const { page } = Astro.props;
---
<BaseLayout title="Articles | The Security Desk">
  <section class="tsd-articles-header">
    <span class="tsd-label">Knowledge Base • Research • Tutorials</span>
    <h1>Articles & Analysis</h1>
    <p>In-depth security research, tradecraft walkthroughs, and field intelligence — written to be read, not skimmed.</p>
  </section>

  <div class="tsd-articles-filter">
    <label>Filter by topic: 
      <select>
        <option>Any</option>
        <option>Threat Intelligence</option>
        <option>Vulnerabilities</option>
        <option>Malware Analysis</option>
        <option>Industry News</option>
      </select>
    </label>
    <button>Apply</button>
  </div>

  <section class="tsd-grid">
    {page.data.map((article) => <ArticleCard article={article} />)}
  </section>

  <nav class="tsd-pagination">
    {page.url.prev && <a href={page.url.prev}>← Newer</a>}
    <span>Page {page.currentPage} of {page.lastPage}</span>
    {page.url.next && <a href={page.url.next}>Older →</a>}
  </nav>
</BaseLayout>

<style>
.tsd-articles-header {
  text-align: center;
  padding: 3rem 0;
  border-bottom: 1px solid var(--tsd-border-light);
  margin-bottom: 2rem;
}
.tsd-articles-header h1 {
  font-size: 2.5rem;
  margin: 1rem 0;
}
.tsd-articles-header p {
  font-size: 1.1rem;
  color: var(--tsd-text-secondary);
  max-width: 600px;
  margin: 1rem auto 0;
}

.tsd-articles-filter {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 2rem;
  padding: 1rem 0;
}
.tsd-articles-filter label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.9rem;
}
.tsd-articles-filter select {
  padding: 0.5rem;
  border: 1px solid var(--tsd-border-light);
  border-radius: 4px;
  font-family: var(--font-body);
}
.tsd-articles-filter button {
  padding: 0.5rem 1.5rem;
  background: var(--tsd-bg-secondary);
  border: 1px solid var(--tsd-border-light);
  border-radius: 4px;
  cursor: pointer;
  font-family: var(--font-body);
}
.tsd-articles-filter button:hover {
  background: var(--tsd-bg-tertiary);
}

.tsd-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
  margin-bottom: 3rem;
}

.tsd-pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1.5rem;
  padding: 2rem 0;
  font-family: var(--font-mono);
  font-size: 0.9rem;
}
.tsd-pagination a {
  color: var(--tsd-accent-cyan);
  padding: 0.5rem 1rem;
  border: 1px solid var(--tsd-border-light);
  border-radius: 4px;
}
.tsd-pagination a:hover {
  background: var(--tsd-bg-secondary);
}

@media (max-width: 768px) {
  .tsd-grid { grid-template-columns: 1fr; }
  .tsd-articles-header h1 { font-size: 1.8rem; }
}
</style>
EOF

# Update article detail page
cat > src/pages/articles/\[slug\].astro << 'EOF'
---
import BaseLayout from '../../layouts/BaseLayout.astro';
import { getArticles, getArticleBySlug } from '../../lib/strapi.js';
import { marked } from 'marked';

export async function getStaticPaths() {
  const articles = await getArticles();
  return articles.map((a) => ({ params: { slug: a.slug } }));
}

const { slug } = Astro.params;
const article = await getArticleBySlug(slug);

// Calculate reading time (rough estimate: 200 words per minute)
const wordCount = article.body ? article.body.split(/\s+/).length : 0;
const readingTime = Math.max(1, Math.round(wordCount / 200));
---
<BaseLayout title={article.title} description={article.excerpt}>
  <article class="tsd-article">
    <div class="tsd-article__header">
      <a href="/articles" class="tsd-back">← Back to Articles</a>
      <span class="tsd-label">Article</span>
      <h1>{article.title}</h1>
      <div class="tsd-article__meta">
        <img src={`https://api.dicebear.com/7.x/avataaars/svg?seed=${article.author}`} alt={article.author} class="tsd-avatar" />
        <div>
          <div class="tsd-author">{article.author}</div>
          <div class="tsd-date">{new Date(article.publishedDate).toLocaleDateString()}</div>
        </div>
      </div>
    </div>

    {article.imageUrl && <img src={article.imageUrl} alt={article.title} class="tsd-featured-image" />}

    <div class="tsd-article__body">
      <div class="tsd-article__content" set:html={marked.parse(article.body || '')} />
      
      <aside class="tsd-article__sidebar">
        <div class="tsd-sidebar-card">
          <div class="tsd-card-label">Published</div>
          <div class="tsd-card-value">{new Date(article.publishedDate).toLocaleDateString()}</div>
        </div>
        
        <div class="tsd-sidebar-card">
          <div class="tsd-card-label">Category</div>
          <div class="tsd-card-value"><a href="#">{article.category}</a></div>
        </div>
        
        <div class="tsd-sidebar-card">
          <div class="tsd-card-label">Reading Time</div>
          <div class="tsd-card-value">{readingTime} MIN READ</div>
        </div>

        <div class="tsd-sidebar-card tsd-author-bio">
          <img src={`https://api.dicebear.com/7.x/avataaars/svg?seed=${article.author}`} alt={article.author} />
          <h4>{article.author}</h4>
          <p class="tsd-role">Security Analyst</p>
          <p>Independent cybersecurity researcher and writer at The Security Desk, focusing on threat intelligence, security, and defensive operations.</p>
        </div>

        <div class="tsd-sidebar-card tsd-share">
          <div class="tsd-card-label">Share</div>
          <a href="#" class="tsd-share-btn">𝕏 Twitter</a>
          <a href="#" class="tsd-share-btn">in LinkedIn</a>
          <a href="#" class="tsd-share-btn">⚡ Copy Link</a>
        </div>
      </aside>
    </div>
  </article>
</BaseLayout>

<style>
.tsd-article {
  padding: 3rem 0;
}
.tsd-article__header {
  margin-bottom: 2rem;
  padding-bottom: 2rem;
  border-bottom: 1px solid var(--tsd-border-light);
}
.tsd-back {
  font-family: var(--font-mono);
  font-size: 0.8rem;
  letter-spacing: 0.05em;
  color: var(--tsd-text-secondary);
  text-decoration: none;
  display: block;
  margin-bottom: 1rem;
}
.tsd-back:hover {
  color: var(--tsd-accent-cyan);
}
.tsd-article__header h1 {
  font-size: 2.5rem;
  line-height: 1.2;
  margin: 1rem 0;
}
.tsd-article__meta {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-top: 1.5rem;
}
.tsd-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: var(--tsd-bg-tertiary);
}
.tsd-author {
  font-weight: 600;
  color: var(--tsd-text-primary);
}
.tsd-date {
  font-size: 0.85rem;
  color: var(--tsd-text-muted);
}

.tsd-featured-image {
  width: 100%;
  border-radius: 6px;
  margin: 2rem 0;
  max-height: 400px;
  object-fit: cover;
}

.tsd-article__body {
  display: grid;
  grid-template-columns: 1fr 300px;
  gap: 3rem;
  max-width: 1000px;
}
.tsd-article__content {
  font-size: 1.05rem;
  line-height: 1.8;
  color: var(--tsd-text-secondary);
}
.tsd-article__content h2 {
  font-size: 1.8rem;
  margin-top: 2rem;
  margin-bottom: 1rem;
  color: var(--tsd-text-primary);
}
.tsd-article__content p {
  margin-bottom: 1rem;
}

.tsd-article__sidebar {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}
.tsd-sidebar-card {
  background: var(--tsd-bg-secondary);
  border: 1px solid var(--tsd-border-light);
  padding: 1.25rem;
  border-radius: 6px;
}
.tsd-card-label {
  font-family: var(--font-mono);
  font-size: 0.7rem;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--tsd-accent-cyan);
  margin-bottom: 0.5rem;
}
.tsd-card-value {
  font-family: var(--font-display);
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--tsd-text-primary);
}
.tsd-card-value a {
  color: var(--tsd-accent-cyan);
}

.tsd-author-bio {
  text-align: center;
}
.tsd-author-bio img {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  margin: 0 auto 1rem;
  background: var(--tsd-bg-tertiary);
}
.tsd-author-bio h4 {
  margin: 0 0 0.25rem 0;
  font-size: 1rem;
}
.tsd-role {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  color: var(--tsd-accent-cyan);
  margin: 0 0 0.75rem 0;
}
.tsd-author-bio p {
  font-size: 0.9rem;
  margin: 0 0 0.5rem 0;
  color: var(--tsd-text-secondary);
}

.tsd-share {
  text-align: center;
}
.tsd-share-btn {
  display: block;
  padding: 0.75rem;
  border: 1px solid var(--tsd-border-light);
  border-radius: 4px;
  margin: 0.5rem 0;
  font-size: 0.9rem;
  text-decoration: none;
  color: var(--tsd-accent-cyan);
  transition: background 0.2s;
}
.tsd-share-btn:hover {
  background: var(--tsd-bg-tertiary);
}

@media (max-width: 768px) {
  .tsd-article__body {
    grid-template-columns: 1fr;
  }
  .tsd-article__header h1 {
    font-size: 1.8rem;
  }
}
</style>
EOF

# Update contact page
cat > src/pages/contact.astro << 'EOF'
---
import BaseLayout from '../layouts/BaseLayout.astro';
---
<BaseLayout title="Contact | The Security Desk">
  <section class="tsd-contact">
    <h1>Contact Us</h1>
    <p class="tsd-contact__subtitle">Have a question, tip, or want to collaborate? We are here to help.</p>

    <div class="tsd-contact__grid">
      <div class="tsd-contact__form-box">
        <h2>Send us a message</h2>
        <p>Do you have a question? A vulnerability to report? Or need help with a collaboration? Feel free to contact us.</p>
        
        <form name="contact" method="POST" data-netlify="true" class="tsd-form">
          <input type="hidden" name="form-name" value="contact" />
          
          <div class="tsd-form__group">
            <label>Name</label>
            <input type="text" name="name" placeholder="Enter your name" required />
          </div>

          <div class="tsd-form__group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="your@email.com" required />
          </div>

          <div class="tsd-form__group">
            <label>Subject</label>
            <select name="subject" required>
              <option value="">- Select -</option>
              <option value="vulnerability">Vulnerability Report</option>
              <option value="collaboration">Collaboration</option>
              <option value="feedback">Feedback</option>
              <option value="other">Other</option>
            </select>
          </div>

          <div class="tsd-form__group">
            <label>Message</label>
            <textarea name="message" placeholder="Enter your message..." rows="6" required></textarea>
          </div>

          <button type="submit" class="tsd-btn tsd-btn--primary">Send a Message</button>
          <p class="tsd-form__note">Note: We typically respond within 24-48 hours. For urgent disclosures, please mark the subject accordingly.</p>
        </form>
      </div>

      <div class="tsd-contact__info">
        <h2>We are always here to help you.</h2>
        
        <div class="tsd-info-card">
          <div class="tsd-info-card__icon">⏱</div>
          <div class="tsd-info-card__label">Response Time</div>
          <div class="tsd-info-card__value">Within 24-48 hours</div>
        </div>

        <div class="tsd-info-card">
          <div class="tsd-info-card__icon">🔒</div>
          <div class="tsd-info-card__label">Responsible Disclosure</div>
          <div class="tsd-info-card__value">Coordinated vulnerability handling</div>
        </div>

        <div class="tsd-info-card">
          <div class="tsd-info-card__icon">✉️</div>
          <div class="tsd-info-card__label">Email</div>
          <div class="tsd-info-card__value">info@thesecuritydesk.com</div>
        </div>

        <div class="tsd-info-card">
          <div class="tsd-info-card__icon">🔑</div>
          <div class="tsd-info-card__label">PGP Key</div>
          <div class="tsd-info-card__value">Available on request</div>
        </div>

        <div class="tsd-contact__connect">
          <h3>Connect With Us</h3>
          <a href="#" class="tsd-social-btn">GitHub</a>
          <a href="#" class="tsd-social-btn">Mastodon</a>
          <a href="#" class="tsd-social-btn">RSS</a>
        </div>
      </div>
    </div>
  </section>
</BaseLayout>

<style>
.tsd-contact {
  padding: 3rem 0;
}
.tsd-contact h1 {
  font-size: 2.5rem;
  text-align: center;
  margin-bottom: 0.5rem;
}
.tsd-contact__subtitle {
  text-align: center;
  font-size: 1.1rem;
  color: var(--tsd-text-secondary);
  margin-bottom: 3rem;
  max-width: 600px;
  margin-left: auto;
  margin-right: auto;
}

.tsd-contact__grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
}

.tsd-contact__form-box h2,
.tsd-contact__info h2 {
  font-size: 1.5rem;
  margin: 0 0 1rem 0;
}

.tsd-contact__form-box > p {
  color: var(--tsd-text-secondary);
  margin-bottom: 2rem;
}

.tsd-form__group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  margin-bottom: 1.5rem;
}
.tsd-form__group label {
  font-family: var(--font-mono);
  font-size: 0.8rem;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  color: var(--tsd-text-secondary);
}
.tsd-form__group input,
.tsd-form__group select,
.tsd-form__group textarea {
  padding: 0.75rem;
  border: 1px solid var(--tsd-border-light);
  border-radius: 4px;
  font-family: var(--font-body);
  font-size: 0.95rem;
  background: var(--tsd-bg-secondary);
  color: var(--tsd-text-primary);
}
.tsd-form__note {
  font-size: 0.8rem;
  color: var(--tsd-text-muted);
  margin-top: 1rem;
  padding: 1rem;
  background: var(--tsd-bg-tertiary);
  border-left: 3px solid var(--tsd-accent-cyan);
  border-radius: 4px;
}

.tsd-info-card {
  background: var(--tsd-bg-secondary);
  border: 1px solid var(--tsd-border-light);
  border-left: 3px solid var(--tsd-accent-cyan);
  padding: 1.25rem;
  border-radius: 6px;
  margin-bottom: 1rem;
}
.tsd-info-card__icon {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
}
.tsd-info-card__label {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  color: var(--tsd-accent-cyan);
  margin-bottom: 0.25rem;
}
.tsd-info-card__value {
  font-weight: 600;
  color: var(--tsd-text-primary);
}

.tsd-contact__connect {
  margin-top: 2rem;
  padding-top: 2rem;
  border-top: 1px solid var(--tsd-border-light);
}
.tsd-contact__connect h3 {
  font-size: 1rem;
  margin: 0 0 1rem 0;
}
.tsd-social-btn {
  display: inline-block;
  padding: 0.6rem 1.2rem;
  background: var(--tsd-bg-secondary);
  border: 1px solid var(--tsd-border-light);
  border-radius: 4px;
  margin-right: 0.5rem;
  margin-bottom: 0.5rem;
  text-decoration: none;
  font-size: 0.85rem;
  transition: all 0.2s;
}
.tsd-social-btn:hover {
  background: var(--tsd-accent-cyan);
  color: var(--tsd-bg-primary);
  border-color: var(--tsd-accent-cyan);
}

@media (max-width: 768px) {
  .tsd-contact__grid {
    grid-template-columns: 1fr;
  }
  .tsd-contact h1 {
    font-size: 1.8rem;
  }
}
</style>
EOF

# Update threat-intel.astro
cat > src/pages/threat-intel.astro << 'EOF'
---
import BaseLayout from '../layouts/BaseLayout.astro';
import ArticleCard from '../components/ArticleCard.astro';
import { getArticlesByCategory } from '../lib/strapi.js';

const articles = await getArticlesByCategory('threat-intelligence');
---
<BaseLayout title="Threat Intel | The Security Desk">
  <section class="tsd-articles-header">
    <span class="tsd-label">Threat Intelligence</span>
    <h1>Latest Threats</h1>
    <p>Real-time threat intelligence and analysis of emerging threats, vulnerabilities, and security incidents.</p>
  </section>

  <section class="tsd-grid">
    {articles.length > 0 ? (
      articles.map((article) => <ArticleCard article={article} />)
    ) : (
      <p>No threat intelligence articles yet. Check back soon!</p>
    )}
  </section>
</BaseLayout>

<style>
.tsd-articles-header {
  text-align: center;
  padding: 3rem 0;
  border-bottom: 1px solid var(--tsd-border-light);
  margin-bottom: 2rem;
}
.tsd-articles-header h1 {
  font-size: 2.5rem;
  margin: 1rem 0;
}
.tsd-articles-header p {
  font-size: 1.1rem;
  color: var(--tsd-text-secondary);
  max-width: 600px;
  margin: 1rem auto 0;
}

.tsd-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
  margin-bottom: 3rem;
}

@media (max-width: 768px) {
  .tsd-grid { grid-template-columns: 1fr; }
}
</style>
EOF

echo "✅ Design rebuild complete!"
