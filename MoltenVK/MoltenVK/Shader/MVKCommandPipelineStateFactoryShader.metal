/*
 * MVKCommandPipelineStateFactoryShader.metal
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


/** This file contains source code for the MoltenVK command shaders. */

#include <metal_stdlib>                                                                                         
using namespace metal;                                                                                          

typedef struct {                                                                                                
    float2 a_position    [[attribute(0)]];
} AttributesPos;                                                                                                

typedef struct {                                                                                                
    float4 gl_Position [[position]];
} VaryingsPos;                                                                                                  

typedef struct {                                                                                                
    float2 a_position    [[attribute(0)]];
    float2 a_texCoord    [[attribute(1)]];
} AttributesPosTex;                                                                                             

typedef struct {                                                                                                
    float4 gl_Position [[position]];
    float2 v_texCoord;
} VaryingsPosTex;                                                                                               

vertex VaryingsPosTex vtxCmdBlitImage(AttributesPosTex attributes [[stage_in]]) {                               
    VaryingsPosTex varyings;
    varyings.gl_Position = float4(attributes.a_position, 0.0, 1.0);
    varyings.v_texCoord = attributes.a_texCoord;
    return varyings;
}                                                                                                               

vertex VaryingsPos vtxCmdBlitImageD(AttributesPosTex attributes [[stage_in]],                                   
                                    depth2d<float> texture [[texture(0)]],
                                    sampler sampler  [[ sampler(0) ]]) {
    float depth = texture.sample(sampler, attributes.a_texCoord);
    VaryingsPos varyings;
    varyings.gl_Position = float4(attributes.a_position, depth, 1.0);
    return varyings;
}                                                                                                               

typedef struct {                                                                                                
    float4 colors[9];
} ClearColorsIn;                                                                                                

vertex VaryingsPos vtxCmdClearAttachments(AttributesPos attributes [[stage_in]],                                
                                          constant ClearColorsIn& ccIn [[buffer(0)]]) {
    VaryingsPos varyings;
    varyings.gl_Position = float4(attributes.a_position.x, -attributes.a_position.y, ccIn.colors[8].r, 1.0);
    return varyings;
}                                                                                                               

typedef struct {                                                                                                
    uint32_t srcOffset;
    uint32_t dstOffset;
    uint32_t copySize;
} CopyInfo;                                                                                                     

kernel void compCopyBufferBytes(device uint8_t* src [[ buffer(0) ]],                                            
                                device uint8_t* dst [[ buffer(1) ]],
                                constant CopyInfo& info [[ buffer(2) ]]) {
    for (size_t i = 0; i < info.copySize; i++) {
        dst[i + info.dstOffset] = src[i + info.srcOffset];
    }
};                                                                                                              
