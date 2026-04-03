#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uResolution;
uniform sampler2D uTexture;
uniform float uStrength;
uniform float uRadius;
uniform vec2 uCenter;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    vec2 center = uCenter;
    vec2 dir = uv - center;

    float aspect = uResolution.x / uResolution.y;
    vec2 circularDir = vec2(dir.x * aspect, dir.y);
    float dist = length(circularDir);

    vec4 finalColor = vec4(0.0);

    if (dist < uRadius) {
        float normalizedDist = dist / uRadius;
        float curve = cos(normalizedDist * 1.57079632679);
        float effectFactor = 1.0 - curve;
        const int SAMPLES = 12;
        const float GOLDEN_ANGLE = 2.3999632;
        float blurAmount = abs(uStrength) * effectFactor * 0.03;
        float dispersionBase = uStrength * effectFactor;
        float magR = 1.0 - dispersionBase * 1.08;
        float magG = 1.0 - dispersionBase * 1.00;
        float magB = 1.0 - dispersionBase * 0.92;

        for (int i = 0; i < SAMPLES; i++) {
            float r = sqrt(float(i) / float(SAMPLES));
            float theta = float(i) * GOLDEN_ANGLE;
            vec2 offset = vec2(cos(theta), sin(theta)) * r * blurAmount;
            vec2 correctedOffset = vec2(offset.x / aspect, offset.y);
            finalColor.r += texture(uTexture, center + (dir + correctedOffset) * magR).r;
            finalColor.g += texture(uTexture, center + (dir + correctedOffset) * magG).g;
            finalColor.b += texture(uTexture, center + (dir + correctedOffset) * magB).b;
        }
        finalColor /= float(SAMPLES);
        finalColor.a = 1.0;

    } else {
        finalColor = texture(uTexture, uv);
    }

    fragColor = finalColor;
}
