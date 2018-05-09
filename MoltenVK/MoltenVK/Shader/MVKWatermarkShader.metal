/*
 * MVKWatermarkShader.metal
 *
 * Copyright (c) 2014-2018 The Brenwill Workshop Ltd. (http://www.brenwill.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


/** This file contains source code for the Watermark shaders. */

#include <metal_stdlib>
using namespace metal;

typedef struct {
    float4x4 mvpMtx;
    float4 color;
} Uniforms;

typedef struct {
    float2 a_position    [[attribute(0)]];
    float2 a_texCoord    [[attribute(1)]];
} Attributes;

typedef struct {
    float4 gl_Position [[position]];
    float2 v_texCoord;
    float4 v_fragColor;
} Varyings;

vertex Varyings watermarkVertex(Attributes attributes [[stage_in]],
                                constant Uniforms& uniforms [[ buffer(0) ]]) {
    Varyings varyings;
    varyings.gl_Position = uniforms.mvpMtx * float4(attributes.a_position, 0.0, 1.0);
    varyings.v_fragColor = uniforms.color;
    varyings.v_texCoord = attributes.a_texCoord;
    return varyings;
}

fragment float4 watermarkFragment(Varyings varyings [[stage_in]],
                                  texture2d<float> texture [[ texture(0) ]],
                                  sampler sampler  [[ sampler(0) ]]) {
    return varyings.v_fragColor * texture.sample(sampler, varyings.v_texCoord);
};
