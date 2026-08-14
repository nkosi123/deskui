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
