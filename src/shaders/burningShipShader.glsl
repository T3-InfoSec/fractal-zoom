precision highp float;

uniform vec2 u_resolution; // the size of the canvas
uniform float u_aspectRatio;
uniform vec2 u_offset; // the center of the view
uniform float u_zoomSize; // the scale of the view
uniform float u_maxIterations; // the maximum number of iterations
uniform float u_gridSize; // the size of the grid
uniform vec2 u_selectedPosition; // the selected position

uniform int u_color_scheme;


// =================================
// === COMPLEX NUMBER OPERATIONS ===
// =================================

vec2 cm (vec2 a, vec2 b) {
    return vec2(a.x*b.x - a.y*b.y, a.x*b.y + b.x*a.y);
}

vec2 conj (vec2 a) {
    return vec2(a.x, -a.y);
}

// =====================
// === COLOR SCHEMES ===
// =====================


vec4 basic_colormap(float s, vec3 shade) {
    vec3 coord = vec3(s, s, s);

    return vec4(pow(coord, shade), 1.0);
}

vec4 custom_colormap_1(float s) {
    vec3 color_1 = vec3(0.22, 0.07, 0.08);
    vec3 color_2 = vec3(0.29, 0.08, 0.08);
    vec3 color_3 = vec3(0.49, 0.11, 0.09);
    vec3 color_4 = vec3(0.66, 0.26, 0.14);
    vec3 color_5 = vec3(0.78, 0.47, 0.24);
    vec3 color_6 = vec3(0.87, 0.72, 0.39);
    vec3 color_7 = vec3(0.9, 0.87, 0.55);
    vec3 color_8 = vec3(0.85, 0.96, 0.67);

    vec3 color;

    if (s < 0.143) {
        float x = 7.0 * s;
        color = (1.0 - x) * color_1 + x * color_2;
    }
    else if (s < 0.286) {
        float x = 7.0 * (s - 0.143);
        color = (1.0 - x) * color_2 + x * color_3;
    }
    else if (s < 0.423) {
        float x = 7.0 * (s - 0.286);
        color = (1.0 - x) * color_3 + x * color_4;
    }
    else if (s < 0.571) {
        float x = 7.0 * (s - 0.423);
        color = (1.0 - x) * color_4 + x * color_5;
    }
    else if (s < 0.714) {
        float x = 7.0 * (s - 0.571);
        color = (1.0 - x) * color_5 + x * color_6;
    }
    else if (s < 0.857) {
        float x = 7.0 * (s - 0.714);
        color = (1.0 - x) * color_6 + x * color_7;
    }
    else {
        float x = 7.0 * (s - 0.857);
        color = (1.0 - x) * color_7 + x * color_8;
    }

    return vec4(color, 1.0);
}

vec4 custom_colormap_2(float s) {
    vec3 color_1 = vec3(0.04, 0.08, 0.09);
    vec3 color_2 = vec3(0.06, 0.26, 0.33);
    vec3 color_3 = vec3(0.14, 0.35, 0.61);
    vec3 color_4 = vec3(0.30, 0.37, 0.80);
    vec3 color_5 = vec3(0.43, 0.40, 0.86);
    vec3 color_6 = vec3(0.55, 0.44, 0.91);
    vec3 color_7 = vec3(0.78, 0.56, 0.96);
    vec3 color_8 = vec3(0.97, 0.86, 0.98);

    vec3 color;

    if (s < 0.143) {
        float x = 7.0 * s;
        color = (1.0 - x) * color_1 + x * color_2;
    }
    else if (s < 0.286) {
        float x = 7.0 * (s - 0.143);
        color = (1.0 - x) * color_2 + x * color_3;
    }
    else if (s < 0.423) {
        float x = 7.0 * (s - 0.286);
        color = (1.0 - x) * color_3 + x * color_4;
    }
    else if (s < 0.571) {
        float x = 7.0 * (s - 0.423);
        color = (1.0 - x) * color_4 + x * color_5;
    }
    else if (s < 0.714) {
        float x = 7.0 * (s - 0.571);
        color = (1.0 - x) * color_5 + x * color_6;
    }
    else if (s < 0.857) {
        float x = 7.0 * (s - 0.714);
        color = (1.0 - x) * color_6 + x * color_7;
    }
    else {
        float x = 7.0 * (s - 0.857);
        color = (1.0 - x) * color_7 + x * color_8;
    }

    return vec4(color, 1.0);
}

vec4 custom_colormap_3(float s) {
    vec3 color_1 = vec3(0.27, 0.0, 0.19);
    vec3 color_2 = vec3(0.43, 0.02, 0.45);
    vec3 color_3 = vec3(0.55, 0.06, 0.7);
    vec3 color_4 = vec3(0.65, 0.16, 0.93);
    vec3 color_5 = vec3(0.68, 0.42, 0.98);
    vec3 color_6 = vec3(0.73, 0.61, 0.99);
    vec3 color_7 = vec3(0.77, 0.81, 0.96);
    vec3 color_8 = vec3(0.92, 0.91, 1.0);

    vec3 color;

    if (s < 0.143) {
        float x = 7.0 * s;
        color = (1.0 - x) * color_1 + x * color_2;
    }
    else if (s < 0.286) {
        float x = 7.0 * (s - 0.143);
        color = (1.0 - x) * color_2 + x * color_3;
    }
    else if (s < 0.423) {
        float x = 7.0 * (s - 0.286);
        color = (1.0 - x) * color_3 + x * color_4;
    }
    else if (s < 0.571) {
        float x = 7.0 * (s - 0.423);
        color = (1.0 - x) * color_4 + x * color_5;
    }
    else if (s < 0.714) {
        float x = 7.0 * (s - 0.571);
        color = (1.0 - x) * color_5 + x * color_6;
    }
    else if (s < 0.857) {
        float x = 7.0 * (s - 0.714);
        color = (1.0 - x) * color_6 + x * color_7;
    }
    else {
        float x = 7.0 * (s - 0.857);
        color = (1.0 - x) * color_7 + x * color_8;
    }

    return vec4(color, 1.0);
}

// ============
// === MAIN ===
// ============
// =================================
// === COMPLEX NUMBER OPERATIONS ===
// =================================

vec2 complexPower(vec2 z, vec2 p) {
    // Convert z to polar coordinates
    float r = length(z);
    float theta = atan(z.y, z.x);
    if(r == 0.0) return vec2(0.0);
    // Take the natural log and multiply
    float lnr = log(r);

    float newR = exp(p.x * lnr - p.y * theta);
    float newTheta = p.y * lnr + p.x * theta;

//    // Convert back to rectangular coordinates with safety checks
//    float maxValue = 1e6;
//    if (newR > maxValue) newR = maxValue;

    return vec2(
    newR * cos(newTheta),
    newR * sin(newTheta)
    );
}

float burningShip(vec2 point) {
    point = vec2(point.x, -point.y);
    vec2 z = vec2(0.0);
    float alpha = 1.0;

    for (float i = 0.0; i < u_maxIterations; i += 1.0) {
        if (i >= u_maxIterations) break;

        z = vec2(abs(z.x), abs(z.y)); // Apply burning ship absolute value

//        // Add safety check before complex power
//        if (length(z) > 1e10) {
//            alpha = i / u_maxIterations;
//            break;
//        }

        z = complexPower(z, vec2(2.0, 2.3)) + point;

        if (dot(z, z) > 1000.0*u_zoomSize) {
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

    vec2 z = u_zoomSize * vec2(u_aspectRatio, 1.0) * gl_FragCoord.xy / u_resolution + u_offset;

    vec3 color = vec3(0.0);
    float s = 1.0 - burningShip(z);
     if (u_color_scheme == 0) {
        vec3 shade = vec3(5.38, 6.15, 3.85);
        color = basic_colormap(s, shade).xyz;
     }
    else if (u_color_scheme == 1) {
        vec3 shade = vec3(7.0, 3.0, 2.0);
        color = basic_colormap(s, shade).xyz;
    }
    else if (u_color_scheme == 2) {
        color = custom_colormap_1(pow(s, 6.0)).xyz;
    }
    else if (u_color_scheme == 3) {
        color = custom_colormap_2(pow(s, 6.0)).xyz;
    }
    else {
        color = custom_colormap_3(pow(s, 6.0)).xyz;
    }
//
//    if(z.x < u_gridSize*100.0 && z.x > -u_gridSize*100.0 && z.y < u_gridSize*100.0 && z.y > -u_gridSize*100.0) {
//        color = vec3(1.0, vec2(0.0));
//    }

    if((((z.x<u_selectedPosition.x + u_gridSize*0.5 && z.x>u_selectedPosition.x + u_gridSize*0.5 - u_gridSize*.05)
    || (z.x>u_selectedPosition.x - u_gridSize*0.5 && z.x<u_selectedPosition.x - u_gridSize*0.5 + u_gridSize*.05))
    && z.y<u_selectedPosition.y + u_gridSize*0.5 && z.y>u_selectedPosition.y - u_gridSize*0.5)
    || ((z.y<u_selectedPosition.y + u_gridSize*0.5 && z.y>u_selectedPosition.y + u_gridSize*0.5 - u_gridSize*.05)
    || (z.y>u_selectedPosition.y - u_gridSize*0.5 && z.y<u_selectedPosition.y - u_gridSize*0.5 + u_gridSize*.05))
    && z.x<u_selectedPosition.x + u_gridSize*0.5 && z.x>u_selectedPosition.x - u_gridSize*0.5) {
        color = vec3(0.0, 1.0, 0.0); // this helps in highlighting the selected point
        gl_FragColor = vec4(color, 1.0);
        return;
    }

    if(u_zoomSize <= 0.0001) {
//        float gridLines = grid(z, 0.1* 0.0001);
//        vec3 gridColor = vec3(1.0);
//
//        color = mix(gridColor, color, gridLines);
    }
    gl_FragColor = vec4(color, 1.0);
}
