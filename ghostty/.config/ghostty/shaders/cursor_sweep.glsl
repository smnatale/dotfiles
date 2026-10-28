const float DURATION_HEAD = 0.10;  // seconds for the leading edge to arrive
const float DURATION_TAIL = 0.28;  // seconds for the trailing edge to arrive
const float TAIL_WIDTH    = 0.30;  // tail thickness relative to the head (0..1)
const float TRAIL_ALPHA   = 0.60;  // max opacity of the trail
const float GLOW_ALPHA    = 0;  // soft halo around the trail (0 disables)
const float MIN_TRAVEL    = 0.60;  // ignore moves shorter than this many cell heights (0.6 skips single-char typing; set to 0.0 to always animate)

float easeOutQuart(float x) {
    x = clamp(x, 0.0, 1.0);
    float y = 1.0 - x;
    return 1.0 - y * y * y * y;
}

// Segment with linearly varying radius (ra at a, rb at b).
float sdTaperedSegment(vec2 p, vec2 a, vec2 b, float ra, float rb) {
    vec2 pa = p - a;
    vec2 ba = b - a;
    float h = clamp(dot(pa, ba) / max(dot(ba, ba), 1e-6), 0.0, 1.0);
    return length(pa - ba * h) - mix(ra, rb, h);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord / iResolution.xy);

    // Animation finished (or never started): bail out.
    float t = iTime - iTimeCursorChange;
    if (t >= DURATION_TAIL) return;

    vec2 curSize  = iCurrentCursor.zw;
    vec2 prevSize = iPreviousCursor.zw;
    if (curSize.x <= 0.0 || prevSize.x <= 0.0) return;

    // iCurrentCursor.xy is the top-left corner (y up), so the centre is:
    vec2 curC  = iCurrentCursor.xy  + vec2(curSize.x,  -curSize.y)  * 0.5;
    vec2 prevC = iPreviousCursor.xy + vec2(prevSize.x, -prevSize.y) * 0.5;

    vec2 delta = curC - prevC;
    if (length(delta) < MIN_TRAVEL * curSize.y) return;

    // Leave the real cursor (and the glyph under it) untouched.
    vec2 q = abs(fragCoord - curC);
    if (q.x < curSize.x * 0.5 && q.y < curSize.y * 0.5) return;

    // Leading edge arrives fast, trailing edge lags behind -> smear.
    vec2 head = prevC + delta * easeOutQuart(t / DURATION_HEAD);
    vec2 tail = prevC + delta * easeOutQuart(t / DURATION_TAIL);

    // Cheap bounding-box rejection.
    vec2 hs = vec2(max(curSize.x * 0.5, curSize.y * 0.25), curSize.y * 0.5);
    float margin = max(hs.x, hs.y) * 2.5;
    vec2 lo = min(head, tail) - margin;
    vec2 hi = max(head, tail) + margin;
    if (any(lessThan(fragCoord, lo)) || any(greaterThan(fragCoord, hi))) return;

    // Work in cell-relative space so the head is an ellipse inscribed in the
    // cursor rectangle (no overshoot past the cursor).
    float d = sdTaperedSegment(fragCoord / hs, tail / hs, head / hs,
                               TAIL_WIDTH, 1.0);

    float fade  = 1.0 - smoothstep(DURATION_TAIL * 0.4, DURATION_TAIL, t);
    float body  = (1.0 - smoothstep(0.0, 0.15, d)) * TRAIL_ALPHA;
    float glow  = (1.0 - smoothstep(0.0, 1.6, d)) * GLOW_ALPHA;
    float alpha = (body + glow) * fade;

    fragColor.rgb = mix(fragColor.rgb, iCurrentCursorColor.rgb, clamp(alpha, 0.0, 1.0));
}
