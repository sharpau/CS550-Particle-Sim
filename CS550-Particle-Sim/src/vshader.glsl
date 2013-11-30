#version 150 core

in  vec4 vPosition;
in  vec4 vNormal;
in	vec4 vColor;

out vec4 color;
// for transform buffer
out vec4 world_space_position;

uniform vec4 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform vec4 LightPosition;
uniform float Shininess;

// params for selection
// flag: 0 == normal, 1 == selection, 2 == absolute coloring (manipulators)
uniform int flag;
uniform int selectionColorR;
uniform int selectionColorG;
uniform int selectionColorB;
uniform int selectionColorA;

void main()
{
    // Transform vertex  position into eye coordinates
    vec4 pos = (ModelView * vPosition);
	world_space_position = pos;

    vec3 L = vec3(normalize( (ModelView * LightPosition) - pos ));
    vec3 E = vec3(normalize( -pos ));
    vec3 H = normalize( L + E );  //halfway vector

    //To correctly transform normals
    vec3      N = normalize( transpose(inverse( ModelView )) * vNormal ).xyz;

    // Compute terms in the illumination equation
    vec4 ambient = AmbientProduct;

    float dr = max( dot(L, N), 0.0 );
    vec4  diffuse = dr *DiffuseProduct;

    float sr = pow( max(dot(N, H), 0.0), Shininess );
    vec4  specular = sr * SpecularProduct;

    if( dot(L, N) < 0.0 ) {
	specular = vec4(0.0, 0.0, 0.0, 1.0);
    }

    gl_Position = Projection * pos;
	color = vColor;
    
}