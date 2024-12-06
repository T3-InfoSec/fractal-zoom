#include <flutter/runtime_effect.glsl>
precision highp float;
out vec4 fragColor;

uniform vec2 u_resolution;
uniform vec2 u_offset;
uniform float u_zoomSize;
uniform float u_maxIterations;
uniform float u_gridSize;
uniform vec2 u_selectedPosition;


// === COMPLEX NUMBER OPERATIONS ===
// =================================

vec2 complexPower(vec2 z, vec2 p) {
    float r = length(z);
    float theta = atan(z.y, z.x);
    if(r == 0.0) return vec2(0.0);
    float lnr = log(r);

    float newR = exp(p.x * lnr - p.y * theta);
    float newTheta = p.y * lnr + p.x * theta;

    return vec2(
    newR * cos(newTheta),
    newR * sin(newTheta)
    );
}


// Burning ship computation
float burningShip(vec2 point) {
    vec2 z = vec2(0.0);
    float alpha = 1.0;

    for (float i = 0.0; i < 500.0; i += 1.0) {
        if (i >= u_maxIterations) break;

        z = vec2(abs(z.x), abs(z.y)); // Apply burning ship absolute value
        z = complexPower(z, vec2(2.0,0.0)) + point; // Burning ship formula

        if (dot(z, z) > max(1000.0*u_zoomSize, 1000)) {
            alpha = i / u_maxIterations;
            break;
        }
    }
    return alpha;
}

void main() {
    float u_aspectRatio = u_resolution.x / u_resolution.y;
    vec2 z = u_zoomSize * vec2(u_aspectRatio, 1.0) * gl_FragCoord.xy / u_resolution + u_offset;
    float alpha = burningShip(z);

    // Color scheme
    vec3 color = vec3(1.0 - alpha);
    vec3 shade = vec3(5.38, 6.15, 3.85);
    color = pow(color, shade);

    float halfGrid = u_gridSize * 0.5;
    float border = u_gridSize * 0.05; // Border range for highlighting

    bool withinXRange = abs(z.x - u_selectedPosition.x) <= halfGrid + border;
    bool withinYRange = abs(z.y - u_selectedPosition.y) <= halfGrid + border;

    if(z.x < 0.01 && z.x > -0.01 && z.y < 0.01 && z.y > -0.01) {
        color = vec3(0.0, 1.0, 0.0); // Highlight color
        fragColor = vec4(color, 1.0);
        return;
    }

    if (withinXRange && withinYRange) {
        color = vec3(0.0, 1.0, 0.0); // Highlight color
        fragColor = vec4(color, 1.0);
        return;
    }

    fragColor = vec4(color, 1.0);
}
