// burning_ship.frag
#include <flutter/runtime_effect.glsl>

precision mediump float;
out vec4 fragColor;

uniform vec2 u_resolution;
uniform vec2 u_offset;
uniform float u_zoom;
uniform float u_maxIterations;

void main() {
    vec2 c = (gl_FragCoord.xy / u_resolution - 0.5) * u_zoom + u_offset;
    vec2 z = vec2(0.0);
    int iter = 0;

    for (int i = 0; i < 1000; i++) {
        if (i >= u_maxIterations) break;
        z = vec2(abs(z.x), abs(z.y));
        z = vec2(
        z.x * z.x - z.y * z.y + c.x,
        2.0 * z.x * z.y + c.y
        );
        if (dot(z, z) > 4.0) break;
        iter = i;
    }

    float color = float(iter) / float(u_maxIterations);
    fragColor = vec4(vec3(color), 1.0);
}
