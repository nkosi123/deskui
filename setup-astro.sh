#!/bin/bash

# Create directories
mkdir -p src/styles src/lib src/components src/layouts src/pages/articles

# astro.config.mjs
cat > astro.config.mjs << 'EOF'
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://www.thandaninkoski.co.za',
  integrations: [sitemap()],
});
EOF

# .env.example
cat > .env.example << 'EOF'
STRAPI_URL=https://your-strapi-instance.example.com
STRAPI_API_TOKEN=replace_with_read_only_api_token
EOF

# src/styles/tokens.css
cat > src/styles/tokens.css << 'EOF'
:root {
  --tsd-navy: #0A1628;
  --tsd-navy-light: #0F1E36;
  --tsd-cyan: #00A8FF;
  --tsd-white: #F5F7FA;
  --tsd-muted: #8A94A6;
  --tsd-line: rgba(255, 255, 255, 0.08);

  --font-display: 'Playfair Display', serif;
  --font-mono: 'IBM Plex Mono', monospace;
  --font-body: 'Source Sans 3', sans-serif;
}
EOF

# src/styles/global.css
cat > src/styles/global.css << 'EOF'
* { box-sizing: border-box; }
html, body { margin: 0; padding: 0; }
body {
  background: var(--tsd-navy);
  color: var(--tsd-white);
  font-family: var(--font-body);
  line-height: 1.6;
}
h1, h2, h3 { font-family: var(--font-display); font-weight: 700; }
a { color: inherit; }
.tsd-container { max-width: 1180px; margin: 0 auto; padding: 0 1.5rem; }
.tsd-tag {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  color: var(--tsd-cyan);
}
EOF

# src/lib/strapi.js
cat > src/lib/strapi.js << 'EOF'
const STRAPI_URL = import.meta.env.STRAPI_URL;
const STRAPI_API_TOKEN = import.meta.env.STRAPI_API_TOKEN;

async function strapiFetch(path) {
  const res = await fetch(`${STRAPI_URL}/api${path}`, {
    headers: STRAPI_API_TOKEN ? { Authorization: `Bearer ${STRAPI_API_TOKEN}` } : {},
  });
  if (!res.ok) throw new Error(`Strapi request failed: ${res.status} ${path}`);
  const json = await res.json();
  return json.data;
}

export async function getArticles() {
  const data = await strapiFetch('/articles?populate=featuredImage&sort=publishedDate:desc');
  return data.map(normalizeArticle);
}

export async function getArticlesByCategory(category) {
  const data = await strapiFetch(
    `/articles?populate=featuredImage&filters[category][$eq]=${category}&sort=publishedDate:desc`
  );
  return data.map(normalizeArticle);
}

export async function getArticleBySlug(slug) {
  const data = await strapiFetch(`/articles?populate=featuredImage&filters[slug][$eq]=${slug}`);
  return data.length ? normalizeArticle(data[0]) : null;
}

function normalizeArticle(entry) {
  const a = entry.attributes;
  return {
    id: entry.id,
    title: a.title,
    slug: a.slug,
    excerpt: a.excerpt,
    body: a.body,
    author: a.author,
    category: a.category,
    publishedDate: a.publishedDate,
    imageUrl: a.featuredImage?.data?.attributes?.url
      ? `${STRAPI_URL}${a.featuredImage.data.attributes.url}`
      : null,
  };
}
EOF

# src/lib/newsFeed.js
cat > src/lib/newsFeed.js << 'EOF'
import Parser from 'rss-parser';

const FEED_URL = 'https://www.bleepingcomputer.com/feed/';
const parser = new Parser();

export async function getSecurityNews(limit = 10) {
  try {
    const feed = await parser.parseURL(FEED_URL);
    return feed.items.slice(0, limit).map((item) => ({
      title: item.title,
      link: item.link,
      pubDate: item.pubDate,
    }));
  } catch (err) {
    console.error('Failed to load security news feed:', err);
    return [];
  }
}
EOF

# src/components/Logo.astro
cat > src/components/Logo.astro << 'EOF'
---
// src/components/Logo.astro
---
<span class="tsd-logo">
  <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="var(--tsd-cyan)" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round">
    <rect x="2" y="3" width="20" height="14" rx="2"/>
    <path d="M8 21h8M12 17v4"/>
  </svg>
  <span class="tsd-logo__text">
    <span class="tsd-logo__pre">The</span>
    <span class="tsd-logo__main">Security Desk</span>
  </span>
</span>

<style>
.tsd-logo { display: inline-flex; align-items: center; gap: 0.6rem; }
.tsd-logo__text { display: flex; flex-direction: column; line-height: 1; }
.tsd-logo__pre { font-family: var(--font-mono); font-size: 0.65rem; color: var(--tsd-muted); letter-spacing: 0.08em; text-transform: uppercase; }
.tsd-logo__main { font-family: var(--font-display); font-size: 1.15rem; font-weight: 700; color: var(--tsd-white); }
</style>
EOF

# src/components/Header.astro
cat > src/components/Header.astro << 'EOF'
---
import Logo from './Logo.astro';
import NewsTicker from './NewsTicker.astro';

const navItems = [
  { label: 'Home', href: '/' },
  { label: 'Articles', href: '/articles' },
  { label: 'Threat Intel', href: '/threat-intel' },
  { label: 'Contact', href: '/contact' },
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
.tsd-header__bar { display: flex; align-items: center; justify-content: space-between; padding: 1.25rem 0; }
.tsd-header__nav { display: flex; gap: 1.75rem; font-family: var(--font-mono); font-size: 0.9rem; }
.tsd-header__nav a { text-decoration: none; color: var(--tsd-muted); }
.tsd-header__nav a:hover { color: var(--tsd-cyan); }
</style>
EOF

# src/components/Footer.astro
cat > src/components/Footer.astro << 'EOF'
---
const footerNav = [
  { label: 'Home', href: '/' },
  { label: 'Articles', href: '/articles' },
  { label: 'Threat Intel', href: '/threat-intel' },
  { label: 'Contact', href: '/contact' },
];
const connectLinks = [
  { label: 'GitHub', href: 'https://github.com/your-handle' },
  { label: 'Mastodon', href: 'https://infosec.exchange/@your-handle' },
];
const topicLinks = [
  { label: 'Threat Intelligence', href: '/threat-intel' },
  { label: 'Vulnerabilities', href: '/articles?category=vulnerabilities' },
];
---
<footer class="tsd-footer">
  <div class="tsd-container tsd-footer__grid">
    <div>
      <h3>Navigation</h3>
      {footerNav.map((item) => <a href={item.href}>{item.label}</a>)}
    </div>
    <div>
      <h3>Connect</h3>
      {connectLinks.map((item) => <a href={item.href} target="_blank" rel="noopener noreferrer">{item.label}</a>)}
    </div>
    <div>
      <h3>Topics</h3>
      {topicLinks.map((item) => <a href={item.href}>{item.label}</a>)}
    </div>
  </div>
  <p class="tsd-footer__copy">© {new Date().getFullYear()} The Security Desk</p>
</footer>

<style>
.tsd-footer { border-top: 1px solid var(--tsd-line); padding: 3rem 0 1.5rem; margin-top: 4rem; }
.tsd-footer__grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2rem; }
.tsd-footer__grid h3 { font-size: 0.85rem; color: var(--tsd-cyan); margin-bottom: 0.75rem; }
.tsd-footer__grid a { display: block; color: var(--tsd-muted); text-decoration: none; font-size: 0.9rem; margin-bottom: 0.4rem; }
.tsd-footer__copy { text-align: center; color: var(--tsd-muted); font-size: 0.8rem; margin-top: 2rem; }
</style>
EOF

# src/components/NewsTicker.astro
cat > src/components/NewsTicker.astro << 'EOF'
---
import { getSecurityNews } from '../lib/newsFeed.js';
const items = await getSecurityNews(10);
---
<div class="tsd-ticker" role="marquee" aria-label="Latest security news">
  <div class="tsd-ticker__track">
    {items.concat(items).map((item) => (
      <a class="tsd-ticker__item" href={item.link} target="_blank" rel="noopener noreferrer">
        {item.title}
      </a>
    ))}
  </div>
</div>

<style>
.tsd-ticker { overflow: hidden; background: var(--tsd-navy-light); border-top: 1px solid var(--tsd-line); border-bottom: 1px solid var(--tsd-line); white-space: nowrap; }
.tsd-ticker__track { display: inline-flex; gap: 3rem; padding: 0.5rem 0; animation: tsd-scroll 60s linear infinite; }
.tsd-ticker__item { color: var(--tsd-muted); font-family: var(--font-mono); font-size: 0.85rem; text-decoration: none; }
.tsd-ticker__item:hover { color: var(--tsd-cyan); }
@keyframes tsd-scroll { from { transform: translateX(0); } to { transform: translateX(-50%); } }
</style>
EOF

# src/components/ArticleCard.astro
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
    <span class="tsd-card__meta">{article.author} · {new Date(article.publishedDate).toLocaleDateString()}</span>
  </div>
</a>

<style>
.tsd-card { display: block; text-decoration: none; color: inherit; background: var(--tsd-navy-light); border: 1px solid var(--tsd-line); border-radius: 6px; overflow: hidden; }
.tsd-card img { width: 100%; height: 180px; object-fit: cover; }
.tsd-card__body { padding: 1.25rem; }
.tsd-card__meta { display: block; margin-top: 0.75rem; font-size: 0.8rem; color: var(--tsd-muted); }
</style>
EOF

# src/layouts/BaseLayout.astro
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

# src/pages/index.astro
cat > src/pages/index.astro << 'EOF'
---
import BaseLayout from '../layouts/BaseLayout.astro';
import ArticleCard from '../components/ArticleCard.astro';
import { getArticles } from '../lib/strapi.js';

const articles = await getArticles();
---
<BaseLayout title="The Security Desk">
  <section class="tsd-grid">
    {articles.map((article) => <ArticleCard article={article} />)}
  </section>
</BaseLayout>

<style>
.tsd-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; padding: 2rem 0; }
</style>
EOF

# src/pages/articles/[...page].astro
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
  <h1>Articles</h1>
  <section class="tsd-grid">
    {page.data.map((article) => <ArticleCard article={article} />)}
  </section>
  <nav class="tsd-pagination" aria-label="Articles pagination">
    {page.url.prev && <a href={page.url.prev}>← Newer</a>}
    <span class="tsd-pagination__status">Page {page.currentPage} of {page.lastPage}</span>
    {page.url.next && <a href={page.url.next}>Older →</a>}
  </nav>
</BaseLayout>

<style>
.tsd-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; padding: 1rem 0 2rem; }
.tsd-pagination { display: flex; align-items: center; justify-content: center; gap: 2rem; padding: 1.5rem 0 3rem; font-family: var(--font-mono); font-size: 0.85rem; }
.tsd-pagination a { color: var(--tsd-cyan); text-decoration: none; }
.tsd-pagination a:hover { text-decoration: underline; }
.tsd-pagination__status { color: var(--tsd-muted); }
</style>
EOF

# src/pages/articles/[slug].astro
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
---
<BaseLayout title={article.title} description={article.excerpt}>
  <article class="tsd-article">
    <span class="tsd-tag">{article.category}</span>
    <h1>{article.title}</h1>
    <p class="tsd-article__meta">{article.author} · {new Date(article.publishedDate).toLocaleDateString()}</p>
    {article.imageUrl && <img src={article.imageUrl} alt={article.title} />}
    <div class="tsd-article__body" set:html={marked.parse(article.body || '')} />
  </article>
</BaseLayout>

<style>
.tsd-article { max-width: 760px; margin: 0 auto; padding: 2rem 0; }
.tsd-article img { width: 100%; border-radius: 6px; margin: 1.5rem 0; }
.tsd-article__meta { color: var(--tsd-muted); font-family: var(--font-mono); font-size: 0.85rem; }
.tsd-article__body { line-height: 1.8; }
</style>
EOF

# src/pages/threat-intel.astro
cat > src/pages/threat-intel.astro << 'EOF'
---
import BaseLayout from '../layouts/BaseLayout.astro';
import ArticleCard from '../components/ArticleCard.astro';
import { getArticlesByCategory } from '../lib/strapi.js';

const articles = await getArticlesByCategory('threat-intelligence');
---
<BaseLayout title="Threat Intel | The Security Desk">
  <h1>Threat Intelligence</h1>
  <section class="tsd-grid">
    {articles.map((article) => <ArticleCard article={article} />)}
  </section>
</BaseLayout>

<style>
.tsd-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; padding: 1rem 0 2rem; }
</style>
EOF

# src/pages/contact.astro
cat > src/pages/contact.astro << 'EOF'
---
import BaseLayout from '../layouts/BaseLayout.astro';
---
<BaseLayout title="Contact | The Security Desk">
  <h1>Contact</h1>
  <form name="contact" method="POST" data-netlify="true" class="tsd-form">
    <input type="hidden" name="form-name" value="contact" />
    <label>Name <input type="text" name="name" required /></label>
    <label>Email <input type="email" name="email" required /></label>
    <label>Message <textarea name="message" rows="5" required></textarea></label>
    <button type="submit">Send</button>
  </form>
</BaseLayout>

<style>
.tsd-form { display: flex; flex-direction: column; gap: 1rem; max-width: 480px; padding: 1rem 0 3rem; }
.tsd-form input, .tsd-form textarea { background: var(--tsd-navy-light); border: 1px solid var(--tsd-line); color: var(--tsd-white); padding: 0.6rem; border-radius: 4px; }
.tsd-form button { background: var(--tsd-cyan); color: var(--tsd-navy); border: none; padding: 0.7rem; border-radius: 4px; font-weight: 600; cursor: pointer; }
</style>
EOF

echo "✅ Astro project setup complete!"
