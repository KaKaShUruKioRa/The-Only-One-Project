/*
 * Copyright (C) 2010-2012 cgwg, Themaister and DOLLS
 * Copyright (C) 2018 Christopho, Solarus - http://www.solarus-games.org
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

// CRT-interlaced shader from the bsnes project.
// Like the standard CRT shader, but detects when the emulator is outputting
// interlaced frames and draws each field at the appropriate location.
// https://gitorious.org/bsnes/xml-shaders
// Adapted for Solarus by Christopho.

#if __VERSION__ >= 130
#define COMPAT_VARYING in
#define COMPAT_TEXTURE texture
out vec4 FragColor;
#else
#define COMPAT_VARYING varying
#define FragColor gl_FragColor
#define COMPAT_TEXTURE texture2D
#endif

#ifdef GL_ES
precision mediump float;
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif

uniform sampler2D sol_texture;
COMPAT_VARYING vec2 sol_vtex_coord;
COMPAT_VARYING vec4 sol_vcolor;

// Comment the next line to disable interpolation in linear gamma (and
// gain speed).
#define LINEAR_PROCESSING

// Enable screen curvature.
#define CURVATURE

// Enable 3x oversampling of the beam profile
#define OVERSAMPLE

// Use the older, purely gaussian beam profile
//#define USEGAUSSIAN

// Macros.
#define FIX(c) max(abs(c), 1e-5);
#define PI 3.141592653589

#ifdef LINEAR_PROCESSING
#   define TEX2D(c) pow(COMPAT_TEXTURE(sol_texture, (c)), vec4(CRTgamma))
#else
#   define TEX2D(c) COMPAT_TEXTURE(sol_texture, (c))
#endif

uniform vec2 sol_input_size;
uniform vec2 sol_output_size;
vec2 sol_texture_size = sol_input_size;
uniform int sol_time;

varying vec2 texCoord;
varying vec2 one;
varying float mod_factor;
varying vec2 ilfac;

varying float CRTgamma;
varying float monitorgamma;

varying vec2 overscan;
varying vec2 aspect;

varying float d;
varying float R;

varying float cornersize;
varying float cornersmooth;

varying vec3 stretch;
varying vec2 sinangle;
varying vec2 cosangle;

float intersect(vec2 xy)
{
    float A = dot(xy,xy)+d*d;
    float B = 2.0*(R*(dot(xy,sinangle)-d*cosangle.x*cosangle.y)-d*d);
    float C = d*d + 2.0*R*d*cosangle.x*cosangle.y;
    return (-B-sqrt(B*B-4.0*A*C))/(2.0*A);
}

vec2 bkwtrans(vec2 xy)
{
    float c = intersect(xy);
    vec2 point = vec2(c)*xy;
    point -= vec2(-R)*sinangle;
    point /= vec2(R);
    vec2 tang = sinangle/cosangle;
    vec2 poc = point/cosangle;
    float A = dot(tang,tang)+1.0;
    float B = -2.0*dot(poc,tang);
    float C = dot(poc,poc)-1.0;
    float a = (-B+sqrt(B*B-4.0*A*C))/(2.0*A);
    vec2 uv = (point-a*sinangle)/cosangle;
    float r = FIX(R*acos(a));
    return uv*r/sin(r/R);
}

vec2 transform(vec2 coord)
{
    coord *= sol_texture_size / sol_input_size;
    coord = (coord-vec2(0.5))*aspect*stretch.z+stretch.xy;
    return (bkwtrans(coord)/overscan/aspect+vec2(0.5)) * sol_input_size / sol_texture_size;
}

float corner(vec2 coord)
{
    coord *= sol_texture_size / sol_input_size;
    coord = (coord - vec2(0.5)) * overscan + vec2(0.5);
    coord = min(coord, vec2(1.0)-coord) * aspect;
    vec2 cdist = vec2(cornersize);
    coord = (cdist - min(coord,cdist));
    float dist = sqrt(dot(coord,coord));
    return clamp((cdist.x-dist)*cornersmooth,0.0, 1.0);
}

// Calculate the influence of a scanline on the current pixel.
//
// 'distance' is the distance in texture coordinates from the current
// pixel to the scanline in question.
// 'color' is the colour of the scanline at the horizontal location of
// the current pixel.
vec4 scanlineWeights(float distance, vec4 color)
{
    // "wid" controls the width of the scanline beam, for each RGB
    // channel The "weights" lines basically specify the formula
    // that gives you the profile of the beam, i.e. the intensity as
    // a function of distance from the vertical center of the
    // scanline. In this case, it is gaussian if width=2, and
    // becomes nongaussian for larger widths. Ideally this should
    // be normalized so that the integral across the beam is
    // independent of its width. That is, for a narrower beam
    // "weights" should have a higher peak at the center of the
    // scanline than for a wider beam.
#ifdef USEGAUSSIAN
    vec4 wid = 0.3 + 0.1 * pow(color, vec4(3.0));
    vec4 weights = vec4(distance / wid);
    return 0.4 * exp(-weights * weights) / wid;
#else
    vec4 wid = 2.0 + 2.0 * pow(color, vec4(4.0));
    vec4 weights = vec4(distance / 0.3);
    return 1.4 * exp(-pow(weights * inversesqrt(0.5 * wid), wid)) / (0.6 + 0.2 * wid);
#endif
}

void main()
{
    // Here's a helpful diagram to keep in mind while trying to
    // understand the code:
    //
    //  |      |      |      |      |
    // -------------------------------
    //  |      |      |      |      |
    //  |  01  |  11  |  21  |  31  | <-- current scanline
    //  |      | @    |      |      |
    // -------------------------------
    //  |      |      |      |      |
    //  |  02  |  12  |  22  |  32  | <-- next scanline
    //  |      |      |      |      |
    // -------------------------------
    //  |      |      |      |      |
    //
    // Each character-cell represents a pixel on the output
    // surface, "@" represents the current pixel (always somewhere
    // in the bottom half of the current scan-line, or the top-half
    // of the next scanline). The grid of lines represents the
    // edges of the texels of the underlying texture.

    // Texture coordinates of the texel containing the active pixel.
#ifdef CURVATURE
    vec2 xy = transform(texCoord);
#else
    vec2 xy = texCoord;
#endif
    float cval = corner(xy);

    // Of all the pixels that are mapped onto the texel we are
    // currently rendering, which pixel are we currently rendering?
    vec2 ilvec = vec2(0.0,ilfac.y > 1.5 ? mod(float(sol_time)/10.0,2.0) : 0.0);
    vec2 ratio_scale = (xy * sol_texture_size - vec2(0.5) + ilvec)/ilfac;
#ifdef OVERSAMPLE
    float filter = fwidth(ratio_scale.y);
#endif
    vec2 uv_ratio = fract(ratio_scale);

    // Snap to the center of the underlying texel.
    xy = (floor(ratio_scale)*ilfac + vec2(0.5) - ilvec) / sol_texture_size;

    // Calculate Lanczos scaling coefficients describing the effect
    // of various neighbour texels in a scanline on the current
    // pixel.
    vec4 coeffs = PI * vec4(1.0 + uv_ratio.x, uv_ratio.x, 1.0 - uv_ratio.x, 2.0 - uv_ratio.x);

    // Prevent division by zero.
    coeffs = FIX(coeffs);

    // Lanczos2 kernel.
    coeffs = 2.0 * sin(coeffs) * sin(coeffs / 2.0) / (coeffs * coeffs);

    // Normalize.
    coeffs /= dot(coeffs, vec4(1.0));

    // Calculate the effective colour of the current and next
    // scanlines at the horizontal location of the current pixel,
    // using the Lanczos coefficients above.
    vec4 col  = clamp(mat4(
        TEX2D(xy + vec2(-one.x, 0.0)),
        TEX2D(xy),
        TEX2D(xy + vec2(one.x, 0.0)),
        TEX2D(xy + vec2(2.0 * one.x, 0.0))) * coeffs,
        0.0, 1.0);
    vec4 col2 = clamp(mat4(
        TEX2D(xy + vec2(-one.x, one.y)),
        TEX2D(xy + vec2(0.0, one.y)),
        TEX2D(xy + one),
        TEX2D(xy + vec2(2.0 * one.x, one.y))) * coeffs,
        0.0, 1.0);

#ifndef LINEAR_PROCESSING
    col  = pow(col , vec4(CRTgamma));
    col2 = pow(col2, vec4(CRTgamma));
#endif

    // Calculate the influence of the current and next scanlines on
    // the current pixel.
    vec4 weights  = scanlineWeights(uv_ratio.y, col);
    vec4 weights2 = scanlineWeights(1.0 - uv_ratio.y, col2);
#ifdef OVERSAMPLE
    uv_ratio.y =uv_ratio.y+1.0/3.0*filter;
    weights = (weights+scanlineWeights(uv_ratio.y, col))/3.0;
    weights2=(weights2+scanlineWeights(abs(1.0-uv_ratio.y), col2))/3.0;
    uv_ratio.y =uv_ratio.y-2.0/3.0*filter;
    weights=weights+scanlineWeights(abs(uv_ratio.y), col)/3.0;
    weights2=weights2+scanlineWeights(abs(1.0-uv_ratio.y), col2)/3.0;
#endif
    vec3 mul_res  = (col * weights + col2 * weights2).rgb * vec3(cval);

    // dot-mask emulation:
    // Output pixels are alternately tinted green and magenta.
    vec3 dotMaskWeights = mix(
        vec3(1.0, 0.7, 1.0),
        vec3(0.7, 1.0, 0.7),
        floor(mod(mod_factor, 2.0))
    );

    mul_res *= dotMaskWeights;

    // Convert the image gamma for display on our output device.
    mul_res = pow(mul_res, vec3(1.0 / monitorgamma));

    // Color the texel.
    FragColor = vec4(mul_res, 1.0);
}
