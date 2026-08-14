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
