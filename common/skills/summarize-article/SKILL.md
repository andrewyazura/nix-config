---
name: summarize-article
description: Summarize an article and, for Hacker News, Lobsters or Reddit links, the substantive points of its discussion thread.
argument-hint: <article-or-discussion-url> [discussion-url]
disable-model-invocation: true
---
# Summarize Article

Summarize the URL or URLs passed with this command: the article without its fluff, plus the substantive discussion when there is a thread.

## 1. Fetch

Fetch raw content. A fetch tool that returns a model-written summary or truncates the page loses most of a thread, so fetch threads with `curl` and `jq`.

- **Hacker News** (`news.ycombinator.com/item?id=<id>`):
  - `curl -s https://hn.algolia.com/api/v1/items/<id>` returns the story (`title`, `url`, `author`, `points`, `created_at`, `text`) and the whole comment tree in one request. Comments are not in HN's ranked order.
  - Flatten the comments before reading them: `jq -r '.. | objects | select(.type == "comment" and .text != null) | "\(.author): \(.text)"'`.
  - Comment count: `curl -s https://hacker-news.firebaseio.com/v0/item/<id>.json | jq .descendants`.
- **Lobsters** (`lobste.rs/s/<id>`): `curl -s https://lobste.rs/s/<id>.json` returns `title`, `url`, `score`, `comment_count`, `created_at`, `description_plain`, and `comments` with `commenting_user`, `depth` and `comment_plain`.
- **Reddit**: unauthenticated requests are blocked (`.json` returns 403, `old.reddit.com` redirects to a login page, `www.reddit.com` returns a script-only shell). Try the fetch tool once; if it returns no comments, report that the thread could not be read.
- **Article**: the story's `url`. When a discussion has no external link (Ask HN, Show HN text posts, Reddit text posts), the post text is the article.
- A direct article link: read only the article, unless a discussion URL is passed with it.

If the article cannot be read (paywall, 403, script-only page), say so at the top of the summary and summarize only what was read. Never reconstruct an article from its title or from the comments.

## 2. Filter

- **Article**:
  - Strip personal preambles ("I was sitting with my coffee thinking..."), promotional intros, sponsor spots and boilerplate.
  - Keep only the core thesis, underlying mechanisms, concrete benchmarks and evidence, and architecture.
- **Discussion**:
  - Ignore low-effort reactions ("great read!", "+1", generic snark).
  - Extract substantive technical critique, production counter-examples, historical parallels, missing literature and edge-case corrections.
  - Group comments by theme, not chronologically.

## 3. Output

- Take every metadata field from the fetched data. Write `unknown` for a field that is not available; never infer it.
- Omit the **Discussion** line and section 2 when there is no thread.
- Write the markdown directly, not inside a code block.

```markdown
# [Article Title]
- **Author**: [Author name, or publication]
- **Date**: [YYYY-MM-DD]
- **URL**: [Article URL]
- **Discussion**: [Discussion URL] ([Points] points, [Comments] comments)
---
## 1. Essential Article Summary
[Dense core distillation: problem, thesis, mechanisms and concrete takeaways.]
---
## 2. Top Community Insights & Discussion
### [Theme / Counter-Argument 1]
- [Insight, evidence cited by commenters, technical corrections]
### [Theme / Counter-Argument 2]
- [Insight]
```
