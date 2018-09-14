//
//  File.metal
//  Unit
//
//  Created by CPU11367 on 9/9/18.
//  Copyright © 2018 CPU11367. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertex(
    const device packed_float2* vertex_array [[ buffer(0) ]],
    unsigned int vid [[ vertex_id ]]) {
    return float4(vertex_array[vid], 0.0, 1.0);
}

fragment half4 basic_fragment() {
    return half4(1.0);
}
