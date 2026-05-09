# Blog: Operational Notes

Learnings and conventions for the LTS (Learn, Tinker, Share) Hugo blog. See also [STYLE.md](STYLE.md) for writing and visual style.

## Images

Two distinct locations serve different purposes:

- **`static/images/`** — card previews (`featureimage` in frontmatter) and inline article images (`![](/images/foo.png)`). Served directly, no processing.
- **`assets/images/`** — required when using `showHero: true`. Blowfish's hero partials use `resources.Get`, which only looks in `assets/`, not `static/`. Copy to both locations when a hero is needed.

Hero is opt-in per article:
```yaml
featureimage: /images/foo.png
showHero: true
heroStyle: basic   # options: basic, big, background, thumbAndBackground
```

Note: the `basic` hero is intentionally full-width. If that's unwanted, embed the image inline at the top of the article body instead — it will respect the prose width.

## Diagrams

- Use Excalidraw for all diagrams. Rough, hand-drawn aesthetic is intentional (see STYLE.md).
- Save `.excalidraw` files to `Excalidraw/` and exported PNGs to `static/images/`.
- Every diagram needs a short caption or surrounding text — don't leave visuals to speak alone.

## Draft Management

- Drafts live in `content/posts/` with `draft: true` in frontmatter.
- Preview drafts locally: `hugo server -D` (the `-D` flag includes drafts).
- To publish: set `draft: false` (or remove the field).

## Audio Transcription (voice notes → diary)

```bash
uvx --from openai-whisper whisper "<file.mp3>" --model small --output_dir /tmp/whisper-out/
```

First run downloads deps (~2.5GB); subsequent runs use cache. Output is `.txt`, `.srt`, etc.

## Commit Convention

```
Authored-By: Claude Sonnet 4.6, Charles Thayer
```

## Local Dev

```bash
hugo server -D   # serve with drafts
```

Kill with `pkill -f hugo` when done.
