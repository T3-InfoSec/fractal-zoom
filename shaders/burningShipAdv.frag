#include <flutter/runtime_effect.glsl>
precision highp float;
out vec4 fragColor;

uniform vec2 u_resolution;
uniform vec2 u_offset;
uniform float u_zoomSize;
uniform float u_maxIterations;
uniform float u_color_scheme;


vec4 basic_colormap(float s, vec3 shade) {
    vec3 coord = vec3(s, s, s);

    return vec4(pow(coord, shade), 1.0);
}

// Burning ship computation
float burningShip(vec2 point) {
    vec2 z = vec2(0.0);
    float alpha = 1.0;

    for (float i = 0.0; i < 500.0; i += 1.0) {
        if (i >= u_maxIterations) break;

        z = vec2(abs(z.x), abs(z.y)); // Apply burning ship absolute value
        z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + point; // Mandelbrot formula

        if (dot(z, z) > 4.0) {
            alpha = i / u_maxIterations;
            break;
        }
    }
    return alpha;
}

void main() {
    vec2 z = (gl_FragCoord.xy / u_resolution - 0.5) * u_zoomSize + u_offset;
    float alpha = burningShip(z);

    // Color scheme
    vec3 color = vec3(1.0 - alpha);
    vec3 shade = vec3(5.38, 6.15, 3.85);
    color = basic_colormap(1-alpha, shade).xyz;

    fragColor = vec4(color, 1.0);
}
