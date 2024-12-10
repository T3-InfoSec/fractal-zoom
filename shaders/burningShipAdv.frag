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

float grid(vec2 uv, float gridSize) {
    vec2 gridLines = fract(uv / gridSize);
    return step(500.0*u_zoomSize, gridLines.x) * step(500.0*u_zoomSize, gridLines.y);
}

void main() {
    float u_aspectRatio = u_resolution.x / u_resolution.y;
    vec2 z = u_zoomSize * vec2(u_aspectRatio, 1.0) * gl_FragCoord.xy / u_resolution + u_offset;
    float alpha = burningShip(z);

    // Color scheme
    vec3 color = vec3(1.0 - alpha);
    vec3 shade = vec3(5.38, 6.15, 3.85);
    color = pow(color, shade);
//
//    if(z.x < 0.01 && z.x > -0.01 && z.y < 0.01 && z.y > -0.01) {
//        color = vec3(0.0, 1.0, 0.0); // Highlight color
//        fragColor = vec4(color, 1.0);
//        return;
//    }

    if((((z.x<u_selectedPosition.x + u_gridSize*0.5 && z.x>u_selectedPosition.x + u_gridSize*0.5 - u_gridSize*.05)
    || (z.x>u_selectedPosition.x - u_gridSize*0.5 && z.x<u_selectedPosition.x - u_gridSize*0.5 + u_gridSize*.05))
    && z.y<u_selectedPosition.y + u_gridSize*0.5 && z.y>u_selectedPosition.y - u_gridSize*0.5)
    || ((z.y<u_selectedPosition.y + u_gridSize*0.5 && z.y>u_selectedPosition.y + u_gridSize*0.5 - u_gridSize*.05)
    || (z.y>u_selectedPosition.y - u_gridSize*0.5 && z.y<u_selectedPosition.y - u_gridSize*0.5 + u_gridSize*.05))
    && z.x<u_selectedPosition.x + u_gridSize*0.5 && z.x>u_selectedPosition.x - u_gridSize*0.5) {
        color = vec3(0.0, 1.0, 0.0); // this helps in highlighting the selected point
        fragColor = vec4(color, 1.0);
        return;
    }

    // Grid

    if(u_zoomSize <= 0.0001) {
        float gridLines = grid(z, 0.1* 0.0001);
        vec3 gridColor = vec3(1.0);

        color = mix(gridColor, color, gridLines);
    }

    fragColor = vec4(color, 1.0);
}
