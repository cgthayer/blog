# UI Debugging Principles

Lessons learned from debugging CSS override issues in Hugo/Blowfish theme.

## Key Debugging Principles

### 1. **Inspect the Actual HTML First**
Before writing CSS fixes, understand what's actually being rendered:
- Use `curl http://localhost:1313/page/ | grep -A 10 'class-name'` to see rendered HTML
- Look for inline classes (especially Tailwind utilities like `absolute`, `inset-0`, `w-full`, `h-full`)
- This reveals the real problem before writing CSS blindly

**Example:**
```bash
curl -s http://localhost:1313/posts/ | grep -A 10 'article-link--simple'
```

### 2. **CSS Specificity & !important Strategy**
- Tailwind utility classes have high specificity
- Need multiple selector variations to increase specificity:
  ```css
  .article-link--simple .thumbnail img,
  .article-link--simple img.absolute,
  .article-link--simple img.object-cover,
  .article-link--simple img { }
  ```
- Use `!important` strategically after understanding the conflict
- Don't use `!important` as first resort - understand what you're overriding

### 3. **Theme CSS Can Override Everything**
- Base theme styles can set unexpected defaults
- Always grep for base class definitions in theme files when containers behave unexpectedly:
  ```bash
  grep -r "\.thumbnail" themes/*/assets/css/
  ```
- Custom CSS loads after theme CSS, so overrides work, but may need `!important` for utility classes
- **Document theme defaults you're overriding** in comments for future maintainers

**Example issue found:**
```css
/* Theme had: .thumbnail { width: 300px; min-height: 180px; } */
/* This caused containers to be much larger than images */
```

### 4. **Container vs Content Sizing**
Common gotcha: Images are correct size, but containers have fixed dimensions.

Key properties to override:
- `width: fit-content` and `height: fit-content` only work if you also override:
  - `min-width: 0` and `min-height: 0` (remove minimum constraints)
  - Remove any fixed `width`/`height` values
- `align-items: start` prevents flex containers from stretching children vertically
- Check for `padding` and `margin` that add to container size

### 5. **Debugging Without Browser DevTools**
When browser inspection isn't available, use CLI tools:

**Inspect rendered HTML:**
```bash
curl -s http://localhost:1313/posts/ | grep -A 20 'selector'
```

**Find theme CSS definitions:**
```bash
grep -rn "\.class-name" themes/*/assets/css/
```

**Check actual image dimensions:**
```bash
file static/images/*.png
# Output: PNG image data, 1200 x 1540, 8-bit/color RGBA
```

**Search for CSS properties:**
```bash
grep -n "thumbnail" themes/blowfish/assets/css/main.css
```

### 6. **Progressive Override Approach**
Don't try to fix everything at once. Build up overrides iteratively:

1. **First pass:** Override obvious properties (position, width, height)
2. **Second pass:** Add more specific selectors when first pass doesn't work
3. **Third pass:** Find and override theme base styles
4. **Fourth pass:** Add container-level fixes (fit-content, min-width, etc.)

Each iteration reveals another layer of constraints:
- Positioning issues → `position: static !important`
- Sizing issues → `width: auto !important`, `height: auto !important`
- Container dimensions → `width: fit-content !important`, `min-height: 0 !important`

### 7. **Common CSS Override Patterns**

**Override Tailwind absolute positioning:**
```css
.selector img {
  position: static !important;
  inset: auto !important;
  top: auto !important;
  left: auto !important;
  right: auto !important;
  bottom: auto !important;
}
```

**Override fixed container sizing:**
```css
.selector .container {
  width: fit-content !important;
  height: fit-content !important;
  min-width: 0 !important;
  min-height: 0 !important;
  max-width: 150px !important;
  max-height: 100px !important;
}
```

**Natural image sizing with constraints:**
```css
.selector img {
  width: auto !important;
  height: auto !important;
  max-width: 150px !important;
  max-height: 100px !important;
  object-fit: contain !important;
}
```

## The Core Lesson

**Always trace from HTML → applied styles → theme defaults** rather than guessing at CSS fixes.

1. Inspect actual rendered HTML
2. Identify inline classes and their effects
3. Grep theme CSS for base class definitions
4. Write targeted overrides with appropriate specificity
5. Test and iterate

This systematic approach saves time and prevents CSS bloat from trial-and-error fixes.
